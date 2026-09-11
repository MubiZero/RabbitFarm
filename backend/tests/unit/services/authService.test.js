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
jest.mock('../../../src/services/otpAuthService', () => ({
  requestOtp: jest.fn().mockResolvedValue({ success: true })
}));

const { Farm, User, RefreshToken } = require('../../../src/models');
const planService = require('../../../src/services/planService');
const otpAuthService = require('../../../src/services/otpAuthService');
const authService = require('../../../src/services/authService');
const { createMockUser } = require('../../helpers/mockModels');

describe('AuthService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    // По умолчанию дефолтного тарифа нет — как до появления п. 1.2.
    planService.getDefault.mockResolvedValue(null);
    otpAuthService.requestOtp.mockResolvedValue({ success: true });
  });

  describe('register', () => {
    // Успешная регистрация: ферма + владелец + запрос кода. Собран один раз,
    // чтобы каждый тест поднимал только то, что проверяет.
    const arrangeSuccess = ({ farmId = 77, userId = 42 } = {}) => {
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(null);

      const farm = { id: farmId, update: jest.fn().mockResolvedValue(true) };
      Farm.create.mockResolvedValue(farm);
      User.create.mockResolvedValue(createMockUser({ id: userId, farm_id: farmId }));

      return { mockTransaction, farm };
    };

    it('должен бросать USER_EXISTS если email занят', async () => {
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(createMockUser());

      await expect(authService.register({
        email: 'test@example.com',
        full_name: 'Test User'
      })).rejects.toThrow('USER_EXISTS');

      expect(mockTransaction.rollback).toHaveBeenCalled();
      expect(Farm.create).not.toHaveBeenCalled();
      expect(otpAuthService.requestOtp).not.toHaveBeenCalled();
    });

    // Телефон — он же логин, и он глобально уникален: занятый номер должен
    // отбиваться раньше, чем появится вторая ферма на тот же контакт.
    it('должен бросать PHONE_EXISTS если телефон занят', async () => {
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);
      User.findOne.mockResolvedValue(createMockUser({ phone: '+992186663333' }));

      await expect(authService.register({
        phone: '+992186663333',
        full_name: 'Test User'
      })).rejects.toThrow('PHONE_EXISTS');

      expect(mockTransaction.rollback).toHaveBeenCalled();
      expect(Farm.create).not.toHaveBeenCalled();
      expect(otpAuthService.requestOtp).not.toHaveBeenCalled();
    });

    it('должен бросать REGISTRATION_CLOSED если публичная регистрация выключена', async () => {
      const previous = process.env.ALLOW_REGISTRATION;
      process.env.ALLOW_REGISTRATION = 'false';
      const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };
      User.sequelize.transaction.mockResolvedValue(mockTransaction);

      try {
        await expect(authService.register({
          phone: '+992186663333',
          full_name: 'Посторонний'
        })).rejects.toThrow('REGISTRATION_CLOSED');

        expect(mockTransaction.rollback).toHaveBeenCalled();
        expect(User.findOne).not.toHaveBeenCalled();
        expect(Farm.create).not.toHaveBeenCalled();
      } finally {
        if (previous === undefined) {
          delete process.env.ALLOW_REGISTRATION;
        } else {
          process.env.ALLOW_REGISTRATION = previous;
        }
      }
    });

    it('заводит ферму и делает регистрирующегося её владельцем', async () => {
      const { mockTransaction, farm } = arrangeSuccess();

      await authService.register({
        email: 'new@example.com',
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

    // Пароля в сервисе больше нет: даже если клиент пришлёт поле `password`,
    // оно не должно ни храниться, ни превращаться в хеш.
    it('не сохраняет пароль и не заводит хеш, даже если его прислали', async () => {
      arrangeSuccess();

      await authService.register({
        email: 'new@example.com',
        full_name: 'Новый Фермер',
        password: 'password123'
      });

      const [createdUser] = User.create.mock.calls[0];
      expect(createdUser).not.toHaveProperty('password');
      expect(createdUser).not.toHaveProperty('password_hash');
    });

    // Регистрация не открывает сессию: подтвердить контакт можно только
    // кодом, поэтому токенов в ответе нет и refresh в БД не появляется.
    it('не выдаёт токены — отвечает только user_id, farm_id и каналом', async () => {
      arrangeSuccess({ farmId: 77, userId: 42 });

      const result = await authService.register({
        email: 'new@example.com',
        full_name: 'Новый Фермер'
      });

      expect(result).toEqual({ user_id: 42, farm_id: 77, channel: 'email' });
      expect(result).not.toHaveProperty('access_token');
      expect(result).not.toHaveProperty('refresh_token');
      expect(RefreshToken.create).not.toHaveBeenCalled();
    });

    it('шлёт код на телефон и отвечает channel=phone, если регистрируются по номеру', async () => {
      arrangeSuccess({ farmId: 90, userId: 50 });

      const result = await authService.register({
        phone: '+992186663333',
        full_name: 'Телефонный Фермер'
      });

      expect(otpAuthService.requestOtp).toHaveBeenCalledWith({ phone: '+992186663333' });
      expect(result.channel).toBe('phone');
    });

    it('шлёт код на почту и отвечает channel=email, если телефона нет', async () => {
      arrangeSuccess({ farmId: 91, userId: 51 });

      const result = await authService.register({
        email: 'mail-only@example.com',
        full_name: 'Почтовый Фермер'
      });

      expect(otpAuthService.requestOtp).toHaveBeenCalledWith({ email: 'mail-only@example.com' });
      expect(result.channel).toBe('email');
    });

    // Код ищет уже существующего пользователя, поэтому уходит только после
    // коммита — внутри транзакции его ещё не видно.
    it('запрашивает код после коммита транзакции', async () => {
      const { mockTransaction } = arrangeSuccess();
      const order = [];
      mockTransaction.commit.mockImplementation(() => { order.push('commit'); });
      otpAuthService.requestOtp.mockImplementation(() => {
        order.push('requestOtp');
        return Promise.resolve({ success: true });
      });

      await authService.register({
        phone: '+992186664444',
        full_name: 'Новый Фермер'
      });

      expect(order).toEqual(['commit', 'requestOtp']);
    });

    it('назначает новой ферме тариф по умолчанию, если он заведён', async () => {
      const { mockTransaction } = arrangeSuccess({ farmId: 78, userId: 43 });
      planService.getDefault.mockResolvedValue({ id: 5, name: 'Бесплатный', is_default: true });

      await authService.register({
        email: 'another@example.com',
        full_name: 'Ещё Фермер'
      });

      expect(Farm.create).toHaveBeenCalledWith(
        expect.objectContaining({ plan_id: 5 }),
        expect.objectContaining({ transaction: mockTransaction })
      );
    });

    it('не назначает план, если дефолтный тариф ещё не заведён', async () => {
      const { mockTransaction } = arrangeSuccess({ farmId: 79, userId: 44 });
      planService.getDefault.mockResolvedValue(null);

      await authService.register({
        email: 'third@example.com',
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
        include: [{ model: Farm, as: 'farm', attributes: ['id', 'status'] }]
      }));
    });

    it('должен бросать USER_NOT_FOUND если пользователь не существует', async () => {
      User.findByPk.mockResolvedValue(null);
      await expect(authService.getProfile(999)).rejects.toThrow('USER_NOT_FOUND');
    });
  });
});
