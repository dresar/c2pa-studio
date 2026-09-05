import Redis from 'ioredis';
import { env } from './env';
import { logger } from '../utils/logger';

// ─────────────────────────────────────────────
// Redis Client Singleton
// ─────────────────────────────────────────────
let redisClient: Redis | null = null;

export function getRedisClient(): Redis {
  if (!redisClient) {
    redisClient = new Redis({
      host: env.REDIS_HOST,
      port: env.REDIS_PORT,
      password: env.REDIS_PASSWORD || undefined,
      maxRetriesPerRequest: null, // Required by BullMQ
      enableReadyCheck: false,
      lazyConnect: true,
    });

    redisClient.on('connect', () => {
      logger.info('✅ Redis connected');
    });

    redisClient.on('error', (err) => {
      logger.error({ err }, '❌ Redis connection error');
    });

    redisClient.on('close', () => {
      logger.warn('Redis connection closed');
    });
  }

  return redisClient;
}

export async function connectRedis(): Promise<void> {
  try {
    const client = getRedisClient();
    await client.connect();
  } catch (error) {
    logger.error({ err: error }, '❌ Failed to connect to Redis');
    // Redis is optional — queue processing will be degraded but app still runs
  }
}

export async function disconnectRedis(): Promise<void> {
  if (redisClient) {
    await redisClient.quit();
    redisClient = null;
    logger.info('Redis disconnected');
  }
}
