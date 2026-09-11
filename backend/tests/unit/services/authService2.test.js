/**
 * Additional AuthService tests covering methods not tested in authService.test.js
 * Covers: refreshAccessToken, logout, getProfile, updateProfile
 */
jest.mock('../../../src/models', () => ({
  User: {
    count: jest.fn().mockResolvedValue(0),
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

const { User, RefreshToken, TokenBlacklist } = require('../../../src/models');
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
});
