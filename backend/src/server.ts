import 'dotenv/config';
import Fastify, { FastifyInstance } from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import rateLimit from '@fastify/rate-limit';
import multipart from '@fastify/multipart';
import staticFiles from '@fastify/static';
import jwt from '@fastify/jwt';
import path from 'path';

import { env } from './config/env';
import { connectDatabase, disconnectDatabase } from './config/database';
import { connectRedis, disconnectRedis } from './config/redis';
import { ensureStorageDirs } from './utils/fs';
import { logger } from './utils/logger';
import { globalErrorHandler } from './middlewares/errorHandler';
import { authRoutes } from './routes/auth.routes';
import { apiRoutes } from './routes/api.routes';
import { startImageWorker, closeImageQueue } from './workers/imageQueue';
import { destroyExifTool } from './services/metadata.service';
import { ExportService } from './services/export.service';

let cleanupInterval: NodeJS.Timeout | null = null;

// ─────────────────────────────────────────────
// Build Fastify Application
// ─────────────────────────────────────────────
async function buildApp(): Promise<FastifyInstance> {
  const fastify = Fastify({
    logger,
    trustProxy: true,
    requestIdHeader: 'x-request-id',
  });

  // ─── Security Plugins ─────────────────────────
  await fastify.register(helmet, {
    contentSecurityPolicy: false, // Adjust as needed for your frontend
  });

  await fastify.register(cors, {
    origin: env.CORS_ORIGINS,
    methods: ['GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'OPTIONS'],
    credentials: true,
  });

  await fastify.register(rateLimit, {
    max: env.RATE_LIMIT_MAX,
    timeWindow: env.RATE_LIMIT_WINDOW_MS,
    errorResponseBuilder: (_req, context) => ({
      success: false,
      message: `Too many requests. Please retry after ${Math.ceil(context.ttl / 1000)} seconds.`,
      timestamp: new Date().toISOString(),
    }),
  });

  // ─── JWT ──────────────────────────────────────
  await fastify.register(jwt, {
    secret: env.JWT_SECRET,
  });

  // ─── Multipart (file upload) ──────────────────
  await fastify.register(multipart, {
    limits: {
      fileSize: env.MAX_FILE_SIZE_MB * 1024 * 1024,
      files: env.MAX_FILES_PER_UPLOAD,
    },
  });

  // ─── Static Files (for export downloads) ─────
  await fastify.register(staticFiles, {
    root: path.resolve(env.EXPORT_DIR),
    prefix: '/downloads/',
    serve: false, // We use sendFile manually for security
  });

  // ─── Global Error Handler ─────────────────────
  fastify.setErrorHandler(globalErrorHandler);

  // ─── Routes ───────────────────────────────────
  await fastify.register(authRoutes, { prefix: '/api/v1/auth' });
  await fastify.register(apiRoutes, { prefix: '/api/v1' });

  // ─── Health Check ─────────────────────────────
  fastify.get('/health', async (_request, reply) => {
    return reply.send({
      status: 'ok',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version ?? '1.0.0',
    });
  });

  // ─── 404 Handler ──────────────────────────────
  fastify.setNotFoundHandler(async (_request, reply) => {
    return reply.status(404).send({
      success: false,
      message: 'Route not found',
      timestamp: new Date().toISOString(),
    });
  });

  return fastify;
}

// ─────────────────────────────────────────────
// Graceful Shutdown
// ─────────────────────────────────────────────
function setupGracefulShutdown(fastify: FastifyInstance): void {
  const shutdown = async (signal: string) => {
    logger.info({ signal }, 'Received shutdown signal');

    if (cleanupInterval) {
      clearInterval(cleanupInterval);
      cleanupInterval = null;
    }

    await fastify.close();
    await destroyExifTool();
    await closeImageQueue();
    await disconnectDatabase();
    await disconnectRedis();

    logger.info('Server shut down gracefully');
    process.exit(0);
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));

  process.on('unhandledRejection', (reason) => {
    logger.error({ reason }, 'Unhandled Promise Rejection');
  });

  process.on('uncaughtException', (error) => {
    logger.fatal({ err: error }, 'Uncaught Exception');
    process.exit(1);
  });
}

// ─────────────────────────────────────────────
// Bootstrap
// ─────────────────────────────────────────────
async function bootstrap(): Promise<void> {
  // Ensure storage directories exist
  ensureStorageDirs();

  // Connect to database
  await connectDatabase();

  // Connect to Redis (optional — won't crash if unavailable)
  await connectRedis();

  // Build Fastify app
  const app = await buildApp();

  // Start BullMQ worker
  try {
    startImageWorker();
  } catch (err) {
    logger.warn({ err }, 'Image worker failed to start (Redis may be unavailable)');
  }

  // Initialize and start export directory cleanup interval
  const exportService = new ExportService();
  exportService.cleanupOldExports(24).catch((err) => {
    logger.error({ err }, 'Failed to run initial export cleanup');
  });
  const CLEANUP_INTERVAL_MS = 6 * 60 * 60 * 1000; // Every 6 hours
  cleanupInterval = setInterval(() => {
    exportService.cleanupOldExports(24).catch((err) => {
      logger.error({ err }, 'Failed to run periodic export cleanup');
    });
  }, CLEANUP_INTERVAL_MS);

  // Setup graceful shutdown
  setupGracefulShutdown(app);

  // Start server
  try {
    const listenOptions: any = {};
    if (typeof env.PORT === 'string' && (env.PORT.includes('/') || env.PORT.includes('\\'))) {
      listenOptions.path = env.PORT;
    } else {
      listenOptions.port = typeof env.PORT === 'string' ? Number(env.PORT) : env.PORT;
      listenOptions.host = env.HOST;
    }

    await app.listen(listenOptions);
    
    if (listenOptions.path) {
      logger.info(`🚀 Server running on socket ${env.PORT} [${env.NODE_ENV}]`);
    } else {
      logger.info(`🚀 Server running at http://${env.HOST}:${env.PORT} [${env.NODE_ENV}]`);
    }
  } catch (err) {
    logger.fatal({ err }, 'Failed to start server');
    process.exit(1);
  }
}

bootstrap();
