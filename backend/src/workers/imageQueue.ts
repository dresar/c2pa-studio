import { Queue, Worker, Job, QueueEvents } from 'bullmq';
import { getRedisClient } from '../config/redis';
import { logger } from '../utils/logger';
import { MetadataService } from '../services/metadata.service';
import { C2paService } from '../services/c2pa.service';
import { StorageService } from '../services/storage.service';
import { ImageProcessingService } from '../services/imageProcessing.service';
import { ImageRepository } from '../repositories/image.repository';
import { HistoryRepository } from '../repositories/history.repository';
import { ProjectRepository } from '../repositories/project.repository';
import { safeDeleteFile } from '../utils/fs';

// ─────────────────────────────────────────────
// Image Processing Queue
// ─────────────────────────────────────────────

export type ImageJobType =
  | 'SCAN_METADATA'
  | 'COMPRESS'
  | 'RESIZE'
  | 'CONVERT'
  | 'REMOVE_EXIF'
  | 'REMOVE_GPS'
  | 'REMOVE_METADATA'
  | 'REMOVE_C2PA'
  | 'CREATE_C2PA'
  | 'UPLOAD_TO_IMAGEKIT';

export interface ImageJobData {
  type: ImageJobType;
  imageId: string;
  projectId: string;
  userId: string;
  filePath?: string;
  options?: Record<string, unknown>;
}

export const IMAGE_QUEUE_NAME = 'image-processing';

let imageQueue: Queue<ImageJobData> | null = null;
let imageWorker: Worker<ImageJobData> | null = null;

const metadataService = new MetadataService();
const c2paService = new C2paService();
const storageService = new StorageService();
const imageProcessingService = new ImageProcessingService();

// ─────────────────────────────────────────────
// Get or create queue instance
// ─────────────────────────────────────────────
export function getImageQueue(): Queue<ImageJobData> {
  if (!imageQueue) {
    imageQueue = new Queue<ImageJobData>(IMAGE_QUEUE_NAME, {
      connection: getRedisClient(),
      defaultJobOptions: {
        attempts: 3,
        backoff: { type: 'exponential', delay: 2000 },
        removeOnComplete: { count: 100 },
        removeOnFail: { count: 50 },
      },
    });

    logger.info(`Queue "${IMAGE_QUEUE_NAME}" created`);
  }
  return imageQueue;
}

// ─────────────────────────────────────────────
// Add job to queue
// ─────────────────────────────────────────────
export async function enqueueImageJob(data: ImageJobData): Promise<Job<ImageJobData>> {
  const queue = getImageQueue();
  return queue.add(data.type, data, { priority: data.type === 'SCAN_METADATA' ? 1 : 5 });
}

// ─────────────────────────────────────────────
// Start worker
// ─────────────────────────────────────────────
export function startImageWorker(): Worker<ImageJobData> {
  if (imageWorker) return imageWorker;

  imageWorker = new Worker<ImageJobData>(
    IMAGE_QUEUE_NAME,
    async (job) => {
      logger.info({ jobId: job.id, type: job.data.type, imageId: job.data.imageId }, 'Processing job');

      const { type, imageId, filePath, options } = job.data;

      switch (type) {
        case 'SCAN_METADATA':
          await handleScanMetadata(imageId, filePath!);
          break;

        case 'COMPRESS':
          await handleCompress(imageId, filePath!, options ?? {});
          break;

        case 'RESIZE':
          await handleResize(imageId, filePath!, options ?? {});
          break;

        case 'REMOVE_METADATA':
          await handleRemoveMetadata(imageId, filePath!);
          break;

        case 'REMOVE_GPS':
          await handleRemoveGps(imageId, filePath!);
          break;

        case 'REMOVE_C2PA':
          await handleRemoveC2pa(imageId, filePath!);
          break;

        case 'CREATE_C2PA':
          await handleCreateC2pa(imageId, filePath!, options ?? {});
          break;

        case 'UPLOAD_TO_IMAGEKIT':
          await handleUploadToImageKit(imageId, filePath!, job.data.projectId);
          break;

        default:
          logger.warn({ type }, 'Unknown job type');
      }
    },
    {
      connection: getRedisClient(),
      concurrency: 3,
    },
  );

  imageWorker.on('completed', (job) => {
    logger.info({ jobId: job.id, type: job.data.type }, 'Job completed');
  });

  imageWorker.on('failed', (job, err) => {
    logger.error({ jobId: job?.id, type: job?.data.type, err }, 'Job failed');
  });

  logger.info('Image processing worker started');
  return imageWorker;
}

// ─────────────────────────────────────────────
// Job Handlers
// ─────────────────────────────────────────────

