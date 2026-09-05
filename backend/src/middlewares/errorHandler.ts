import { FastifyReply, FastifyRequest } from 'fastify';
import { ZodError } from 'zod';
import { isAppError } from '../utils/errors';
import { errorResponse } from '../utils/response';
import { logger } from '../utils/logger';

// ─────────────────────────────────────────────
// Global Error Handler Middleware
// ─────────────────────────────────────────────
export async function globalErrorHandler(
  error: Error,
  request: FastifyRequest,
  reply: FastifyReply,
): Promise<void> {
  // Zod validation errors
  if (error instanceof ZodError) {
    const errors = error.errors.map((e) => ({
      field: e.path.join('.'),
      message: e.message,
      code: e.code,
    }));

    await reply.status(400).send(
      errorResponse('Validation failed', errors),
    );
    return;
  }

  // Application operational errors
  if (isAppError(error)) {
    if (error.statusCode >= 500) {
      logger.error(
        { err: error, requestId: request.id },
        'Application error',
      );
    }

    await reply.status(error.statusCode).send(
      errorResponse(error.message, [{ code: error.code, message: error.message }]),
    );
    return;
  }

  // Fastify's built-in validation errors
  if ('validation' in error && (error as any).validation) {
    await reply.status(400).send(
      errorResponse('Request validation failed'),
    );
    return;
  }

  // Unknown / programmer errors
  logger.error({ err: error, requestId: request.id }, 'Unhandled server error');

  await reply.status(500).send(
    errorResponse('Internal server error'),
  );
}
