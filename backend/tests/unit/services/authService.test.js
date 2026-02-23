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
  }
}));

const { User, RefreshToken } = require('../../../src/models');
const authService = require('../../../src/services/authService');
const PasswordUtil = require('../../../src/utils/password');
const { createMockUser } = require('../../helpers/mockModels');

describe('AuthService', () => {
  let validPasswordHash;

  beforeAll(async () => {
    validPasswordHash = await PasswordUtil.hash('password123');
  });

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('login', () => {
    it('должен успешно логинить пользователя с верными данными', async () => {
      const mockUser = createMockUser({ password_hash: validPasswordHash });
      mockUser.update = jest.fn().mockResolvedValue(true);
      User.findOne.mockResolvedValue(mockUser);
      RefreshToken.create.mockResolvedValue({});

      const result = await authService.login('test@example.com', 'password123');

      expect(result).toHaveProperty('access_token');
      expect(result).toHaveProperty('refresh_token');
      expect(result).toHaveProperty('user');
      expect(User.findOne).toHaveBeenCalledWith({ where: { email: 'test@example.com' } });
    });

    it('должен бросать INVALID_CREDENTIALS если пользователь не найден', async () => {
      User.findOne.mockResolvedValue(null);

      await expect(authService.login('notexist@example.com', 'password'))
        .rejects.toThrow('INVALID_CREDENTIALS');
    });

    it('должен бросать USER_INACTIVE если аккаунт неактивен', async () => {
      User.findOne.mockResolvedValue(createMockUser({ is_active: false }));

      await expect(authService.login('test@example.com', 'password'))
        .rejects.toThrow('USER_INACTIVE');
    });

    it('должен бросать INVALID_CREDENTIALS при неверном пароле', async () => {
      const mockUser = createMockUser({ password_hash: validPasswordHash });
      User.findOne.mockResolvedValue(mockUser);

      await expect(authService.login('test@example.com', 'wrongpassword'))
        .rejects.toThrow('INVALID_CREDENTIALS');
    });
  });

  describe('register', () => {
    it('должен бросать USER_EXISTS если email занят', async () => {
      const mockTransaction = {
        commit: jest.fn(),
        rollback: jest.fn()
      };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(createMockUser());

      await expect(authService.register({
        email: 'test@example.com',
        password: 'password123',
        full_name: 'Test User'
      })).rejects.toThrow('USER_EXISTS');

      expect(mockTransaction.rollback).toHaveBeenCalled();
    });
  });

  describe('logout', () => {
    it('должен удалять refresh token из БД', async () => {
      RefreshToken.destroy.mockResolvedValue(1);
      const result = await authService.logout('some-refresh-token');
      expect(result).toEqual({ success: true });
      expect(RefreshToken.destroy).toHaveBeenCalledWith({ where: { token: 'some-refresh-token' } });
    });
  });

  describe('getProfile', () => {
    it('должен возвращать пользователя по ID', async () => {
      const mockUser = createMockUser();
      User.findByPk.mockResolvedValue(mockUser);

      const user = await authService.getProfile(1);
      expect(user).toEqual(mockUser);
      expect(User.findByPk).toHaveBeenCalledWith(1, expect.objectContaining({
        attributes: expect.objectContaining({ exclude: ['password_hash'] })
      }));
    });

    it('должен бросать USER_NOT_FOUND если пользователь не существует', async () => {
      User.findByPk.mockResolvedValue(null);
      await expect(authService.getProfile(999)).rejects.toThrow('USER_NOT_FOUND');
    });
  });
});