async function handleScanMetadata(imageId: string, filePath: string): Promise<void> {
  await ImageRepository.updateStatus(imageId, 'SCANNING');

  const parsed = await metadataService.parse(filePath);
  const c2paResult = await c2paService.read(filePath);

  await ImageRepository.upsertMetadata(imageId, {
    exifData: parsed.exif as any,
    iptcData: parsed.iptc as any,
    xmpData: parsed.xmp as any,
    gpsData: parsed.gps as any,
    iccData: parsed.icc as any,
    cameraModel: parsed.cameraModel,
    cameraMake: parsed.cameraMake,
    lensModel: parsed.lensModel,
    software: parsed.software,
    colorProfile: parsed.colorProfile,
    focalLength: parsed.focalLength,
    aperture: parsed.aperture,
    shutterSpeed: parsed.shutterSpeed,
    iso: parsed.iso,
    capturedAt: parsed.capturedAt,
    modifiedAt: parsed.modifiedAt,
    latitude: parsed.gps?.latitude,
    longitude: parsed.gps?.longitude,
    altitude: parsed.gps?.altitude,
  });

  await ImageRepository.update(imageId, {
    hasExif: parsed.hasExif,
    hasIptc: parsed.hasIptc,
    hasXmp: parsed.hasXmp,
    hasGps: parsed.hasGps,
    hasC2pa: c2paResult.hasC2pa,
    c2paVerified: c2paResult.isVerified,
    status: 'READY',
  });

  if (c2paResult.hasC2pa && c2paResult.manifests?.[0]) {
    const m = c2paResult.manifests[0];
    await ImageRepository.upsertC2paManifest(imageId, {
      isCustom: false,
      isVerified: c2paResult.isVerified,
      creator: m.claim?.producer,
      generator: m.claim?.claimGenerator,
      manifestJson: m as any,
      assertionsJson: m.assertions as any,
      timestamp: m.timestamp ? new Date(m.timestamp) : undefined,
    });
  }

  await HistoryRepository.create(imageId, 'METADATA_SCANNED', 'Metadata scanned automatically');
}

async function handleCompress(
  imageId: string,
  filePath: string,
  options: Record<string, unknown>,
): Promise<void> {
  const { outputPath } = await imageProcessingService.compress(filePath, {
    mode: (options.mode as any) ?? 'balanced',
    quality: options.quality as number,
    keepMetadata: true,
  });

  await ImageRepository.update(imageId, { processedUrl: outputPath });
  await HistoryRepository.create(imageId, 'COMPRESSED', `Compressed (mode: ${options.mode ?? 'balanced'})`);
}

async function handleResize(
  imageId: string,
  filePath: string,
  options: Record<string, unknown>,
): Promise<void> {
  const { outputPath } = await imageProcessingService.resize(filePath, {
    width: options.width as number,
    height: options.height as number,
  });

  await ImageRepository.update(imageId, { processedUrl: outputPath });
  await HistoryRepository.create(imageId, 'RESIZED', `Resized to ${options.width ?? 'auto'}x${options.height ?? 'auto'}`);
}

async function handleRemoveMetadata(imageId: string, filePath: string): Promise<void> {
  const { outputPath } = await imageProcessingService.stripAllMetadata(filePath);
  await ImageRepository.update(imageId, {
    processedUrl: outputPath,
    hasExif: false,
    hasIptc: false,
    hasXmp: false,
    hasGps: false,
  });
  await HistoryRepository.create(imageId, 'METADATA_REMOVED', 'All metadata removed');
}

async function handleRemoveGps(imageId: string, filePath: string): Promise<void> {
  const { outputPath } = await imageProcessingService.stripGps(filePath);
  await ImageRepository.update(imageId, { processedUrl: outputPath, hasGps: false });
  await HistoryRepository.create(imageId, 'GPS_REMOVED', 'GPS data removed');
}

async function handleRemoveC2pa(imageId: string, filePath: string): Promise<void> {
  const outputPath = filePath.replace(/(\.[^.]+)$/, '_no-c2pa$1');
  await c2paService.remove(filePath, outputPath);
  await ImageRepository.deleteC2paManifest(imageId);
  await ImageRepository.update(imageId, {
    processedUrl: outputPath,
    hasC2pa: false,
    c2paVerified: null,
  });
  await HistoryRepository.create(imageId, 'C2PA_REMOVED', 'C2PA manifest removed');
}

async function handleCreateC2pa(
  imageId: string,
  filePath: string,
  options: Record<string, unknown>,
): Promise<void> {
  const outputPath = filePath.replace(/(\.[^.]+)$/, '_c2pa$1');
  const manifest = await c2paService.createCustom(filePath, outputPath, options as any);

  await ImageRepository.upsertC2paManifest(imageId, {
    isCustom: true,
    isVerified: null,
    creator: options.creator as string,
    organization: options.organization as string,
    generator: options.generator as string,
    aiModel: options.aiModel as string,
    prompt: options.prompt as string,
    manifestJson: manifest as any,
    timestamp: new Date(),
  });

  await ImageRepository.update(imageId, {
    processedUrl: outputPath,
    hasC2pa: true,
  });

  await HistoryRepository.create(imageId, 'C2PA_CREATED', 'Custom C2PA manifest created');
}

async function handleUploadToImageKit(
  imageId: string,
  filePath: string,
  projectId: string,
): Promise<void> {
  const image = await ImageRepository.findByIdRaw(imageId);
  if (!image) return;

  const result = await storageService.uploadToImageKit(
    filePath,
    projectId,
    image.sanitizedFilename,
  );

  await ImageRepository.update(imageId, {
    imagekitFileId: result.fileId,
    imagekitUrl: result.url,
    imagekitPath: result.filePath,
    thumbnailUrl: result.thumbnailUrl,
    status: 'READY',
  });

  // Clean up temp file
  await safeDeleteFile(filePath);

  logger.debug({ imageId, url: result.url }, 'Image uploaded to ImageKit');
}

export async function closeImageQueue(): Promise<void> {
  if (imageWorker) {
    await imageWorker.close();
    imageWorker = null;
  }
  if (imageQueue) {
    await imageQueue.close();
    imageQueue = null;
  }
}
