import { HistoryAction, ImageHistory, Prisma } from '@prisma/client';
import { prisma } from '../config/database';
import { PaginationParams, getPaginationSkip } from '../utils/response';

// ─────────────────────────────────────────────
// History Repository
// ─────────────────────────────────────────────

export interface HistoryListParams extends PaginationParams {
  imageId?: string;
  projectId?: string;
  action?: HistoryAction;
  dateFrom?: Date;
  dateTo?: Date;
}

export const HistoryRepository = {
  async create(
    imageId: string,
    action: HistoryAction,
    description?: string,
    metadata?: Record<string, unknown>,
  ): Promise<ImageHistory> {
    return prisma.imageHistory.create({
      data: {
        imageId,
        action,
        description,
        metadata: metadata as Prisma.InputJsonValue,
      },
    });
  },

  async findManyByImage(imageId: string, params: PaginationParams) {
    const where = { imageId };
    const [items, total] = await prisma.$transaction([
      prisma.imageHistory.findMany({
        where,
        skip: getPaginationSkip(params),
        take: params.limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.imageHistory.count({ where }),
    ]);
    return { items, total };
  },

  async findManyByProject(projectId: string, params: HistoryListParams) {
    const where: Prisma.ImageHistoryWhereInput = {
      image: { projectId, deletedAt: null },
      ...(params.action && { action: params.action }),
      ...(params.dateFrom || params.dateTo
        ? {
            createdAt: {
              ...(params.dateFrom && { gte: params.dateFrom }),
              ...(params.dateTo && { lte: params.dateTo }),
            },
          }
        : {}),
    };

    const [items, total] = await prisma.$transaction([
      prisma.imageHistory.findMany({
        where,
        skip: getPaginationSkip(params),
        take: params.limit,
        orderBy: { createdAt: 'desc' },
        include: { image: { select: { id: true, originalFilename: true, thumbnailUrl: true } } },
      }),
      prisma.imageHistory.count({ where }),
    ]);

    return { items, total };
  },
};
