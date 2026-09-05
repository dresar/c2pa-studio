import { FastifyInstance } from 'fastify';
import { AuthController } from '../controllers/auth.controller';
import { authenticate } from '../middlewares/auth';

// ─────────────────────────────────────────────
// Auth Routes
// POST /api/v1/auth/register
// POST /api/v1/auth/login
// POST /api/v1/auth/refresh
// POST /api/v1/auth/logout
// POST /api/v1/auth/logout-all
// GET  /api/v1/auth/me
// ─────────────────────────────────────────────

export async function authRoutes(fastify: FastifyInstance): Promise<void> {
  const controller = new AuthController(fastify);

  fastify.post('/register', controller.register);
  fastify.post('/login', controller.login);
  fastify.post('/refresh', controller.refresh);
  fastify.post('/logout', controller.logout);

  // Protected routes
  fastify.post('/logout-all', { preHandler: [authenticate] }, controller.logoutAll);
  fastify.get('/me', { preHandler: [authenticate] }, controller.getProfile);
  fastify.patch('/me', { preHandler: [authenticate] }, controller.updateProfile);
}
