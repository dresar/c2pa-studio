import 'dotenv/config';
import { z } from 'zod';

// ─────────────────────────────────────────────
// Environment Schema Validation
// ─────────────────────────────────────────────
const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  PORT: z.preprocess(
    (val) => val ?? '3000',
    z.union([z.number(), z.string()]).transform((val) => {
      if (typeof val === 'number') return val;
      if (/^\d+$/.test(val)) return Number(val);
      return val; // socket path string
    })
  ),
  HOST: z.string().default('0.0.0.0'),

  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),

  JWT_SECRET: z.string().min(32, 'JWT_SECRET must be at least 32 characters'),
  JWT_REFRESH_SECRET: z.string().min(32, 'JWT_REFRESH_SECRET must be at least 32 characters'),
  JWT_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('7d'),

  REDIS_HOST: z.string().default('localhost'),
  REDIS_PORT: z.string().default('6379').transform(Number),
  REDIS_PASSWORD: z.string().optional(),

  IMAGEKIT_PUBLIC_KEY: z.string().min(1, 'IMAGEKIT_PUBLIC_KEY is required'),
  IMAGEKIT_PRIVATE_KEY: z.string().min(1, 'IMAGEKIT_PRIVATE_KEY is required'),
  IMAGEKIT_URL_ENDPOINT: z.string().url('IMAGEKIT_URL_ENDPOINT must be a valid URL'),

  MAX_FILE_SIZE_MB: z.string().default('50').transform(Number),
  MAX_FILES_PER_UPLOAD: z.string().default('10').transform(Number),
  ALLOWED_MIME_TYPES: z
    .string()
    .default('image/jpeg,image/png,image/webp,image/tiff')
    .transform((v) => v.split(',')),

  TEMP_DIR: z.string().default('./storage/temp'),
  UPLOAD_DIR: z.string().default('./storage/uploads'),
  PROCESSED_DIR: z.string().default('./storage/processed'),
  EXPORT_DIR: z.string().default('./storage/exports'),
  LOG_DIR: z.string().default('./logs'),

  CORS_ORIGINS: z
    .string()
    .default('http://localhost:3000')
    .transform((v) => v.split(',')),

  RATE_LIMIT_MAX: z.string().default('100').transform(Number),
  RATE_LIMIT_WINDOW_MS: z.string().default('60000').transform(Number),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error('❌ Invalid environment variables:');
  console.error(parsed.error.format());
  process.exit(1);
}

export const env = parsed.data;
export type Env = typeof env;
