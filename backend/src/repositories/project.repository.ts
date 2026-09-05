import { Prisma, Project, ProjectStatus } from '@prisma/client';
import { prisma } from '../config/database';
import { PaginationParams, getPaginationSkip } from '../utils/response';

// ─────────────────────────────────────────────
// Project Repository
// ─────────────────────────────────────────────

export interface ProjectListParams extends PaginationParams {
  userId: string;
  search?: string;
  status?: ProjectStatus;
  sortBy?: 'name' | 'createdAt' | 'updatedAt';
  sortOrder?: 'asc' | 'desc';
}

export const ProjectRepository = {
  async findById(id: string): Promise<Project | null> {
    return prisma.project.findFirst({
      where: { id, deletedAt: null },
    });
  },

  async findByIdWithImages(id: string) {
    return prisma.project.findFirst({
      where: { id, deletedAt: null },
      include: {
        images: {
          where: { deletedAt: null },
          orderBy: { createdAt: 'desc' },
        },
      },
    });
  },

  async findManyByUser(params: ProjectListParams) {
    const where: Prisma.ProjectWhereInput = {
      userId: params.userId,
      deletedAt: null,
      ...(params.status && { status: params.status }),
      ...(params.search && {
        name: { contains: params.search, mode: 'insensitive' },
      }),
    };

    const [items, total] = await prisma.$transaction([
      prisma.project.findMany({
        where,
        skip: getPaginationSkip(params),
        take: params.limit,
        orderBy: { [params.sortBy ?? 'updatedAt']: params.sortOrder ?? 'desc' },
        include: { _count: { select: { images: true } } },
      }),
      prisma.project.count({ where }),
    ]);

    return { items, total };
  },

  async create(data: Prisma.ProjectCreateInput): Promise<Project> {
    return prisma.project.create({ data });
  },

  async update(id: string, data: Prisma.ProjectUpdateInput): Promise<Project> {
    return prisma.project.update({ where: { id }, data });
  },

  async softDelete(id: string): Promise<void> {
    await prisma.project.update({
      where: { id },
      data: { deletedAt: new Date(), status: 'DELETED' },
    });
  },

  async incrementImageCount(id: string, sizeBytes: bigint): Promise<void> {
    await prisma.project.update({
      where: { id },
      data: {
        totalImages: { increment: 1 },
        totalSizeBytes: { increment: sizeBytes },
        updatedAt: new Date(),
      },
    });
  },

  async decrementImageCount(id: string, sizeBytes: bigint): Promise<void> {
    await prisma.project.update({
      where: { id },
      data: {
        totalImages: { decrement: 1 },
        totalSizeBytes: { decrement: sizeBytes },
        updatedAt: new Date(),
      },
    });
  },
};
