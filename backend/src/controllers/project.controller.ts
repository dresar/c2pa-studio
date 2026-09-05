import { FastifyReply, FastifyRequest } from 'fastify';
import { ProjectRepository } from '../repositories/project.repository';
import { assertOwnership } from '../middlewares/auth';
import { NotFoundError } from '../utils/errors';
import {
  createProjectSchema,
  updateProjectSchema,
  listProjectsSchema,
} from '../validators/image.validator';
import { successResponse, getPaginationMeta } from '../utils/response';

// ─────────────────────────────────────────────
// Project Controller
// ─────────────────────────────────────────────

export const ProjectController = {
  async list(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const params = listProjectsSchema.parse(request.query);

    const { items, total } = await ProjectRepository.findManyByUser({
      userId,
      page: params.page,
      limit: params.limit,
      search: params.search,
      status: params.status,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    });

    return reply.send(
      successResponse('Projects retrieved', items, getPaginationMeta(total, params)),
    );
  },

  async create(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user.sub;
    const input = createProjectSchema.parse(request.body);

    const project = await ProjectRepository.create({
      name: input.name,
      description: input.description,
      user: { connect: { id: userId } },
    });

    return reply.status(201).send(successResponse('Project created', project));
  },

  async getOne(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const project = await ProjectRepository.findByIdWithImages(id);
    if (!project) throw new NotFoundError('Project not found');
    assertOwnership(project.userId, userId, 'project');

    return reply.send(successResponse('Project retrieved', project));
  },

  async update(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const existing = await ProjectRepository.findById(id);
    if (!existing) throw new NotFoundError('Project not found');
    assertOwnership(existing.userId, userId, 'project');

    const input = updateProjectSchema.parse(request.body);
    const updated = await ProjectRepository.update(id, input);

    return reply.send(successResponse('Project updated', updated));
  },

  async delete(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const userId = request.user.sub;

    const existing = await ProjectRepository.findById(id);
    if (!existing) throw new NotFoundError('Project not found');
    assertOwnership(existing.userId, userId, 'project');

    await ProjectRepository.softDelete(id);
    return reply.send(successResponse('Project deleted'));
  },
};
