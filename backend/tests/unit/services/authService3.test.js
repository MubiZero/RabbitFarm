/**
 * Tests for authService: forgotPassword, resetPassword, cleanExpiredTokens, logout error path
 */
jest.mock('../../../src/models', () => ({
  User: {
    findOne: jest.fn(),
    update: jest.fn(),
    sequelize: { transaction: jest.fn() }
  },
  RefreshToken: {
    destroy: jest.fn()
  },
  PasswordResetToken: {
    create: jest.fn(),
    findOne: jest.fn(),
    destroy: jest.fn()
  },
  TokenBlacklist: {
    create: jest.fn()
  }
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn(), debug: jest.fn()
}));

const { User, RefreshToken, PasswordResetToken } = require('../../../src/models');
const authService = require('../../../src/services/authService');

describe('AuthService — password reset & token cleanup', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── forgotPassword ──────────────────────────────────────────────────────

  describe('forgotPassword', () => {
    it('должен создать токен для существующего активного пользователя', async () => {
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', is_active: true });
      PasswordResetToken.destroy.mockResolvedValue(1);
      PasswordResetToken.create.mockResolvedValue({});

      const result = await authService.forgotPassword('user@example.com');

      expect(result.success).toBe(true);
      expect(result.token).toBeDefined();
      expect(PasswordResetToken.destroy).toHaveBeenCalledWith({ where: { user_id: 1 } });
      expect(PasswordResetToken.create).toHaveBeenCalled();
    });

    it('должен возвращать success без токена если пользователь не найден (защита от enumeration)', async () => {
      User.findOne.mockResolvedValue(null);

      const result = await authService.forgotPassword('ghost@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.create).not.toHaveBeenCalled();
    });

    it('должен возвращать success без токена если пользователь неактивен', async () => {
      User.findOne.mockResolvedValue({ id: 2, email: 'inactive@example.com', is_active: false });

      const result = await authService.forgotPassword('inactive@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.create).not.toHaveBeenCalled();
    });

    it('должен пробрасывать ошибку БД', async () => {
      User.findOne.mockRejectedValue(new Error('DB error'));

      await expect(authService.forgotPassword('user@example.com')).rejects.toThrow('DB error');
    });
  });

  // ─── resetPassword ───────────────────────────────────────────────────────

  describe('resetPassword', () => {
    const makeTransaction = () => ({
      commit: jest.fn(),
      rollback: jest.fn()
    });

    it('должен сменить пароль по валидному токену', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);

      const mockRecord = {
        token_hash: 'hash',
        expires_at: new Date(Date.now() + 60 * 60 * 1000), // 1 час в будущем
        User: { id: 1, email: 'user@example.com', is_active: true },
        destroy: jest.fn().mockResolvedValue(true)
      };
      PasswordResetToken.findOne.mockResolvedValue(mockRecord);
      User.update.mockResolvedValue([1]);
      RefreshToken.destroy.mockResolvedValue(1);

      const result = await authService.resetPassword('valid-plain-token', 'NewPassword123!');

      expect(result).toEqual({ success: true });
      expect(User.update).toHaveBeenCalled();
      expect(mockRecord.destroy).toHaveBeenCalled();
      expect(tx.commit).toHaveBeenCalled();
    });

    it('должен бросать INVALID_RESET_TOKEN если токен не найден', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      PasswordResetToken.findOne.mockResolvedValue(null);

      await expect(authService.resetPassword('bad-token', 'NewPassword123!'))
        .rejects.toThrow('INVALID_RESET_TOKEN');
      expect(tx.rollback).toHaveBeenCalled();
    });

    it('должен бросать RESET_TOKEN_EXPIRED если токен просрочен', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);

      const expiredRecord = {
        expires_at: new Date(Date.now() - 1000), // прошлое
        User: { id: 1, is_active: true },
        destroy: jest.fn().mockResolvedValue(true)
      };
      PasswordResetToken.findOne.mockResolvedValue(expiredRecord);

      await expect(authService.resetPassword('expired-token', 'NewPassword123!'))
        .rejects.toThrow('RESET_TOKEN_EXPIRED');
      expect(expiredRecord.destroy).toHaveBeenCalled();
      expect(tx.rollback).toHaveBeenCalled();
    });

    it('должен бросать USER_INACTIVE если пользователь неактивен', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);

      const record = {
        expires_at: new Date(Date.now() + 60 * 60 * 1000),
        User: { id: 2, is_active: false },
        destroy: jest.fn()
      };
      PasswordResetToken.findOne.mockResolvedValue(record);

      await expect(authService.resetPassword('token', 'NewPassword123!'))
        .rejects.toThrow('USER_INACTIVE');
      expect(tx.rollback).toHaveBeenCalled();
    });
  });

  // ─── cleanExpiredTokens ──────────────────────────────────────────────────

  describe('cleanExpiredTokens', () => {
    it('должен удалять просроченные refresh токены и вернуть количество', async () => {
      RefreshToken.destroy.mockResolvedValue(5);

      const deleted = await authService.cleanExpiredTokens();

      expect(deleted).toBe(5);
      expect(RefreshToken.destroy).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({}) })
      );
    });

    it('должен пробрасывать ошибку БД', async () => {
      RefreshToken.destroy.mockRejectedValue(new Error('DB error'));

      await expect(authService.cleanExpiredTokens()).rejects.toThrow('DB error');
    });
  });

  // ─── logout error path ───────────────────────────────────────────────────

  describe('logout — error path', () => {
    it('должен пробрасывать ошибку если destroy упал', async () => {
      RefreshToken.destroy.mockRejectedValue(new Error('DB failure'));

      await expect(authService.logout('some-token', null)).rejects.toThrow('DB failure');
    });
  });
});
