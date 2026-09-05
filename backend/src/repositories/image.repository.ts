import { Image, ImageStatus, Prisma } from '@prisma/client';
import { prisma } from '../config/database';
import { PaginationParams, getPaginationSkip } from '../utils/response';

// ─────────────────────────────────────────────
// Image Repository
// ─────────────────────────────────────────────

export interface ImageListParams extends PaginationParams {
  projectId: string;
  status?: ImageStatus;
  search?: string;
}

export const ImageRepository = {
  async findById(id: string) {
    return prisma.image.findFirst({
      where: { id, deletedAt: null },
      include: { metadata: true, c2paManifest: true },
    });
  },

  async findByIdRaw(id: string): Promise<Image | null> {
    return prisma.image.findFirst({ where: { id, deletedAt: null } });
  },

  async findManyByProject(params: ImageListParams) {
    const where: Prisma.ImageWhereInput = {
      projectId: params.projectId,
      deletedAt: null,
      ...(params.status && { status: params.status }),
      ...(params.search && {
        originalFilename: { contains: params.search, mode: 'insensitive' },
      }),
    };

    const [items, total] = await prisma.$transaction([
      prisma.image.findMany({
        where,
        skip: getPaginationSkip(params),
        take: params.limit,
        orderBy: { createdAt: 'desc' },
        include: { metadata: true, c2paManifest: true },
      }),
      prisma.image.count({ where }),
    ]);

    return { items, total };
  },

  async create(data: Prisma.ImageCreateInput): Promise<Image> {
    return prisma.image.create({ data });
  },

  async update(id: string, data: Prisma.ImageUpdateInput): Promise<Image> {
    return prisma.image.update({ where: { id }, data });
  },

  async softDelete(id: string): Promise<void> {
    await prisma.image.update({
      where: { id },
      data: { deletedAt: new Date(), status: 'ERROR' },
    });
  },

  async updateStatus(id: string, status: ImageStatus): Promise<void> {
    await prisma.image.update({ where: { id }, data: { status } });
  },

  async upsertMetadata(
    imageId: string,
    data: Prisma.ImageMetadataCreateWithoutImageInput,
  ) {
    return prisma.imageMetadata.upsert({
      where: { imageId },
      create: { imageId, ...data },
      update: { ...data, updatedAt: new Date() },
    });
  },

  async upsertC2paManifest(
    imageId: string,
    data: Prisma.C2paManifestCreateWithoutImageInput,
  ) {
    return prisma.c2paManifest.upsert({
      where: { imageId },
      create: { imageId, ...data },
      update: { ...data, updatedAt: new Date() },
    });
  },

  async deleteC2paManifest(imageId: string): Promise<void> {
    await prisma.c2paManifest.deleteMany({ where: { imageId } });
  },
};
