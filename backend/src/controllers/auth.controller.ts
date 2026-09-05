import { FastifyReply, FastifyRequest } from 'fastify';
import { AuthService } from '../services/auth.service';
import {
  registerSchema,
  loginSchema,
  refreshTokenSchema,
} from '../validators/auth.validator';
import { successResponse } from '../utils/response';

// ─────────────────────────────────────────────
// Auth Controller
// ─────────────────────────────────────────────

export class AuthController {
  private authService: AuthService;

  constructor(fastify: Parameters<typeof AuthService.prototype.constructor>[0]) {
    this.authService = new AuthService(fastify);
  }

  register = async (request: FastifyRequest, reply: FastifyReply) => {
    const input = registerSchema.parse(request.body);
    const tokens = await this.authService.register(input);

    return reply.status(201).send(
      successResponse('Registration successful', tokens),
    );
  };

  login = async (request: FastifyRequest, reply: FastifyReply) => {
    const input = loginSchema.parse(request.body);
    const tokens = await this.authService.login(input);

    return reply.send(successResponse('Login successful', tokens));
  };

  refresh = async (request: FastifyRequest, reply: FastifyReply) => {
    const { refreshToken } = refreshTokenSchema.parse(request.body);
    const tokens = await this.authService.refreshTokens(refreshToken);

    return reply.send(successResponse('Tokens refreshed', tokens));
  };

  logout = async (request: FastifyRequest, reply: FastifyReply) => {
    const { refreshToken } = refreshTokenSchema.parse(request.body);
    await this.authService.logout(refreshToken);

    return reply.send(successResponse('Logged out successfully'));
  };

  logoutAll = async (request: FastifyRequest, reply: FastifyReply) => {
    const userId = request.user.sub;
    await this.authService.logoutAll(userId);

    return reply.send(successResponse('All sessions revoked'));
  };

  getProfile = async (request: FastifyRequest, reply: FastifyReply) => {
    const profile = await this.authService.getProfile(request.user.sub);
    return reply.send(successResponse('Profile retrieved', profile));
  };

  updateProfile = async (request: FastifyRequest, reply: FastifyReply) => {
    const userId = request.user.sub;
    const body = request.body as { displayName?: string; password?: string };
    const updated = await this.authService.updateProfile(userId, body);
    return reply.send(successResponse('Profile updated successfully', updated));
  };
}
