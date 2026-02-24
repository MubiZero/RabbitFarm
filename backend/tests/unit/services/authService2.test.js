/**
 * Additional AuthService tests covering methods not tested in authService.test.js
 * Covers: refreshAccessToken, logout, getProfile, updateProfile, changePassword
 */
jest.mock('../../../src/models', () => ({
  User: {
    findOne: jest.fn(),
    findByPk: jest.fn(),
    create: jest.fn(),
    sequelize: { transaction: jest.fn() }
  },
  RefreshToken: {
    create: jest.fn(),
    findOne: jest.fn(),
    destroy: jest.fn()
  },
  TokenBlacklist: {
    create: jest.fn()
  },
  PasswordResetToken: {
    findOne: jest.fn(),
    destroy: jest.fn(),
    create: jest.fn()
  }
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

jest.mock('../../../src/utils/jwt', () => ({
  generateAccessToken: jest.fn(() => 'new-access-token'),
  generateRefreshToken: jest.fn(() => 'new-refresh-token'),
  verifyRefreshToken: jest.fn(() => ({ id: 1 })),
  verifyAccessToken: jest.fn(() => ({ id: 1, jti: 'token-jti', exp: Math.floor(Date.now() / 1000) + 3600 }))
}));

jest.mock('../../../src/utils/password', () => ({
  hash: jest.fn((pw) => Promise.resolve(`hashed-${pw}`)),
  compare: jest.fn()
}));

const { User, RefreshToken, TokenBlacklist, PasswordResetToken } = require('../../../src/models');
const PasswordUtil = require('../../../src/utils/password');
const authService = require('../../../src/services/authService');

describe('AuthService - extended methods', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('refreshAccessToken', () => {
    it('should return new tokens for valid refresh token', async () => {
      const mockToken = {
        token: 'refresh-token',
        expires_at: new Date(Date.now() + 86400000), // future
        User: { id: 1, email: 'test@ex.com', role: 'owner', is_active: true },
        update: jest.fn().mockResolvedValue(true)
      };
      RefreshToken.findOne.mockResolvedValue(mockToken);

      const result = await authService.refreshAccessToken('refresh-token');

      expect(result).toHaveProperty('access_token');
      expect(result).toHaveProperty('refresh_token');
    });

    it('should throw INVALID_REFRESH_TOKEN if token not found', async () => {
      RefreshToken.findOne.mockResolvedValue(null);

      await expect(authService.refreshAccessToken('bad-token'))
        .rejects.toThrow('INVALID_REFRESH_TOKEN');
    });

    it('should throw REFRESH_TOKEN_EXPIRED if token is expired', async () => {
      const mockToken = {
        token: 'refresh-token',
        expires_at: new Date(Date.now() - 1000), // past (expired)
        User: { id: 1, email: 'test@ex.com', role: 'owner', is_active: true },
        destroy: jest.fn().mockResolvedValue(true)
      };
      RefreshToken.findOne.mockResolvedValue(mockToken);

      await expect(authService.refreshAccessToken('refresh-token'))
        .rejects.toThrow('REFRESH_TOKEN_EXPIRED');
      expect(mockToken.destroy).toHaveBeenCalled();
    });

    it('should throw USER_INACTIVE if user is not active', async () => {
      const mockToken = {
        expires_at: new Date(Date.now() + 86400000),
        User: { id: 1, email: 'test@ex.com', role: 'owner', is_active: false }
      };
      RefreshToken.findOne.mockResolvedValue(mockToken);

      await expect(authService.refreshAccessToken('refresh-token'))
        .rejects.toThrow('USER_INACTIVE');
    });
  });

  describe('logout', () => {
    it('should delete refresh token and blacklist access token', async () => {
      RefreshToken.destroy.mockResolvedValue(1);
      TokenBlacklist.create.mockResolvedValue({});

      const result = await authService.logout('refresh-token', 'access-token');

      expect(RefreshToken.destroy).toHaveBeenCalledWith({ where: { token: 'refresh-token' } });
      expect(result).toHaveProperty('success', true);
    });

    it('should succeed even without access token', async () => {
      RefreshToken.destroy.mockResolvedValue(1);

      const result = await authService.logout('refresh-token', null);

      expect(result).toHaveProperty('success', true);
      expect(TokenBlacklist.create).not.toHaveBeenCalled();
    });
  });

  describe('getProfile', () => {
    it('should return user profile', async () => {
      const user = { id: 1, email: 'test@ex.com', full_name: 'Test' };
      User.findByPk.mockResolvedValue(user);

      const result = await authService.getProfile(1);

      expect(result).toEqual(user);
      expect(User.findByPk).toHaveBeenCalledWith(1, expect.any(Object));
    });

    it('should throw USER_NOT_FOUND if user does not exist', async () => {
      User.findByPk.mockResolvedValue(null);

      await expect(authService.getProfile(999))
        .rejects.toThrow('USER_NOT_FOUND');
    });
  });

  describe('updateProfile', () => {
    it('should update and return user profile', async () => {
      const user = {
        id: 1,
        email: 'test@ex.com',
        update: jest.fn().mockResolvedValue(true),
        toJSON: jest.fn().mockReturnValue({ id: 1, email: 'test@ex.com', full_name: 'Updated' })
      };
      User.findByPk.mockResolvedValue(user);

      const result = await authService.updateProfile(1, { full_name: 'Updated' });

      expect(user.update).toHaveBeenCalledWith({ full_name: 'Updated' });
      expect(result).toHaveProperty('full_name', 'Updated');
    });

    it('should throw USER_NOT_FOUND if user does not exist', async () => {
      User.findByPk.mockResolvedValue(null);

      await expect(authService.updateProfile(999, { full_name: 'Test' }))
        .rejects.toThrow('USER_NOT_FOUND');
    });
  });

  describe('changePassword', () => {
    const mockTx = { commit: jest.fn(), rollback: jest.fn() };

    beforeEach(() => {
      User.sequelize.transaction.mockResolvedValue(mockTx);
    });

    it('should change password successfully', async () => {
      const user = {
        id: 1,
        password_hash: 'hashed-oldpass',
        update: jest.fn().mockResolvedValue(true)
      };
      User.findByPk.mockResolvedValue(user);
      PasswordUtil.compare.mockResolvedValue(true);
      RefreshToken.destroy.mockResolvedValue(1);

      const result = await authService.changePassword(1, 'oldpass', 'newpass');

      expect(result).toHaveProperty('success', true);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw USER_NOT_FOUND if user does not exist', async () => {
      User.findByPk.mockResolvedValue(null);

      await expect(authService.changePassword(999, 'old', 'new'))
        .rejects.toThrow('USER_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw INVALID_CURRENT_PASSWORD if current password is wrong', async () => {
      const user = { id: 1, password_hash: 'hashed-oldpass' };
      User.findByPk.mockResolvedValue(user);
      PasswordUtil.compare.mockResolvedValue(false);

      await expect(authService.changePassword(1, 'wrongpass', 'newpass'))
        .rejects.toThrow('INVALID_CURRENT_PASSWORD');
      expect(mockTx.rollback).toHaveBeenCalled();
    });
  });
});
