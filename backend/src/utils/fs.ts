import path from 'path';
import fs from 'fs';
import { env } from '../config/env';
import { logger } from './logger';

// ─────────────────────────────────────────────
// Ensure required storage directories exist
// ─────────────────────────────────────────────
export function ensureStorageDirs(): void {
  const dirs = [
    env.TEMP_DIR,
    env.UPLOAD_DIR,
    env.PROCESSED_DIR,
    env.EXPORT_DIR,
    env.LOG_DIR,
  ];

  for (const dir of dirs) {
    const resolved = path.resolve(dir);
    if (!fs.existsSync(resolved)) {
      fs.mkdirSync(resolved, { recursive: true });
      logger.debug({ dir: resolved }, 'Created storage directory');
    }
  }
}

// ─────────────────────────────────────────────
// Sanitize filename: strip dangerous characters
// ─────────────────────────────────────────────
export function sanitizeFilename(filename: string): string {
  const ext = path.extname(filename).toLowerCase();
  const base = path.basename(filename, ext);
  const sanitized = base
    .replace(/[^a-zA-Z0-9_\-]/g, '_')
    .replace(/_+/g, '_')
    .slice(0, 100);
  return `${sanitized}${ext}`;
}

// ─────────────────────────────────────────────
// Generate unique temp file path
// ─────────────────────────────────────────────
export function getTempFilePath(filename: string): string {
  const sanitized = sanitizeFilename(filename);
  const unique = `${Date.now()}_${Math.random().toString(36).slice(2)}_${sanitized}`;
  return path.resolve(env.TEMP_DIR, unique);
}

// ─────────────────────────────────────────────
// Safely delete a file (no-throw)
// ─────────────────────────────────────────────
export async function safeDeleteFile(filePath: string): Promise<void> {
  try {
    await fs.promises.unlink(filePath);
  } catch {
    // File may already be deleted — ignore
  }
}

// ─────────────────────────────────────────────
// Format bytes to human-readable string
// ─────────────────────────────────────────────
export function formatBytes(bytes: number | bigint): string {
  const num = typeof bytes === 'bigint' ? Number(bytes) : bytes;
  if (num === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(num) / Math.log(k));
  return `${parseFloat((num / Math.pow(k, i)).toFixed(2))} ${sizes[i]}`;
}

// ─────────────────────────────────────────────
// Check MIME type is allowed
// ─────────────────────────────────────────────
export function isAllowedMimeType(mimeType: string): boolean {
  return env.ALLOWED_MIME_TYPES.includes(mimeType);
}
