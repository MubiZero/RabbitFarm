/**
 * Tests for otpAuthService: resolveContact, requestOtp, verifyOtp
 *
 * Контакт — телефон или почта; оба канала ведут в один и тот же вход,
 * различаются только тем, куда уходит код.
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

jest.mock('../../../src/services/notifications/emailTransport', () => ({
  sendLoginCodeEmail: jest.fn().mockResolvedValue({}),
  sendAnnouncementEmail: jest.fn().mockResolvedValue({})
}));

const { User, Farm, Invitation, LoginOtp } = require('../../../src/models');
const authService = require('../../../src/services/authService');
const planService = require('../../../src/services/planService');
const payomSmsTransport = require('../../../src/services/notifications/payomSmsTransport');
const emailTransport = require('../../../src/services/notifications/emailTransport');
const otpAuthService = require('../../../src/services/otpAuthService');
const { hashOtp } = require('../../../src/utils/otp');

const PHONE = '+992901234567';
const EMAIL = 'ivan@farm.tj';
const CODE = '123456';
const CODE_HASH = hashOtp(CODE);

describe('OtpAuthService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    LoginOtp.count.mockResolvedValue(0);
    payomSmsTransport.sendTemplateSms.mockResolvedValue({});
    emailTransport.sendLoginCodeEmail.mockResolvedValue({});
  });

  // ─── resolveContact ────────────────────────────────────────────────────

  describe('resolveContact', () => {
    it('приводит номер в бытовом написании к каноничному +992', () => {
      expect(otpAuthService.resolveContact({ phone: '90 123 45 67' }))
        .toEqual({ identifier: PHONE, channel: 'phone' });
    });

    it('приводит почту к нижнему регистру и обрезает пробелы', () => {
      expect(otpAuthService.resolveContact({ email: '  Ivan@Farm.TJ ' }))
        .toEqual({ identifier: EMAIL, channel: 'email' });
    });

    it('бросает CONTACT_REQUIRED, если контакт не указан вовсе', () => {
      expect(() => otpAuthService.resolveContact({})).toThrow('CONTACT_REQUIRED');
      expect(() => otpAuthService.resolveContact()).toThrow('CONTACT_REQUIRED');
      expect(() => otpAuthService.resolveContact({ phone: '   ', email: '' })).toThrow('CONTACT_REQUIRED');
    });

    it('бросает CONTACT_REQUIRED, если переданы и телефон, и почта сразу', () => {
      expect(() => otpAuthService.resolveContact({ phone: PHONE, email: EMAIL }))
        .toThrow('CONTACT_REQUIRED');
    });

    it('бросает INVALID_PHONE на нетаджикский номер', () => {
      expect(() => otpAuthService.resolveContact({ phone: '+79991234567' })).toThrow('INVALID_PHONE');
    });

    it('бросает INVALID_EMAIL на почту без домена или с пробелом', () => {
      expect(() => otpAuthService.resolveContact({ email: 'ivan@farm' })).toThrow('INVALID_EMAIL');
      expect(() => otpAuthService.resolveContact({ email: 'ivan-farm.tj' })).toThrow('INVALID_EMAIL');
      expect(() => otpAuthService.resolveContact({ email: 'iv an@farm.tj' })).toThrow('INVALID_EMAIL');
    });
  });

  // ─── requestOtp ────────────────────────────────────────────────────────

  describe('requestOtp', () => {
    it('бросает INVALID_PHONE на нетаджикский номер', async () => {
      await expect(otpAuthService.requestOtp({ phone: '+79991234567' })).rejects.toThrow('INVALID_PHONE');
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('бросает INVALID_EMAIL на кривую почту', async () => {
      await expect(otpAuthService.requestOtp({ email: 'ivan@farm' })).rejects.toThrow('INVALID_EMAIL');
      expect(LoginOtp.create).not.toHaveBeenCalled();
      expect(emailTransport.sendLoginCodeEmail).not.toHaveBeenCalled();
    });

    it('бросает CONTACT_REQUIRED на пустой контакт и на «оба сразу»', async () => {
      await expect(otpAuthService.requestOtp({})).rejects.toThrow('CONTACT_REQUIRED');
      await expect(otpAuthService.requestOtp({ phone: PHONE, email: EMAIL })).rejects.toThrow('CONTACT_REQUIRED');
      expect(LoginOtp.count).not.toHaveBeenCalled();
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('принимает номер в бытовом написании (без +992) и приводит его к каноничному виду', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue(null);

      await otpAuthService.requestOtp({ phone: '901234567' });

      expect(User.findOne).toHaveBeenCalledWith({ where: { phone: PHONE } });
    });

    it('ищет пользователя по почте без учёта регистра: Ivan@Farm.TJ — это ivan@farm.tj', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue(null);

      await otpAuthService.requestOtp({ email: 'Ivan@Farm.TJ' });

      expect(User.findOne).toHaveBeenCalledWith({ where: { email: EMAIL } });
      expect(Invitation.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ email: EMAIL }) })
      );
    });

    it('отвечает успехом и не создаёт код для неизвестного номера (анти-энумерация)', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue(null);

      const result = await otpAuthService.requestOtp({ phone: PHONE });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
      expect(payomSmsTransport.sendTemplateSms).not.toHaveBeenCalled();
    });

    it('отвечает успехом и не создаёт код для неизвестной почты (анти-энумерация)', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue(null);

      const result = await otpAuthService.requestOtp({ email: EMAIL });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
      expect(emailTransport.sendLoginCodeEmail).not.toHaveBeenCalled();
    });

    it('отвечает успехом без создания кода, если аккаунт отключён', async () => {
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: false });

      const result = await otpAuthService.requestOtp({ phone: PHONE });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('создаёт код и шлёт SMS для существующего пользователя', async () => {
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: true });
      LoginOtp.create.mockResolvedValue({});

      const result = await otpAuthService.requestOtp({ phone: PHONE });

      expect(result).toEqual({ success: true });
      // Прежние коды не сносятся: по ним считается, сколько кодов запросили
      // за окно. Раньше снос обнулял счётчик, и лимит был недостижим.
      expect(LoginOtp.destroy).not.toHaveBeenCalled();
      expect(LoginOtp.create).toHaveBeenCalledWith(expect.objectContaining({
        identifier: PHONE,
        channel: 'phone',
        token_hash: expect.any(String),
        expires_at: expect.any(Date)
      }));
      expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalledWith(
        expect.objectContaining({ templateKey: 'user.verification_code', telephone: PHONE })
      );
      expect(emailTransport.sendLoginCodeEmail).not.toHaveBeenCalled();
      // Приглашение не смотрим, если пользователь уже найден.
      expect(Invitation.findOne).not.toHaveBeenCalled();
    });

    it('создаёт код с каналом email и шлёт письмо, а не SMS, если контакт — почта', async () => {
      User.findOne.mockResolvedValue({ id: 1, email: EMAIL, is_active: true });
      LoginOtp.destroy.mockResolvedValue(1);
      LoginOtp.create.mockResolvedValue({});

      const result = await otpAuthService.requestOtp({ email: EMAIL });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.destroy).not.toHaveBeenCalled();
      expect(LoginOtp.create).toHaveBeenCalledWith(expect.objectContaining({
        identifier: EMAIL,
        channel: 'email',
        token_hash: expect.any(String),
        expires_at: expect.any(Date)
      }));
      expect(emailTransport.sendLoginCodeEmail).toHaveBeenCalledWith({
        to: EMAIL,
        code: expect.stringMatching(/^\d{6}$/)
      });
      expect(payomSmsTransport.sendTemplateSms).not.toHaveBeenCalled();
    });

    it('шлёт в письме тот самый код, хэш которого сохранён в базе', async () => {
      User.findOne.mockResolvedValue({ id: 1, email: EMAIL, is_active: true });
      LoginOtp.destroy.mockResolvedValue(1);
      LoginOtp.create.mockResolvedValue({});

      await otpAuthService.requestOtp({ email: EMAIL });

      const { code } = emailTransport.sendLoginCodeEmail.mock.calls[0][0];
      const { token_hash: storedHash } = LoginOtp.create.mock.calls[0][0];
      expect(hashOtp(code)).toBe(storedHash);
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

      const result = await otpAuthService.requestOtp({ phone: PHONE });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).toHaveBeenCalled();
      expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalled();
    });

    it('создаёт код для почты с активным приглашением, если пользователя ещё нет', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue({
        id: 7,
        email: EMAIL,
        expires_at: new Date(Date.now() + 60_000)
      });
      LoginOtp.destroy.mockResolvedValue(0);
      LoginOtp.create.mockResolvedValue({});

      const result = await otpAuthService.requestOtp({ email: EMAIL });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).toHaveBeenCalledWith(expect.objectContaining({ channel: 'email' }));
      expect(emailTransport.sendLoginCodeEmail).toHaveBeenCalled();
    });

    it('не создаёт код для просроченного приглашения', async () => {
      User.findOne.mockResolvedValue(null);
      Invitation.findOne.mockResolvedValue({
        id: 7,
        phone: PHONE,
        expires_at: new Date(Date.now() - 60_000)
      });

      const result = await otpAuthService.requestOtp({ phone: PHONE });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).not.toHaveBeenCalled();
    });

    it('не должен падать, если SMS-шлюз недоступен — код всё равно создан', async () => {
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: true });
      LoginOtp.destroy.mockResolvedValue(1);
      LoginOtp.create.mockResolvedValue({});
      payomSmsTransport.sendTemplateSms.mockRejectedValueOnce(new Error('SMS_NOT_CONFIGURED'));

      const result = await otpAuthService.requestOtp({ phone: PHONE });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).toHaveBeenCalled();
    });

    it('не должен падать, если почта не настроена — код всё равно создан', async () => {
      User.findOne.mockResolvedValue({ id: 1, email: EMAIL, is_active: true });
      LoginOtp.destroy.mockResolvedValue(1);
      LoginOtp.create.mockResolvedValue({});
      emailTransport.sendLoginCodeEmail.mockRejectedValueOnce(new Error('EMAIL_NOT_CONFIGURED'));

      const result = await otpAuthService.requestOtp({ email: EMAIL });

      expect(result).toEqual({ success: true });
      expect(LoginOtp.create).toHaveBeenCalled();
    });

    it('бросает OTP_RATE_LIMITED при частых запросах на один номер', async () => {
      LoginOtp.count.mockResolvedValue(3);

      await expect(otpAuthService.requestOtp({ phone: PHONE })).rejects.toThrow('OTP_RATE_LIMITED');
      expect(User.findOne).not.toHaveBeenCalled();
    });

    it('считает лимит по нормализованному контакту, а не по тому, как его набрали', async () => {
      LoginOtp.count.mockResolvedValue(3);

      await expect(otpAuthService.requestOtp({ email: 'Ivan@Farm.TJ' })).rejects.toThrow('OTP_RATE_LIMITED');
      expect(LoginOtp.count).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ identifier: EMAIL }) })
      );
      expect(emailTransport.sendLoginCodeEmail).not.toHaveBeenCalled();
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

    it('бросает CONTACT_REQUIRED, если контакт не указан', async () => {
      await expect(otpAuthService.verifyOtp({}, CODE)).rejects.toThrow('CONTACT_REQUIRED');
      expect(LoginOtp.findOne).not.toHaveBeenCalled();
    });

    it('бросает OTP_INVALID, если кода на номер нет', async () => {
      LoginOtp.findOne.mockResolvedValue(null);

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('OTP_INVALID');
      expect(LoginOtp.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { identifier: PHONE } })
      );
    });

    it('ищет код по нормализованной почте', async () => {
      LoginOtp.findOne.mockResolvedValue(null);

      await expect(otpAuthService.verifyOtp({ email: 'Ivan@Farm.TJ' }, CODE)).rejects.toThrow('OTP_INVALID');
      expect(LoginOtp.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { identifier: EMAIL } })
      );
    });

    it('бросает OTP_LOCKED и удаляет запись после превышения попыток', async () => {
      const record = makeRecord({ attempts: 5 });
      LoginOtp.findOne.mockResolvedValue(record);

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('OTP_LOCKED');
      expect(record.destroy).toHaveBeenCalled();
    });

    it('бросает OTP_EXPIRED и удаляет запись после истечения TTL', async () => {
      const record = makeRecord({ expires_at: new Date(Date.now() - 1000) });
      LoginOtp.findOne.mockResolvedValue(record);

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('OTP_EXPIRED');
      expect(record.destroy).toHaveBeenCalled();
    });

    it('неверный код увеличивает счётчик попыток, не удаляя запись', async () => {
      const record = makeRecord();
      LoginOtp.findOne.mockResolvedValue(record);

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, '000000')).rejects.toThrow('OTP_INVALID');
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

      const result = await otpAuthService.verifyOtp({ phone: PHONE }, CODE);

      expect(record.destroy).toHaveBeenCalled();
      expect(User.findOne).toHaveBeenCalledWith(expect.objectContaining({ where: { phone: PHONE } }));
      expect(mockUser.update).toHaveBeenCalledWith(expect.objectContaining({ last_login_at: expect.any(Date) }));
      expect(authService.issueTokens).toHaveBeenCalledWith(mockUser);
      expect(result).toEqual({ user: { id: 1, phone: PHONE }, access_token: 'a', refresh_token: 'b' });
    });

    it('входит в существующий аккаунт по коду, присланному на почту', async () => {
      const record = makeRecord();
      LoginOtp.findOne.mockResolvedValue(record);
      const mockUser = {
        id: 1, email: EMAIL, is_active: true,
        update: jest.fn().mockResolvedValue(true),
        toJSON: function() { return { id: this.id, email: this.email }; }
      };
      User.findOne.mockResolvedValue(mockUser);
      authService.issueTokens.mockResolvedValue({ access_token: 'a', refresh_token: 'b' });

      const result = await otpAuthService.verifyOtp({ email: 'Ivan@Farm.TJ' }, CODE);

      expect(User.findOne).toHaveBeenCalledWith(expect.objectContaining({ where: { email: EMAIL } }));
      expect(result).toEqual({ user: { id: 1, email: EMAIL }, access_token: 'a', refresh_token: 'b' });
    });

    it('бросает USER_INACTIVE для отключённого аккаунта', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValue({ id: 1, phone: PHONE, is_active: false });

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('USER_INACTIVE');
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

      const result = await otpAuthService.verifyOtp({ phone: PHONE }, CODE);

      expect(planService.assertStaffLimit).toHaveBeenCalledWith(42);
      expect(User.create).toHaveBeenCalledWith(expect.objectContaining({
        phone: PHONE, full_name: 'Новый Работник', role: 'worker', farm_id: 42
      }));
      expect(invitation.update).toHaveBeenCalledWith(expect.objectContaining({ accepted_at: expect.any(Date) }));
      expect(result.user.farm).toEqual({ id: 42, status: 'active' });
      expect(authService.issueTokens).toHaveBeenCalledWith(createdUser);
    });

    it('активирует приглашение, выписанное на почту, и заводит работника с этим email', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null);
      const invitation = {
        id: 11,
        email: EMAIL,
        farm_id: 42,
        role: 'worker',
        full_name: 'Новая Работница',
        expires_at: new Date(Date.now() + 60_000),
        update: jest.fn().mockResolvedValue(true)
      };
      Invitation.findOne.mockResolvedValue(invitation);
      const createdUser = {
        id: 3, email: EMAIL, role: 'worker', farm_id: 42,
        toJSON: function() { return { id: this.id, email: this.email, role: this.role, farm_id: this.farm_id }; }
      };
      User.create.mockResolvedValue(createdUser);
      Farm.findByPk.mockResolvedValue({ id: 42, status: 'active' });
      authService.issueTokens.mockResolvedValue({ access_token: 'a', refresh_token: 'b' });

      const result = await otpAuthService.verifyOtp({ email: 'Ivan@Farm.TJ' }, CODE);

      expect(Invitation.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ email: EMAIL, accepted_at: null }) })
      );
      expect(User.create).toHaveBeenCalledWith(expect.objectContaining({
        email: EMAIL, full_name: 'Новая Работница', role: 'worker', farm_id: 42
      }));
      // Телефон приглашением не задан — в пользователя он попасть не должен.
      expect(User.create.mock.calls[0][0]).not.toHaveProperty('phone');
      expect(invitation.update).toHaveBeenCalledWith(expect.objectContaining({ accepted_at: expect.any(Date) }));
      expect(result.user).toEqual(expect.objectContaining({ id: 3, email: EMAIL }));
      expect(result.user.farm).toEqual({ id: 42, status: 'active' });
    });

    it('не заводит работника сверх лимита тарифа', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null);
      Invitation.findOne.mockResolvedValue({
        id: 9, phone: PHONE, farm_id: 42, role: 'worker', full_name: 'Новый Работник',
        expires_at: new Date(Date.now() + 60_000),
        update: jest.fn()
      });
      planService.assertStaffLimit.mockRejectedValueOnce(new Error('STAFF_LIMIT_REACHED'));

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('STAFF_LIMIT_REACHED');
      expect(User.create).not.toHaveBeenCalled();
    });

    it('бросает OTP_INVALID, если приглашение исчезло между запросом кода и его вводом', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null);
      Invitation.findOne.mockResolvedValue(null);

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('OTP_INVALID');
      expect(User.create).not.toHaveBeenCalled();
    });

    it('бросает OTP_INVALID, если приглашение успело просрочиться', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null);
      Invitation.findOne.mockResolvedValue({
        id: 9, phone: PHONE, farm_id: 42, role: 'worker',
        expires_at: new Date(Date.now() - 60_000),
        update: jest.fn()
      });

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('OTP_INVALID');
      expect(planService.assertStaffLimit).not.toHaveBeenCalled();
      expect(User.create).not.toHaveBeenCalled();
    });

    it('бросает OTP_INVALID, если пользователя с этим контактом успели завести параллельно', async () => {
      LoginOtp.findOne.mockResolvedValue(makeRecord());
      User.findOne.mockResolvedValueOnce(null);
      Invitation.findOne.mockResolvedValue({
        id: 9, phone: PHONE, farm_id: 42, role: 'worker', full_name: 'Новый Работник',
        expires_at: new Date(Date.now() + 60_000),
        update: jest.fn()
      });
      const conflict = new Error('duplicate');
      conflict.name = 'SequelizeUniqueConstraintError';
      User.create.mockRejectedValueOnce(conflict);

      await expect(otpAuthService.verifyOtp({ phone: PHONE }, CODE)).rejects.toThrow('OTP_INVALID');
    });
  });
});
