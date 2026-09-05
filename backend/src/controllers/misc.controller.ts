import { FastifyReply, FastifyRequest } from 'fastify';
import { prisma } from '../config/database';
import { HistoryRepository } from '../repositories/history.repository';
import { assertOwnership } from '../middlewares/auth';
import { NotFoundError } from '../utils/errors';
import { successResponse, getPaginationMeta } from '../utils/response';
import { ExportService } from '../services/export.service';

const exportService = new ExportService();

// ─────────────────────────────────────────────
// History & Export Controller
// ─────────────────────────────────────────────

export const HistoryController = {
  async listProjectHistory(request: FastifyRequest, reply: FastifyReply) {
    const { projectId } = request.params as { projectId: string };
    const userId = request.user.sub;
    const {
      page = '1',
      limit = '30',
      action,
      dateFrom,
      dateTo,
    } = request.query as Record<string, string>;

    const project = await prisma.project.findFirst({
      where: { id: projectId, userId, deletedAt: null },
    });
    if (!project) throw new NotFoundError('Project not found');

    const { items, total } = await HistoryRepository.findManyByProject(projectId, {
      page: Number(page),
      limit: Number(limit),
      action: action as any,
      dateFrom: dateFrom ? new Date(dateFrom) : undefined,
      dateTo: dateTo ? new Date(dateTo) : undefined,
    });

    return reply.send(
      successResponse('History retrieved', items, getPaginationMeta(total, { page: Number(page), limit: Number(limit) })),
    );
  },

  async exportProject(request: FastifyRequest, reply: FastifyReply) {
    const { projectId } = request.params as { projectId: string };
    const userId = request.user.sub;

    const result = await exportService.exportProject(projectId, userId);

    return reply
      .header('Content-Type', 'application/zip')
      .header('Content-Disposition', `attachment; filename="${result.filename}"`)
      .sendFile(result.filePath, { root: '/' });
  },
};

// ─────────────────────────────────────────────
// C2PA Template Controller
// ─────────────────────────────────────────────

export const TemplateController = {
  async list(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const templates = await prisma.c2paTemplate.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
    return reply.send(successResponse('Templates retrieved', templates));
  },

  async create(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const data = request.body as Record<string, unknown>;

    const template = await prisma.c2paTemplate.create({
      data: { userId, ...data } as any,
    });

    return reply.status(201).send(successResponse('Template created', template));
  },

  async delete(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const template = await prisma.c2paTemplate.findFirst({ where: { id } });
    if (!template) throw new NotFoundError('Template not found');
    assertOwnership(template.userId, userId, 'template');

    await prisma.c2paTemplate.delete({ where: { id } });
    return reply.send(successResponse('Template deleted'));
  },
};

// ─────────────────────────────────────────────
// Settings Controller
// ─────────────────────────────────────────────

export const SettingsController = {
  async get(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const settings = await prisma.userSetting.findUnique({ where: { userId } });
    return reply.send(successResponse('Settings retrieved', settings));
  },

  async update(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const data = request.body as Record<string, unknown>;

    const settings = await prisma.userSetting.upsert({
      where: { userId },
      create: { userId, ...data } as any,
      update: { ...data } as any,
    });

    return reply.send(successResponse('Settings updated', settings));
  },
};
