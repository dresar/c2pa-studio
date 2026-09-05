import { z } from 'zod';

// ─────────────────────────────────────────────
// Project Validators
// ─────────────────────────────────────────────

export const createProjectSchema = z.object({
  name: z.string().min(1, 'Name is required').max(200),
  description: z.string().max(1000).optional(),
});

export const updateProjectSchema = z.object({
  name: z.string().min(1).max(200).optional(),
  description: z.string().max(1000).optional(),
  status: z.enum(['ACTIVE', 'ARCHIVED']).optional(),
});

export const listProjectsSchema = z.object({
  page: z.string().optional().default('1').transform(Number),
  limit: z.string().optional().default('20').transform(Number),
  search: z.string().optional(),
  status: z.enum(['ACTIVE', 'ARCHIVED', 'DELETED']).optional(),
  sortBy: z.enum(['name', 'createdAt', 'updatedAt']).optional().default('updatedAt'),
  sortOrder: z.enum(['asc', 'desc']).optional().default('desc'),
});

// ─────────────────────────────────────────────
// Image Validators
// ─────────────────────────────────────────────

export const listImagesSchema = z.object({
  page: z.string().optional().default('1').transform(Number),
  limit: z.string().optional().default('20').transform(Number),
  search: z.string().optional(),
  status: z.enum(['PENDING', 'SCANNING', 'READY', 'PROCESSING', 'ERROR']).optional(),
});

export const compressImageSchema = z.object({
  mode: z.enum(['keep_original', 'high_quality', 'balanced', 'maximum', 'custom']).default('balanced'),
  quality: z.number().min(1).max(100).optional(),
  keepMetadata: z.boolean().default(true),
});

export const resizeImageSchema = z.object({
  width: z.number().int().positive().optional(),
  height: z.number().int().positive().optional(),
  fit: z.enum(['cover', 'contain', 'fill', 'inside', 'outside']).optional().default('inside'),
}).refine((data) => data.width || data.height, {
  message: 'At least one of width or height is required',
});

export const convertImageSchema = z.object({
  format: z.enum(['jpeg', 'png', 'webp', 'tiff']),
  quality: z.number().min(1).max(100).optional(),
});

export const customC2paSchema = z.object({
  creator: z.string().max(200).optional(),
  organization: z.string().max(200).optional(),
  website: z.string().url().optional(),
  license: z.string().max(500).optional(),
  copyright: z.string().max(500).optional(),
  generator: z.string().max(200).optional(),
  aiModel: z.string().max(200).optional(),
  prompt: z.string().max(2000).optional(),
  negativePrompt: z.string().max(2000).optional(),
  workflow: z.string().max(500).optional(),
  source: z.string().max(500).optional(),
});

export const exportSchema = z.object({
  format: z.enum(['jpeg', 'png', 'webp', 'zip']).default('jpeg'),
});

export const exportMultipleSchema = z.object({
  imageIds: z.array(z.string().cuid()).min(1, 'At least one image required'),
  format: z.enum(['zip']).default('zip'),
});

export const batchActionSchema = z.object({
  imageIds: z.array(z.string().cuid()).min(1, 'At least one image required'),
  action: z.enum([
    'compress', 'resize', 'convert',
    'remove_metadata', 'remove_gps', 'remove_c2pa',
    'create_c2pa',
  ]),
  options: z.record(z.unknown()).optional(),
});

// ─────────────────────────────────────────────
// C2PA Template Validators
// ─────────────────────────────────────────────

export const createTemplateSchema = z.object({
  name: z.string().min(1).max(100),
  creator: z.string().max(200).optional(),
  organization: z.string().max(200).optional(),
  website: z.string().url().optional(),
  license: z.string().max(500).optional(),
  copyright: z.string().max(500).optional(),
  generator: z.string().max(200).optional(),
  aiModel: z.string().max(200).optional(),
  workflow: z.string().max(500).optional(),
  source: z.string().max(500).optional(),
  isDefault: z.boolean().default(false),
});
