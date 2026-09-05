import fs from 'fs';
import path from 'path';
import archiver from 'archiver';
import { env } from '../config/env';
import { prisma } from '../config/database';
import { logger } from '../utils/logger';
import { AppError, NotFoundError } from '../utils/errors';
import { StorageService } from './storage.service';

// ─────────────────────────────────────────────
// Export Service — single, multiple, ZIP
// ─────────────────────────────────────────────

export type ExportFormat = 'jpeg' | 'png' | 'webp' | 'zip';

export interface ExportSingleResult {
  filePath: string;
  filename: string;
  sizeBytes: number;
  mimeType: string;
}

const storageService = new StorageService();

export class ExportService {
  // ─────────────────────────────────────────────
  // Export single image (return local file path)
  // ─────────────────────────────────────────────
  async exportSingle(
    imageId: string,
    format: ExportFormat,
    userId: string,
  ): Promise<ExportSingleResult> {
    const image = await prisma.image.findFirst({
      where: { id: imageId, deletedAt: null, project: { userId } },
    });

    if (!image) throw new NotFoundError('Image not found');

    // Download from ImageKit to local for re-export
    const sourceUrl = image.processedUrl ?? image.imagekitUrl;
    if (!sourceUrl) {
      throw new AppError('Image file not available', 404, 'IMAGE_NOT_AVAILABLE');
    }

    const filename = `export_${image.sanitizedFilename}_${Date.now()}.${format}`;
    const outputPath = path.join(env.EXPORT_DIR, filename);

    // For now: if format matches original, just stream from URL
    // In production: download, re-process with sharp, then return
    await this.downloadUrlToFile(sourceUrl, outputPath);

    const stats = await fs.promises.stat(outputPath);
    const mimeMap: Record<string, string> = {
      jpeg: 'image/jpeg',
      png: 'image/png',
      webp: 'image/webp',
      zip: 'application/zip',
    };

    return {
      filePath: outputPath,
      filename,
      sizeBytes: stats.size,
      mimeType: mimeMap[format] ?? 'application/octet-stream',
    };
  }

  // ─────────────────────────────────────────────
  // Export multiple images as ZIP
  // ─────────────────────────────────────────────
  async exportZip(
    imageIds: string[],
    userId: string,
    zipFilename?: string,
  ): Promise<ExportSingleResult> {
    const images = await prisma.image.findMany({
      where: {
        id: { in: imageIds },
        deletedAt: null,
        project: { userId },
      },
    });

    if (images.length === 0) {
      throw new NotFoundError('No valid images found for export');
    }

    const archiveName = zipFilename ?? `export_${Date.now()}.zip`;
    const outputPath = path.join(env.EXPORT_DIR, archiveName);

    await new Promise<void>((resolve, reject) => {
      const output = fs.createWriteStream(outputPath);
      const archive = archiver('zip', { zlib: { level: 6 } });

      output.on('close', resolve);
      archive.on('error', reject);
      archive.pipe(output);

      for (const image of images) {
        const url = image.processedUrl ?? image.imagekitUrl;
        if (url) {
          // Append URL as remote file (archiver supports streams)
          archive.append(
            require('https').get(url, (res: NodeJS.ReadableStream) => res) as any,
            { name: image.sanitizedFilename },
          );
        }
      }

      archive.finalize();
    });

    const stats = await fs.promises.stat(outputPath);

    logger.info(
      { imageCount: images.length, outputPath, sizeBytes: stats.size },
      'ZIP export created',
    );

    return {
      filePath: outputPath,
      filename: archiveName,
      sizeBytes: stats.size,
      mimeType: 'application/zip',
    };
  }

  // ─────────────────────────────────────────────
  // Export entire project as ZIP
  // ─────────────────────────────────────────────
  async exportProject(projectId: string, userId: string): Promise<ExportSingleResult> {
    const project = await prisma.project.findFirst({
      where: { id: projectId, userId, deletedAt: null },
      include: {
        images: { where: { deletedAt: null } },
      },
    });

    if (!project) throw new NotFoundError('Project not found');

    const imageIds = project.images.map((img) => img.id);
    return this.exportZip(
      imageIds,
      userId,
      `project_${project.name.replace(/[^a-z0-9]/gi, '_')}_${Date.now()}.zip`,
    );
  }

  // ─────────────────────────────────────────────
  // Private: download remote URL to local file
  // ─────────────────────────────────────────────
  private async downloadUrlToFile(url: string, outputPath: string): Promise<void> {
    const https = await import('https');
    const http = await import('http');
    const module = url.startsWith('https') ? https : http;

    return new Promise((resolve, reject) => {
      const writeStream = fs.createWriteStream(outputPath);
      module.get(url, (res) => {
        res.pipe(writeStream);
        writeStream.on('finish', () => {
          writeStream.close();
          resolve();
        });
      }).on('error', reject);
    });
  }

  // ─────────────────────────────────────────────
  // Cleanup export files older than X hours
  // ─────────────────────────────────────────────
  async cleanupOldExports(olderThanHours: number = 24): Promise<void> {
    const cutoff = Date.now() - olderThanHours * 60 * 60 * 1000;
    const files = await fs.promises.readdir(env.EXPORT_DIR);

    for (const file of files) {
      const filePath = path.join(env.EXPORT_DIR, file);
      const stats = await fs.promises.stat(filePath);
      if (stats.mtimeMs < cutoff) {
        await fs.promises.unlink(filePath).catch(() => {});
      }
    }
  }
}
