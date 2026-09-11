/**
 * Tests for authService: cleanExpiredTokens, logout error path
 */
jest.mock('../../../src/models', () => ({
  User: {
    count: jest.fn().mockResolvedValue(0),
    findOne: jest.fn(),
    update: jest.fn(),
    sequelize: { transaction: jest.fn() }
  },
  RefreshToken: {
    destroy: jest.fn()
  },
  LoginOtp: {
    destroy: jest.fn().mockResolvedValue(0)
  },
  TokenBlacklist: {
    create: jest.fn()
  }
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn(), debug: jest.fn()
}));

const { RefreshToken, LoginOtp } = require('../../../src/models');
const authService = require('../../../src/services/authService');

describe('AuthService — token cleanup', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── cleanExpiredTokens ──────────────────────────────────────────────────

  describe('cleanExpiredTokens', () => {
    it('должен удалять просроченные refresh токены и вернуть количество', async () => {
      RefreshToken.destroy.mockResolvedValue(5);

      const deleted = await authService.cleanExpiredTokens();

      expect(deleted).toBe(5);
      expect(RefreshToken.destroy).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({}) })
      );
      // Записи о кодах входа живут дольше самих кодов — по ним считается
      // окно «сколько кодов запросили» (см. otpAuthService), поэтому их
      // подчищает та же уборка.
      expect(LoginOtp.destroy).toHaveBeenCalledWith(
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
