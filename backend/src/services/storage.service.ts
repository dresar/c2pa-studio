import fs from 'fs';
import path from 'path';
import { pipeline } from 'stream/promises';
import { getImageKitClient } from '../config/imagekit';
import { env } from '../config/env';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';
import { ImageKitUploadResult } from '../config/imagekit';

// ─────────────────────────────────────────────
// Storage Service — ImageKit + local temp
// ─────────────────────────────────────────────

export class StorageService {
  // ─────────────────────────────────────────────
  // Save uploaded stream to temp folder
  // ─────────────────────────────────────────────
  async saveTempFile(
    stream: NodeJS.ReadableStream,
    filename: string,
  ): Promise<{ filePath: string; sizeBytes: number }> {
    const tempPath = path.join(
      env.TEMP_DIR,
      `${Date.now()}_${Math.random().toString(36).slice(2)}_${filename}`,
    );

    try {
      const writeStream = fs.createWriteStream(tempPath);
      await pipeline(stream, writeStream);
      const stats = await fs.promises.stat(tempPath);
      return { filePath: tempPath, sizeBytes: stats.size };
    } catch (error) {
      logger.error({ err: error, filename }, 'Failed to save temp file');
      throw new AppError('Failed to save uploaded file', 500, 'UPLOAD_SAVE_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Upload file to ImageKit
  // ─────────────────────────────────────────────
  async uploadToImageKit(
    filePath: string,
    folder: string,
    filename: string,
  ): Promise<ImageKitUploadResult> {
    const imagekit = getImageKitClient();

    try {
      const fileBuffer = await fs.promises.readFile(filePath);

      const result = await imagekit.upload({
        file: fileBuffer,
        fileName: filename,
        folder: `/image-provenance/${folder}`,
        useUniqueFileName: true,
        tags: ['image-provenance'],
      });

      logger.debug(
        { fileId: result.fileId, url: result.url, folder },
        'Uploaded to ImageKit',
      );

      return {
        fileId: result.fileId,
        url: result.url,
        filePath: result.filePath,
        name: result.name,
        size: result.size,
        width: result.width,
        height: result.height,
        thumbnailUrl: result.thumbnailUrl,
      };
    } catch (error) {
      logger.error({ err: error, filePath }, 'ImageKit upload failed');
      throw new AppError('Failed to upload file to storage', 500, 'IMAGEKIT_UPLOAD_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Delete file from ImageKit
  // ─────────────────────────────────────────────
  async deleteFromImageKit(fileId: string): Promise<void> {
    const imagekit = getImageKitClient();
    try {
      await imagekit.deleteFile(fileId);
      logger.debug({ fileId }, 'Deleted from ImageKit');
    } catch (error) {
      logger.error({ err: error, fileId }, 'ImageKit delete failed');
      // Non-fatal — log and continue
    }
  }

  // ─────────────────────────────────────────────
  // Delete local temp/processed file (safe)
  // ─────────────────────────────────────────────
  async deleteLocalFile(filePath: string): Promise<void> {
    try {
      await fs.promises.unlink(filePath);
    } catch {
      // File may not exist — ignore
    }
  }

  // ─────────────────────────────────────────────
  // Copy file from temp to processed folder
  // ─────────────────────────────────────────────
  async copyToProcessed(
    tempPath: string,
    filename: string,
  ): Promise<string> {
    const outputPath = path.join(env.PROCESSED_DIR, filename);
    await fs.promises.copyFile(tempPath, outputPath);
    return outputPath;
  }
}
