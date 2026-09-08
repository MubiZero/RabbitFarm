jest.mock('../../../src/models', () => ({
  Farm: {
    create: jest.fn()
  },
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
  }
}));
jest.mock('../../../src/services/planService', () => ({
  getDefault: jest.fn()
}));

const { Farm, User, RefreshToken } = require('../../../src/models');
const planService = require('../../../src/services/planService');
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
    // По умолчанию дефолтного тарифа нет — как до появления п. 1.2.
    planService.getDefault.mockResolvedValue(null);
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

    // Про отключённый аккаунт узнаёт только тот, кто назвал верный пароль:
    // иначе ответ 403 подтверждал бы, что такой адрес заведён на ферме.
    it('должен бросать USER_INACTIVE если аккаунт неактивен', async () => {
      User.findOne.mockResolvedValue(
        createMockUser({ is_active: false, password_hash: validPasswordHash })
      );

      await expect(authService.login('test@example.com', 'password123'))
        .rejects.toThrow('USER_INACTIVE');
    });

    it('на отключённом аккаунте с неверным паролем не выдаёт, что он существует', async () => {
      User.findOne.mockResolvedValue(
        createMockUser({ is_active: false, password_hash: validPasswordHash })
      );

      await expect(authService.login('test@example.com', 'wrongpassword'))
        .rejects.toThrow('INVALID_CREDENTIALS');
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

    it('заводит ферму и делает регистрирующегося её владельцем', async () => {
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(null);

      const farm = { id: 77, update: jest.fn().mockResolvedValue(true) };
      Farm.create.mockResolvedValue(farm);
      User.create.mockResolvedValue(createMockUser({ id: 42, farm_id: 77 }));
      RefreshToken.create.mockResolvedValue({});

      await authService.register({
        email: 'new@example.com',
        password: 'password123',
        full_name: 'Новый Фермер'
      });

      // Ферма появляется первой и без владельца: сослаться на человека,
      // которого ещё нет, нельзя.
      expect(Farm.create).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'Ферма Новый Фермер', owner_id: null }),
        expect.objectContaining({ transaction: mockTransaction })
      );
      // Человек заводится сразу в этой ферме и хозяином.
      expect(User.create).toHaveBeenCalledWith(
        expect.objectContaining({ role: 'owner', farm_id: 77 }),
        expect.objectContaining({ transaction: mockTransaction })
      );
      // И только потом ферма узнаёт своего владельца.
      expect(farm.update).toHaveBeenCalledWith(
        { owner_id: 42 },
        expect.objectContaining({ transaction: mockTransaction })
      );
      expect(mockTransaction.commit).toHaveBeenCalled();
    });

    it('назначает новой ферме тариф по умолчанию, если он заведён', async () => {
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(null);
      planService.getDefault.mockResolvedValue({ id: 5, name: 'Бесплатный', is_default: true });

      const farm = { id: 78, update: jest.fn().mockResolvedValue(true) };
      Farm.create.mockResolvedValue(farm);
      User.create.mockResolvedValue(createMockUser({ id: 43, farm_id: 78 }));
      RefreshToken.create.mockResolvedValue({});

      await authService.register({
        email: 'another@example.com',
        password: 'password123',
        full_name: 'Ещё Фермер'
      });

      expect(Farm.create).toHaveBeenCalledWith(
        expect.objectContaining({ plan_id: 5 }),
        expect.objectContaining({ transaction: mockTransaction })
      );
    });

    it('не назначает план, если дефолтный тариф ещё не заведён', async () => {
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(null);
      planService.getDefault.mockResolvedValue(null);

      const farm = { id: 79, update: jest.fn().mockResolvedValue(true) };
      Farm.create.mockResolvedValue(farm);
      User.create.mockResolvedValue(createMockUser({ id: 44, farm_id: 79 }));
      RefreshToken.create.mockResolvedValue({});

      await authService.register({
        email: 'third@example.com',
        password: 'password123',
        full_name: 'Третий Фермер'
      });

      expect(Farm.create).toHaveBeenCalledWith(
        expect.objectContaining({ plan_id: null }),
        expect.objectContaining({ transaction: mockTransaction })
      );
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
