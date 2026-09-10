/**
 * Tests for otpAuthService: requestOtp, verifyOtp
 */
jest.mock('../../../src/models', () => ({
  User: {
    findOne: jest.fn(),
    create: jest.fn()
  },
  Farm: {
    findByPk: jest.fn()
  },
  Invitation: {
    findOne: jest.fn(),
    update: jest.fn()
  },
  LoginOtp: {
    count: jest.fn().mockResolvedValue(0),
    create: jest.fn(),
    destroy: jest.fn(),
    findOne: jest.fn()
  }
}));

jest.mock('../../../src/services/authService', () => ({
  issueTokens: jest.fn()
}));

jest.mock('../../../src/services/planService', () => ({
  assertStaffLimit: jest.fn().mockResolvedValue(undefined)
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn(), debug: jest.fn()
}));

jest.mock('../../../src/services/notifications/payomSmsTransport', () => ({
  sendTemplateSms: jest.fn().mockResolvedValue({})
}));

const { User, Farm, Invitation, LoginOtp } = require('../../../src/models');
const authService = require('../../../src/services/authService');
const planService = require('../../../src/services/planService');
const payomSmsTransport = require('../../../src/services/notifications/payomSmsTransport');
const otpAuthService = require('../../../src/services/otpAuthService');
const { hashOtp } = require('../../../src/utils/otp');

const PHONE = '+992901234567';
const CODE = '123456';
const CODE_HASH = hashOtp(CODE);

