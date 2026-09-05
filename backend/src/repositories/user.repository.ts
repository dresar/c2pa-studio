import { Prisma, User } from '@prisma/client';
import { prisma } from '../config/database';

// ─────────────────────────────────────────────
// User Repository — all DB access for User entity
// ─────────────────────────────────────────────

export type UserWithoutPassword = Omit<User, 'passwordHash'>;

export const UserRepository = {
  async findById(id: string): Promise<User | null> {
    return prisma.user.findFirst({
      where: { id, deletedAt: null },
    });
  },

  async findByEmail(email: string): Promise<User | null> {
    return prisma.user.findFirst({
      where: { email, deletedAt: null },
    });
  },

  async findByUsername(username: string): Promise<User | null> {
    return prisma.user.findFirst({
      where: { username, deletedAt: null },
    });
  },

  async create(data: Prisma.UserCreateInput): Promise<User> {
    return prisma.user.create({ data });
  },

  async update(id: string, data: Prisma.UserUpdateInput): Promise<User> {
    return prisma.user.update({ where: { id }, data });
  },

  async softDelete(id: string): Promise<void> {
    await prisma.user.update({
      where: { id },
      data: { deletedAt: new Date() },
    });
  },

  async findWithSettings(id: string) {
    return prisma.user.findFirst({
      where: { id, deletedAt: null },
      include: { settings: true },
    });
  },

  stripPassword(user: User): UserWithoutPassword {
    const { passwordHash: _pw, ...rest } = user;
    return rest;
  },
};
