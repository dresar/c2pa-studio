import { FastifyReply, FastifyRequest } from 'fastify';
import { env } from '../config/env';
import { ValidationError } from '../utils/errors';
import { isAllowedMimeType } from '../utils/fs';

// ─────────────────────────────────────────────
// Upload validation middleware
// ─────────────────────────────────────────────
export async function validateUpload(
  request: FastifyRequest,
  _reply: FastifyReply,
): Promise<void> {
  const contentType = request.headers['content-type'] ?? '';

  if (!contentType.includes('multipart/form-data')) {
    throw new ValidationError('Content-Type must be multipart/form-data');
  }
}

// ─────────────────────────────────────────────
// Validate a single file part
// ─────────────────────────────────────────────
export function validateFilePart(
  mimeType: string,
  fileSize: number,
  filename: string,
): void {
  if (!isAllowedMimeType(mimeType)) {
    throw new ValidationError(
      `File type "${mimeType}" is not allowed. Accepted: ${env.ALLOWED_MIME_TYPES.join(', ')}`,
    );
  }

  const maxBytes = env.MAX_FILE_SIZE_MB * 1024 * 1024;
  if (fileSize > maxBytes) {
    throw new ValidationError(
      `File "${filename}" exceeds maximum size of ${env.MAX_FILE_SIZE_MB} MB`,
    );
  }

  // Sanitize: prevent path traversal in filename
  if (/[/\\]/.test(filename)) {
    throw new ValidationError(`Invalid filename: "${filename}"`);
  }
}