describe('OtpAuthService', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── requestOtp ────────────────────────────────────────────────────────

  describe('requestOtp', () => {
    it('бросает INVALID_PHONE на нетаджикский номер', async () => {
      await expect(otpAuthService.requestOtp('+79991234567')).rejects.toThrow('INVALID_PHONE');
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('принимает номер в бытовом написании (без +992) и приводит его к каноничному виду', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue(null);

      await otpAuthService.requestOtp('901234567');

      expect(User.findOne).toHaveBeenCalledWith({ where: { phone: PHONE } });
    });

    it('отвечает успехом и не создаёт код для неизвестного номера (анти-энумерация)', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue(null);

      const result = await otpAuthService.requestOtp(PHONE);

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
      expect(payomSmsTransport.sendTemplateSms).not.toHaveBeenCalled();
    });

    it('отвечает успехом без создания кода, если аккаунт отключён', async () => {
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: false });

      const result = await otpAuthService.requestOtp(PHONE);

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('создаёт код и шлёт SMS для существующего пользователя', async () => {
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: true });
      LoginOtp.destroy.mockResolvedValue(1);
      LoginOtp.create.mockResolvedValue({});

      const result = await otpAuthService.requestOtp(PHONE);

      expect(result).toEqual({ success: true });
      expect(LoginOtp.destroy).toHaveBeenCalledWith({ where: { phone: PHONE } });
      expect(LoginOtp.create).toHaveBeenCalledWith(expect.objectContaining({ phone: PHONE }));
      expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalledWith(
        expect.objectContaining({ templateKey: 'user.verification_code', telephone: PHONE })
      );
      // Приглашение не смотрим, если пользователь уже найден.
      expect(Invitation.findOne).not.toHaveBeenCalled();
    });

    it('создаёт код для номера с активным приглашением, если пользователя ещё нет', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue({
        id: 7,
        phone: PHONE,
        expires_at: new Date(Date.now() + 60_000)
      });
      LoginOtp.destroy.mockResolvedValue(0);
      LoginOtp.create.mockResolvedValue({});

      const result = await otpAuthService.requestOtp(PHONE);

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).toHaveBeenCalled();
      expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalled();
    });

    it('не создаёт код для просроченного приглашения', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue({
        id: 7,
        phone: PHONE,
        expires_at: new Date(Date.now() - 60_000)
      });

      const result = await otpAuthService.requestOtp(PHONE);

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('не должен падать, если SMS-шлюз недоступен — код всё равно создан', async () => {
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: true });
      LoginOtp.destroy.mockResolvedValue(1);
      LoginOtp.create.mockResolvedValue({});
      payomSmsTransport.sendTemplateSms.mockRejectedValueOnce(new Error('SMS_NOT_CONFIGURED'));

      const result = await otpAuthService.requestOtp(PHONE);

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).toHaveBeenCalled();
    });

    it('бросает OTP_RATE_LIMITED при частых запросах на один номер', async () => {
      LoginOtp.count.mockResolvedValue(3);

      await expect(otpAuthService.requestOtp(PHONE)).rejects.toThrow('OTP_RATE_LIMITED');
      expect(User.findOne).not.toHaveBeenCalled();
    });
  });

  // ─── verifyOtp ─────────────────────────────────────────────────────────

  describe('verifyOtp', () => {
    const makeRecord = (overrides = {}) => ({
      token_hash: CODE_HASH,
      attempts: 0,
      expires_at: new Date(Date.now() + 10 * 60 * 1000),
      destroy: jest.fn().mockResolvedValue(true),
      increment: jest.fn().mockResolvedValue(true),
      ...overrides
    });

    it('бросает OTP_INVALID, если кода на номер нет', async () => {
      LoginOtp.findOne.mockResolvedValue(null);

      await expect(otpAuthService.verifyOtp(PHONE, CODE)).rejects.toThrow('OTP_INVALID');
    });

    it('бросает OTP_LOCKED и удаляет запись после превышения попыток', async () => {
      const record = makeRecord({ attempts: 5 });
      LoginOtp.findOne.mockResolvedValue(record);

      await expect(otpAuthService.verifyOtp(PHONE, CODE)).rejects.toThrow('OTP_LOCKED');
      expect(record.destroy).toHaveBeenCalled();
    });

    it('бросает OTP_EXPIRED и удаляет запись после истечения TTL', async () => {
      const record = makeRecord({ expires_at: new Date(Date.now() - 1000) });
      LoginOtp.findOne.mockResolvedValue(record);

      await expect(otpAuthService.verifyOtp(PHONE, CODE)).rejects.toThrow('OTP_EXPIRED');
      expect(record.destroy).toHaveBeenCalled();
    });

    it('неверный код увеличивает счётчик попыток, не удаляя запись', async () => {
      const record = makeRecord();
      LoginOtp.findOne.mockResolvedValue(record);

      await expect(otpAuthService.verifyOtp(PHONE, '000000')).rejects.toThrow('OTP_INVALID');
      expect(record.increment).toHaveBeenCalledWith('attempts');
      expect(record.destroy).not.toHaveBeenCalled();
    });

    it('входит в существующий аккаунт по верному коду', async () => {
      const record = makeRecord();
      LoginOtp.findOne.mockResolvedValue(record);
      const mockUser = {
        id: 1, phone: PHONE, is_active: true,
        update: jest.fn().mockResolvedValue(true),
        toJSON: function() { return { id: this.id, phone: this.phone }; }
      };
      User.findOne.mockResolvedValue(mockUser);
      authService.issueTokens.mockResolvedValue({ access_token: 'a', refresh_token: 'b' });

      const result = await otpAuthService.verifyOtp(PHONE, CODE);

      expect(record.destroy).toHaveBeenCalled();
      expect(mockUser.update).toHaveBeenCalledWith(expect.objectContaining({ last_login_at: expect.any(Date) }));
      expect(authService.issueTokens).toHaveBeenCalledWith(mockUser);
      expect(result).toEqual({ user: { id: 1, phone: PHONE }, access_token: 'a', refresh_token: 'b' });
    });

    it('бросает USER_INACTIVE для отключённого аккаунта', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: false });

      await expect(otpAuthService.verifyOtp(PHONE, CODE)).rejects.toThrow('USER_INACTIVE');
      expect(authService.issueTokens).not.toHaveBeenCalled();
    });

    it('активирует приглашение и заводит работника на лету', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null); // нет существующего пользователя с этим телефоном
      const invitation = {
        id: 9,
        phone: PHONE,
        farm_id: 42,
        role: 'worker',
        full_name: 'Новый Работник',
        expires_at: new Date(Date.now() + 60_000),
        update: jest.fn().mockResolvedValue(true)
      };
      Invitation.findOne.mockResolvedValue(invitation);
      const createdUser = {
        id: 2, phone: PHONE, role: 'worker', farm_id: 42,
        toJSON: function() { return { id: this.id, phone: this.phone, role: this.role, farm_id: this.farm_id }; }
      };
      User.create.mockResolvedValue(createdUser);
      Farm.findByPk.mockResolvedValue({ id: 42, status: 'active' });
      authService.issueTokens.mockResolvedValue({ access_token: 'a', refresh_token: 'b' });

      const result = await otpAuthService.verifyOtp(PHONE, CODE);

      expect(planService.assertStaffLimit).toHaveBeenCalledWith(42);
      expect(User.create).toHaveBeenCalledWith(expect.objectContaining({
        phone: PHONE, full_name: 'Новый Работник', role: 'worker', farm_id: 42
      }));
      expect(invitation.update).toHaveBeenCalledWith(expect.objectContaining({ accepted_at: expect.any(Date) }));
      expect(result.user.farm).toEqual({ id: 42, status: 'active' });
      expect(authService.issueTokens).toHaveBeenCalledWith(createdUser);
    });

    it('бросает OTP_INVALID, если приглашение исчезло между запросом кода и его вводом', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null);
      Invitation.findOne.mockResolvedValue(null);

      await expect(otpAuthService.verifyOtp(PHONE, CODE)).rejects.toThrow('OTP_INVALID');
      expect(User.create).not.toHaveBeenCalled();
    });
  });
});
