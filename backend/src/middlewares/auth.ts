import { FastifyReply, FastifyRequest } from 'fastify';
import { AuthError, ForbiddenError } from '../utils/errors';

// ─────────────────────────────────────────────
// JWT Authentication Middleware
// ─────────────────────────────────────────────
export async function authenticate(
  request: FastifyRequest,
  reply: FastifyReply,
): Promise<void> {
  try {
    await request.jwtVerify();
  } catch {
    throw new AuthError('Invalid or expired token');
  }
}

// ─────────────────────────────────────────────
// Optional Auth (doesn't throw if no token)
// ─────────────────────────────────────────────
export async function optionalAuthenticate(
  request: FastifyRequest,
  _reply: FastifyReply,
): Promise<void> {
  try {
    await request.jwtVerify();
  } catch {
    // No token present — continue without user context
  }
}

// ─────────────────────────────────────────────
// Resource ownership check helper
// ─────────────────────────────────────────────
export function assertOwnership(
  ownerId: string,
  requestUserId: string,
  resourceName: string = 'resource',
): void {
  if (ownerId !== requestUserId) {
    throw new ForbiddenError(`You do not have access to this ${resourceName}`);
  }
}

// ─────────────────────────────────────────────
// JWT Payload Type Augmentation
// ─────────────────────────────────────────────
declare module '@fastify/jwt' {
  interface FastifyJWT {
    payload: {
      sub: string;     // userId
      email: string;
      username: string;
      iat: number;
      exp: number;
    };
    user: {
      sub: string;
      email: string;
      username: string;
      iat: number;
      exp: number;
    };
  }
}
