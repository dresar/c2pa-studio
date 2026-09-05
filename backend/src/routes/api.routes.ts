import { FastifyInstance } from 'fastify';
import { ProjectController } from '../controllers/project.controller';
import { ImageController } from '../controllers/image.controller';
import { HistoryController, TemplateController, SettingsController } from '../controllers/misc.controller';
import { authenticate } from '../middlewares/auth';

// ─────────────────────────────────────────────
// All protected API routes
// ─────────────────────────────────────────────

export async function apiRoutes(fastify: FastifyInstance): Promise<void> {
  // Apply auth middleware to all routes in this plugin
  fastify.addHook('preHandler', authenticate);

  // ─────────────────────────────────────────────
  // Projects
  // GET    /api/v1/projects
  // POST   /api/v1/projects
  // GET    /api/v1/projects/:id
  // PATCH  /api/v1/projects/:id
  // DELETE /api/v1/projects/:id
  // GET    /api/v1/projects/:id/history
  // GET    /api/v1/projects/:id/export  (ZIP)
  // ─────────────────────────────────────────────
  fastify.get('/projects', ProjectController.list);
  fastify.post('/projects', ProjectController.create);
  fastify.get('/projects/:id', ProjectController.getOne);
  fastify.patch('/projects/:id', ProjectController.update);
  fastify.delete('/projects/:id', ProjectController.delete);
  fastify.get('/projects/:projectId/history', HistoryController.listProjectHistory);
  fastify.get('/projects/:projectId/export', HistoryController.exportProject);

  // ─────────────────────────────────────────────
  // Images (within a project)
  // POST   /api/v1/projects/:projectId/images/upload
  // GET    /api/v1/projects/:projectId/images
  // GET    /api/v1/images/:id
  // DELETE /api/v1/images/:id
  // POST   /api/v1/images/:id/compress
  // POST   /api/v1/images/:id/resize
  // POST   /api/v1/images/:id/remove-metadata
  // POST   /api/v1/images/:id/remove-gps
  // POST   /api/v1/images/:id/remove-c2pa
  // POST   /api/v1/images/:id/create-c2pa
  // POST   /api/v1/images/:id/rescan
  // GET    /api/v1/images/:id/history
  // GET    /api/v1/images/:id/export
  // POST   /api/v1/images/export-multiple
  // POST   /api/v1/images/batch
  // ─────────────────────────────────────────────
  fastify.post('/projects/:projectId/images/upload', ImageController.upload);
  fastify.get('/projects/:projectId/images', ImageController.list);
  fastify.get('/images/:id', ImageController.getOne);
  fastify.delete('/images/:id', ImageController.delete);
  fastify.post('/images/:id/compress', ImageController.compress);
  fastify.post('/images/:id/resize', ImageController.resize);
  fastify.post('/images/:id/remove-metadata', (req, rep) => {
    (req.params as any).type = 'all';
    return ImageController.removeMetadata(req, rep);
  });
  fastify.post('/images/:id/remove-gps', (req, rep) => {
    (req.params as any).type = 'gps';
    return ImageController.removeMetadata(req, rep);
  });
  fastify.post('/images/:id/remove-c2pa', (req, rep) => {
    (req.params as any).type = 'c2pa';
    return ImageController.removeMetadata(req, rep);
  });
  fastify.post('/images/:id/create-c2pa', ImageController.createC2pa);
  fastify.post('/images/:id/rescan', ImageController.rescan);
  fastify.get('/images/:id/history', ImageController.history);
  fastify.get('/images/:id/export', ImageController.exportSingle);
  fastify.post('/images/export-multiple', ImageController.exportMultiple);
  fastify.post('/images/batch', ImageController.batch);

  // ─────────────────────────────────────────────
  // C2PA Templates
  // GET    /api/v1/templates
  // POST   /api/v1/templates
  // DELETE /api/v1/templates/:id
  // ─────────────────────────────────────────────
  fastify.get('/templates', TemplateController.list);
  fastify.post('/templates', TemplateController.create);
  fastify.delete('/templates/:id', TemplateController.delete);

  // ─────────────────────────────────────────────
  // Settings
  // GET   /api/v1/settings
  // PATCH /api/v1/settings
  // ─────────────────────────────────────────────
  fastify.get('/settings', SettingsController.get);
  fastify.patch('/settings', SettingsController.update);
}
