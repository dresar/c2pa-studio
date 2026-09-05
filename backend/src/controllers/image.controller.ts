import { FastifyReply, FastifyRequest } from 'fastify';
import path from 'path';
import { ImageRepository } from '../repositories/image.repository';
import { ProjectRepository } from '../repositories/project.repository';
import { HistoryRepository } from '../repositories/history.repository';
import { StorageService } from '../services/storage.service';
import { enqueueImageJob } from '../workers/imageQueue';
import { assertOwnership } from '../middlewares/auth';
import { NotFoundError, ValidationError } from '../utils/errors';
import { sanitizeFilename } from '../utils/fs';
import { env } from '../config/env';
import {
  listImagesSchema,
  compressImageSchema,
  resizeImageSchema,
  convertImageSchema,
  customC2paSchema,
  exportSchema,
  exportMultipleSchema,
  batchActionSchema,
} from '../validators/image.validator';
import { successResponse, getPaginationMeta } from '../utils/response';
import { ExportService } from '../services/export.service';

const storageService = new StorageService();
const exportService = new ExportService();

// ─────────────────────────────────────────────
// Image Controller
// ─────────────────────────────────────────────

export const ImageController = {
  // ─── Upload Images ────────────────────────────
  async upload(request: FastifyRequest, reply: FastifyReply) {
    const { projectId } = request.params as { projectId: string };
    const userId = request.user.sub;

    const project = await ProjectRepository.findById(projectId);
    if (!project) throw new NotFoundError('Project not found');
    assertOwnership(project.userId, userId, 'project');

    const parts = request.parts();
    const uploadedImages: { id: string; filename: string }[] = [];
    let fileCount = 0;

    for await (const part of parts) {
      if (part.type !== 'file') continue;
      if (fileCount >= env.MAX_FILES_PER_UPLOAD) {
        throw new ValidationError(`Maximum ${env.MAX_FILES_PER_UPLOAD} files allowed per upload`);
      }

      const mimeType = part.mimetype;
      if (!env.ALLOWED_MIME_TYPES.includes(mimeType)) {
        throw new ValidationError(`File type "${mimeType}" is not allowed`);
      }

      const sanitizedName = sanitizeFilename(part.filename);

      // Save to temp
      const { filePath, sizeBytes } = await storageService.saveTempFile(part.file, sanitizedName);

      if (sizeBytes > env.MAX_FILE_SIZE_MB * 1024 * 1024) {
        await storageService.deleteLocalFile(filePath);
        throw new ValidationError(`File exceeds maximum size of ${env.MAX_FILE_SIZE_MB} MB`);
      }

      // Create DB record
      const image = await ImageRepository.create({
        originalFilename: part.filename,
        sanitizedFilename: sanitizedName,
        mimeType,
        sizeBytes: BigInt(sizeBytes),
        status: 'PENDING',
        project: { connect: { id: projectId } },
      });

      await ProjectRepository.incrementImageCount(projectId, BigInt(sizeBytes));
      await HistoryRepository.create(image.id, 'UPLOADED', `Uploaded: ${part.filename}`);

      // Enqueue: metadata scan → upload to ImageKit
      await enqueueImageJob({
        type: 'SCAN_METADATA',
        imageId: image.id,
        projectId,
        userId,
        filePath,
      });

      await enqueueImageJob({
        type: 'UPLOAD_TO_IMAGEKIT',
        imageId: image.id,
        projectId,
        userId,
        filePath,
      });

      uploadedImages.push({ id: image.id, filename: part.filename });
      fileCount++;
    }

    if (fileCount === 0) {
      throw new ValidationError('No valid files were uploaded');
    }

    return reply.status(202).send(
      successResponse(`${fileCount} file(s) uploaded and queued for processing`, uploadedImages),
    );
  },

  // ─── List Images ─────────────────────────────
  async list(request: FastifyRequest, reply: FastifyReply) {
    const { projectId } = request.params as { projectId: string };
    const userId = request.user.sub;
    const params = listImagesSchema.parse(request.query);

    const project = await ProjectRepository.findById(projectId);
    if (!project) throw new NotFoundError('Project not found');
    assertOwnership(project.userId, userId, 'project');

    const { items, total } = await ImageRepository.findManyByProject({
      projectId,
      page: params.page,
      limit: params.limit,
      search: params.search,
      status: params.status,
    });

    return reply.send(
      successResponse('Images retrieved', items, getPaginationMeta(total, params)),
    );
  },

  // ─── Get Single Image ─────────────────────────
  async getOne(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const image = await ImageRepository.findById(id);
    if (!image) throw new NotFoundError('Image not found');

    const project = await ProjectRepository.findById(image.projectId);
    assertOwnership(project!.userId, userId, 'image');

    return reply.send(successResponse('Image retrieved', image));
  },

  // ─── Delete Image ─────────────────────────────
  async delete(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const image = await ImageRepository.findByIdRaw(id);
    if (!image) throw new NotFoundError('Image not found');

    const project = await ProjectRepository.findById(image.projectId);
    assertOwnership(project!.userId, userId, 'image');

    await ImageRepository.softDelete(id);
    await ProjectRepository.decrementImageCount(image.projectId, image.sizeBytes);
    await HistoryRepository.create(id, 'DELETED', 'Image deleted');

    return reply.send(successResponse('Image deleted'));
  },

  // ─── Compress ─────────────────────────────────
  async compress(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;
    const options = compressImageSchema.parse(request.body);

    const image = await this.assertImageAccess(id, userId);

    await enqueueImageJob({
      type: 'COMPRESS',
      imageId: id,
      projectId: image.projectId,
      userId,
      filePath: image.processedUrl ?? image.imagekitUrl ?? '',
      options: options as Record<string, unknown>,
    });

    return reply.status(202).send(successResponse('Compression queued'));
  },

  // ─── Resize ───────────────────────────────────
  async resize(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;
    const options = resizeImageSchema.parse(request.body);

    const image = await this.assertImageAccess(id, userId);

    await enqueueImageJob({
      type: 'RESIZE',
      imageId: id,
      projectId: image.projectId,
      userId,
      filePath: image.processedUrl ?? image.imagekitUrl ?? '',
      options: options as Record<string, unknown>,
    });

    return reply.status(202).send(successResponse('Resize queued'));
  },

  // ─── Remove Metadata ──────────────────────────
  async removeMetadata(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const { type } = request.params as { type?: string };
    const userId = request.user.sub;

    const image = await this.assertImageAccess(id, userId);
    const jobType =
      type === 'gps' ? 'REMOVE_GPS' :
      type === 'c2pa' ? 'REMOVE_C2PA' : 'REMOVE_METADATA';

    await enqueueImageJob({
      type: jobType,
      imageId: id,
      projectId: image.projectId,
      userId,
      filePath: image.processedUrl ?? image.imagekitUrl ?? '',
    });

    return reply.status(202).send(successResponse(`${type ?? 'Metadata'} removal queued`));
  },

  // ─── Create Custom C2PA ───────────────────────
  async createC2pa(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;
    const options = customC2paSchema.parse(request.body);

    const image = await this.assertImageAccess(id, userId);

    await enqueueImageJob({
      type: 'CREATE_C2PA',
      imageId: id,
      projectId: image.projectId,
      userId,
      filePath: image.processedUrl ?? image.imagekitUrl ?? '',
      options: options as Record<string, unknown>,
    });

    return reply.status(202).send(successResponse('C2PA creation queued'));
  },

  // ─── Re-scan Metadata ─────────────────────────
  async rescan(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const image = await this.assertImageAccess(id, userId);

    await enqueueImageJob({
      type: 'SCAN_METADATA',
      imageId: id,
      projectId: image.projectId,
      userId,
      filePath: image.processedUrl ?? image.imagekitUrl ?? '',
    });

    return reply.status(202).send(successResponse('Metadata rescan queued'));
  },

  // ─── Export Single Image ──────────────────────
  async exportSingle(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;
    const { format } = exportSchema.parse(request.query);

    const result = await exportService.exportSingle(id, format, userId);

    return reply
      .header('Content-Type', result.mimeType)
      .header('Content-Disposition', `attachment; filename="${result.filename}"`)
      .sendFile(result.filePath, { root: '/' });
  },

  // ─── Export Multiple as ZIP ───────────────────
  async exportMultiple(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const input = exportMultipleSchema.parse(request.body);

    const result = await exportService.exportZip(input.imageIds, userId);

    return reply
      .header('Content-Type', 'application/zip')
      .header('Content-Disposition', `attachment; filename="${result.filename}"`)
      .sendFile(result.filePath, { root: '/' });
  },

  // ─── Batch Operations ─────────────────────────
  async batch(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const input = batchActionSchema.parse(request.body);

    const jobTypeMap: Record<string, string> = {
      compress: 'COMPRESS',
      resize: 'RESIZE',
      remove_metadata: 'REMOVE_METADATA',
      remove_gps: 'REMOVE_GPS',
      remove_c2pa: 'REMOVE_C2PA',
      create_c2pa: 'CREATE_C2PA',
    };

    const jobType = jobTypeMap[input.action];
    if (!jobType) throw new ValidationError(`Unknown action: ${input.action}`);

    const queued: string[] = [];
    for (const imageId of input.imageIds) {
      const image = await ImageRepository.findByIdRaw(imageId);
      if (!image) continue;

      const project = await ProjectRepository.findById(image.projectId);
      if (!project || project.userId !== userId) continue;

      await enqueueImageJob({
        type: jobType as any,
        imageId,
        projectId: image.projectId,
        userId,
        filePath: image.processedUrl ?? image.imagekitUrl ?? '',
        options: input.options,
      });
      queued.push(imageId);
    }

    return reply.status(202).send(
      successResponse(`Batch ${input.action} queued for ${queued.length} images`, { queued }),
    );
  },

  // ─── History ──────────────────────────────────
  async history(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;
    const { page = '1', limit = '20' } = request.query as Record<string, string>;

    await this.assertImageAccess(id, userId);

    const { items, total } = await HistoryRepository.findManyByImage(id, {
      page: Number(page),
      limit: Number(limit),
    });

    return reply.send(
      successResponse('History retrieved', items, getPaginationMeta(total, { page: Number(page), limit: Number(limit) })),
    );
  },

  // ─── Private: Assert image access ────────────
  async assertImageAccess(imageId: string, userId: string) {
    const image = await ImageRepository.findByIdRaw(imageId);
    if (!image) throw new NotFoundError('Image not found');

    const project = await ProjectRepository.findById(image.projectId);
    if (!project) throw new NotFoundError('Project not found');
    assertOwnership(project.userId, userId, 'image');

    return image;
  },
};
