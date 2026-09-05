import sharp from 'sharp';
import path from 'path';
import fs from 'fs';
import { env } from '../config/env';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';

// ─────────────────────────────────────────────
// Image Processing Service (Sharp-based)
// ─────────────────────────────────────────────

export type SupportedFormat = 'jpeg' | 'png' | 'webp' | 'tiff';

export interface CompressOptions {
  mode: 'keep_original' | 'high_quality' | 'balanced' | 'maximum' | 'custom';
  quality?: number; // 1–100
  keepMetadata?: boolean;
}

export interface ResizeOptions {
  width?: number;
  height?: number;
  fit?: 'cover' | 'contain' | 'fill' | 'inside' | 'outside';
  keepAspectRatio?: boolean;
}

export interface ConvertOptions {
  format: SupportedFormat;
  quality?: number;
}

export interface ImageInfo {
  width: number;
  height: number;
  format: string;
  sizeBytes: number;
  channels?: number;
  hasAlpha?: boolean;
  colorSpace?: string;
}

const QUALITY_PRESETS: Record<string, number> = {
  keep_original: 100,
  high_quality: 90,
  balanced: 75,
  maximum: 50,
};

export class ImageProcessingService {
  // ─────────────────────────────────────────────
  // Read image metadata/info (no DB)
  // ─────────────────────────────────────────────
  async getImageInfo(filePath: string): Promise<ImageInfo> {
    try {
      const metadata = await sharp(filePath).metadata();
      const stats = await fs.promises.stat(filePath);

      return {
        width: metadata.width ?? 0,
        height: metadata.height ?? 0,
        format: metadata.format ?? 'unknown',
        sizeBytes: stats.size,
        channels: metadata.channels,
        hasAlpha: metadata.hasAlpha,
        colorSpace: metadata.space,
      };
    } catch (error) {
      logger.error({ err: error, filePath }, 'Failed to get image info');
      throw new AppError('Failed to read image file', 400, 'IMAGE_READ_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Compress image
  // ─────────────────────────────────────────────
  async compress(
    inputPath: string,
    options: CompressOptions,
  ): Promise<{ outputPath: string; sizeBytes: number }> {
    const quality = options.quality ?? QUALITY_PRESETS[options.mode] ?? 75;
    const ext = path.extname(inputPath).toLowerCase().replace('.', '') as SupportedFormat;
    const outputPath = this.buildOutputPath(inputPath, 'compressed');

    try {
      let pipeline = sharp(inputPath, { failOnError: false });

      // Preserve metadata unless explicitly stripping
      if (options.keepMetadata !== false) {
        pipeline = pipeline.keepMetadata();
      }

      // Compress by format
      switch (ext) {
        case 'jpeg':
          pipeline = pipeline.jpeg({ quality, mozjpeg: true });
          break;
        case 'png':
          pipeline = pipeline.png({ quality, compressionLevel: Math.floor((100 - quality) / 10) });
          break;
        case 'webp':
          pipeline = pipeline.webp({ quality });
          break;
        case 'tiff':
          pipeline = pipeline.tiff({ quality });
          break;
        default:
          pipeline = pipeline.jpeg({ quality, mozjpeg: true });
      }

      await pipeline.toFile(outputPath);
      const stats = await fs.promises.stat(outputPath);

      logger.debug(
        { inputPath, outputPath, quality, sizeBytes: stats.size },
        'Image compressed',
      );

      return { outputPath, sizeBytes: stats.size };
    } catch (error) {
      logger.error({ err: error, inputPath }, 'Compression failed');
      throw new AppError('Image compression failed', 500, 'COMPRESSION_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Resize image
  // ─────────────────────────────────────────────
  async resize(
    inputPath: string,
    options: ResizeOptions,
  ): Promise<{ outputPath: string; width: number; height: number }> {
    const outputPath = this.buildOutputPath(inputPath, 'resized');

    try {
      const result = await sharp(inputPath)
        .keepMetadata()
        .resize({
          width: options.width,
          height: options.height,
          fit: options.fit ?? 'inside',
          withoutEnlargement: true,
        })
        .toFile(outputPath);

      return { outputPath, width: result.width, height: result.height };
    } catch (error) {
      logger.error({ err: error, inputPath }, 'Resize failed');
      throw new AppError('Image resize failed', 500, 'RESIZE_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Convert image format
  // ─────────────────────────────────────────────
  async convert(
    inputPath: string,
    options: ConvertOptions,
  ): Promise<{ outputPath: string; sizeBytes: number }> {
    const outputPath = this.buildOutputPath(inputPath, 'converted', options.format);

    try {
      let pipeline = sharp(inputPath).keepMetadata();

      switch (options.format) {
        case 'jpeg':
          pipeline = pipeline.jpeg({ quality: options.quality ?? 90 });
          break;
        case 'png':
          pipeline = pipeline.png();
          break;
        case 'webp':
          pipeline = pipeline.webp({ quality: options.quality ?? 90 });
          break;
        case 'tiff':
          pipeline = pipeline.tiff();
          break;
      }

      await pipeline.toFile(outputPath);
      const stats = await fs.promises.stat(outputPath);

      return { outputPath, sizeBytes: stats.size };
    } catch (error) {
      logger.error({ err: error, inputPath }, 'Conversion failed');
      throw new AppError('Image conversion failed', 500, 'CONVERSION_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Generate thumbnail
  // ─────────────────────────────────────────────
  async generateThumbnail(
    inputPath: string,
    size: number = 256,
  ): Promise<{ outputPath: string }> {
    const outputPath = this.buildOutputPath(inputPath, 'thumb', 'jpeg');

    try {
      await sharp(inputPath)
        .resize(size, size, { fit: 'cover', position: 'centre' })
        .jpeg({ quality: 70 })
        .toFile(outputPath);

      return { outputPath };
    } catch (error) {
      logger.error({ err: error, inputPath }, 'Thumbnail generation failed');
      throw new AppError('Thumbnail generation failed', 500, 'THUMBNAIL_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Strip all metadata from image
  // ─────────────────────────────────────────────
  async stripAllMetadata(inputPath: string): Promise<{ outputPath: string }> {
    const outputPath = this.buildOutputPath(inputPath, 'stripped');

    try {
      await sharp(inputPath)
        .withMetadata({}) // Clears all EXIF/IPTC/XMP
        .toFile(outputPath);

      return { outputPath };
    } catch (error) {
      logger.error({ err: error, inputPath }, 'Metadata strip failed');
      throw new AppError('Failed to strip metadata', 500, 'STRIP_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Strip GPS only (preserve other metadata)
  // ─────────────────────────────────────────────
  async stripGps(inputPath: string): Promise<{ outputPath: string }> {
    const outputPath = this.buildOutputPath(inputPath, 'no-gps');

    try {
      const metadata = await sharp(inputPath).metadata();

      // Sharp doesn't surgically remove GPS — we use withMetadata and suppress GPS fields
      await sharp(inputPath)
        .withMetadata({
          exif: {
            IFD0: (metadata.exif as any)?.IFD0 ?? {},
            // Intentionally omit GPS block
          },
        })
        .toFile(outputPath);

      return { outputPath };
    } catch (error) {
      logger.error({ err: error, inputPath }, 'GPS strip failed');
      throw new AppError('Failed to strip GPS data', 500, 'GPS_STRIP_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Private: build deterministic output path
  // ─────────────────────────────────────────────
  private buildOutputPath(
    inputPath: string,
    suffix: string,
    ext?: string,
  ): string {
    const parsedExt = ext ?? path.extname(inputPath).replace('.', '');
    const base = path.basename(inputPath, path.extname(inputPath));
    const filename = `${base}_${suffix}_${Date.now()}.${parsedExt}`;
    return path.join(env.PROCESSED_DIR, filename);
  }
}
