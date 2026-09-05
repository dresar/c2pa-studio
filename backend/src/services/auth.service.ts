import bcrypt from 'bcryptjs';
import { FastifyInstance } from 'fastify';
import { v4 as uuidv4 } from 'uuid';
import { env } from '../config/env';
import { UserRepository } from '../repositories/user.repository';
import { RefreshTokenRepository } from '../repositories/refreshToken.repository';
import { AuthError, ConflictError, NotFoundError } from '../utils/errors';
import { logger } from '../utils/logger';

// ─────────────────────────────────────────────
// Auth Service
// ─────────────────────────────────────────────

export interface RegisterInput {
  email: string;
  username: string;
  password: string;
  displayName?: string;
}

export interface LoginInput {
  email: string;
  password: string;
}

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  expiresIn: string;
}

export class AuthService {
  constructor(private readonly fastify: FastifyInstance) {}

  async register(input: RegisterInput): Promise<AuthTokens> {
    // Check email uniqueness
    const existingByEmail = await UserRepository.findByEmail(input.email);
    if (existingByEmail) {
      throw new ConflictError('Email is already registered');
    }

    // Check username uniqueness
    const existingByUsername = await UserRepository.findByUsername(input.username);
    if (existingByUsername) {
      throw new ConflictError('Username is already taken');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(input.password, 12);

    // Create user with default settings
    const user = await UserRepository.create({
      email: input.email,
      username: input.username.toLowerCase(),
      passwordHash,
      displayName: input.displayName ?? input.username,
      settings: {
        create: {
          theme: 'dark',
          language: 'en',
          autoScan: true,
          autoSave: true,
        },
      },
    });

    logger.info({ userId: user.id, email: user.email }, 'User registered');

    return this.generateTokens(user.id, user.email, user.username);
  }

  async login(input: LoginInput): Promise<AuthTokens> {
    const user = await UserRepository.findByEmail(input.email);

    if (!user || !user.isActive) {
      throw new AuthError('Invalid email or password');
    }

    const passwordMatch = await bcrypt.compare(input.password, user.passwordHash);
    if (!passwordMatch) {
      throw new AuthError('Invalid email or password');
    }

    logger.info({ userId: user.id }, 'User logged in');

    return this.generateTokens(user.id, user.email, user.username);
  }

  async refreshTokens(refreshToken: string): Promise<AuthTokens> {
    const storedToken = await RefreshTokenRepository.findByToken(refreshToken);

    if (!storedToken) {
      throw new AuthError('Invalid or expired refresh token');
    }

    const user = await UserRepository.findById(storedToken.userId);
    if (!user || !user.isActive) {
      throw new AuthError('User not found or inactive');
    }

    // Revoke old token (rotation)
    await RefreshTokenRepository.revoke(storedToken.id);

    logger.info({ userId: user.id }, 'Token refreshed');

    return this.generateTokens(user.id, user.email, user.username);
  }

  async logout(refreshToken: string): Promise<void> {
    const storedToken = await RefreshTokenRepository.findByToken(refreshToken);
    if (storedToken) {
      await RefreshTokenRepository.revoke(storedToken.id);
    }
  }

  async logoutAll(userId: string): Promise<void> {
    await RefreshTokenRepository.revokeAllForUser(userId);
    logger.info({ userId }, 'All sessions revoked');
  }

  // ─────────────────────────────────────────────
  // Private: generate access + refresh tokens
  // ─────────────────────────────────────────────
  private async generateTokens(
    userId: string,
    email: string,
    username: string,
  ): Promise<AuthTokens> {
    const payload = { sub: userId, email, username };

    const accessToken = this.fastify.jwt.sign(payload, {
      expiresIn: env.JWT_EXPIRES_IN,
    });

    const rawRefreshToken = uuidv4();
    const refreshExpiresAt = new Date();
    refreshExpiresAt.setDate(refreshExpiresAt.getDate() + 7); // 7 days

    await RefreshTokenRepository.create({
      token: rawRefreshToken,
      user: { connect: { id: userId } },
      expiresAt: refreshExpiresAt,
    });

    return {
      accessToken,
      refreshToken: rawRefreshToken,
      expiresIn: env.JWT_EXPIRES_IN,
    };
  }

  async getProfile(userId: string) {
    const user = await UserRepository.findWithSettings(userId);
    if (!user) throw new NotFoundError('User not found');
    return UserRepository.stripPassword(user);
  }

  async updateProfile(userId: string, input: { displayName?: string; password?: string }) {
    const data: any = {};
    if (input.displayName) data.displayName = input.displayName;
    if (input.password) {
      data.passwordHash = await bcrypt.hash(input.password, 12);
    }
    const updated = await UserRepository.update(userId, data);
    return UserRepository.stripPassword(updated);
  }
}
