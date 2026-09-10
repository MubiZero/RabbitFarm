/**
 * Tests for authService: forgotPassword, resetPassword, cleanExpiredTokens, logout error path
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

jest.mock('../../../src/services/notifications/payomSmsTransport', () => ({
  sendTemplateSms: jest.fn().mockResolvedValue({})
}));

jest.mock('../../../src/services/notifications/emailTransport', () => ({
  sendPasswordResetEmail: jest.fn().mockResolvedValue({})
}));

const { User, RefreshToken, PasswordResetToken } = require('../../../src/models');
const payomSmsTransport = require('../../../src/services/notifications/payomSmsTransport');
const emailTransport = require('../../../src/services/notifications/emailTransport');
const authService = require('../../../src/services/authService');

describe('AuthService — password reset & token cleanup', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── forgotPassword ──────────────────────────────────────────────────────

  describe('forgotPassword', () => {
    it('должен создать код и отправить его по SMS, если есть телефон', async () => {
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', phone: '+992186663333', is_active: true });
      PasswordResetToken.destroy.mockResolvedValue(1);
      PasswordResetToken.create.mockResolvedValue({});

      const result = await authService.forgotPassword('user@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.destroy).toHaveBeenCalledWith({ where: { user_id: 1 } });
      expect(PasswordResetToken.create).toHaveBeenCalledWith(
        expect.objectContaining({ user_id: 1, channel: 'sms' })
      );
      expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalledWith(
        expect.objectContaining({ templateKey: 'user.verification_code', telephone: '+992186663333' })
      );
      expect(emailTransport.sendPasswordResetEmail).not.toHaveBeenCalled();
    });

    it('должен отправить код по email, если телефон не в таджикском формате (шлюз SMS его бы отклонил)', async () => {
      User.findOne.mockResolvedValue({ id: 5, email: 'ru-phone@example.com', phone: '+79991234567', is_active: true });
      PasswordResetToken.destroy.mockResolvedValue(1);
      PasswordResetToken.create.mockResolvedValue({});

      const result = await authService.forgotPassword('ru-phone@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.create).toHaveBeenCalledWith(
        expect.objectContaining({ user_id: 5, channel: 'email' })
      );
      expect(emailTransport.sendPasswordResetEmail).toHaveBeenCalledWith(
        expect.objectContaining({ to: 'ru-phone@example.com' })
      );
      expect(payomSmsTransport.sendTemplateSms).not.toHaveBeenCalled();
    });

    it('должен отправить код по email, если телефона нет', async () => {
      User.findOne.mockResolvedValue({ id: 3, email: 'nophone@example.com', phone: null, is_active: true });
      PasswordResetToken.destroy.mockResolvedValue(1);
      PasswordResetToken.create.mockResolvedValue({});

      const result = await authService.forgotPassword('nophone@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.create).toHaveBeenCalledWith(
        expect.objectContaining({ user_id: 3, channel: 'email' })
      );
      expect(emailTransport.sendPasswordResetEmail).toHaveBeenCalledWith(
        expect.objectContaining({ to: 'nophone@example.com' })
      );
      expect(payomSmsTransport.sendTemplateSms).not.toHaveBeenCalled();
    });

    it('не должен падать, если транспорт недоступен — код всё равно создан', async () => {
      User.findOne.mockResolvedValue({ id: 4, email: 'user2@example.com', phone: '+992186663333', is_active: true });
      PasswordResetToken.destroy.mockResolvedValue(1);
      PasswordResetToken.create.mockResolvedValue({});
      payomSmsTransport.sendTemplateSms.mockRejectedValueOnce(new Error('SMS_NOT_CONFIGURED'));

      const result = await authService.forgotPassword('user2@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.create).toHaveBeenCalled();
    });

    it('должен возвращать success без создания кода, если пользователь не найден (защита от enumeration)', async () => {
      User.findOne.mockResolvedValue(null);

      const result = await authService.forgotPassword('ghost@example.com');

      expect(result).toEqual({ success: true });
      expect(PasswordResetToken.create).not.toHaveBeenCalled();
    });

    it('должен возвращать success без создания кода, если пользователь неактивен', async () => {
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

    // hashOtp('123456') — совпадает с захардкоженным token_hash в моках ниже.
    const CODE = '123456';
    const CODE_HASH = require('../../../src/utils/otp').hashOtp(CODE);

    it('должен сменить пароль по валидному коду', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', is_active: true, token_version: 0 });

      const mockRecord = {
        token_hash: CODE_HASH,
        attempts: 0,
        expires_at: new Date(Date.now() + 15 * 60 * 1000),
        destroy: jest.fn().mockResolvedValue(true),
        increment: jest.fn().mockResolvedValue(true)
      };
      PasswordResetToken.findOne.mockResolvedValue(mockRecord);
      User.update.mockResolvedValue([1]);
      RefreshToken.destroy.mockResolvedValue(1);

      const result = await authService.resetPassword({ email: 'user@example.com', code: CODE, newPassword: 'NewPassword123!' });

      expect(result).toEqual({ success: true });
      expect(User.update).toHaveBeenCalled();
      expect(mockRecord.destroy).toHaveBeenCalled();
      expect(tx.commit).toHaveBeenCalled();
    });

    it('должен бросать INVALID_RESET_CODE если пользователь не найден', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue(null);

      await expect(authService.resetPassword({ email: 'ghost@example.com', code: CODE, newPassword: 'NewPassword123!' }))
        .rejects.toThrow('INVALID_RESET_CODE');
      expect(tx.rollback).toHaveBeenCalled();
    });

    it('должен бросать INVALID_RESET_CODE если код не найден', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', is_active: true });
      PasswordResetToken.findOne.mockResolvedValue(null);

      await expect(authService.resetPassword({ email: 'user@example.com', code: CODE, newPassword: 'NewPassword123!' }))
        .rejects.toThrow('INVALID_RESET_CODE');
      expect(tx.rollback).toHaveBeenCalled();
    });

    it('должен инкрементировать attempts при неверном коде', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', is_active: true });

      const record = {
        token_hash: CODE_HASH,
        attempts: 0,
        expires_at: new Date(Date.now() + 15 * 60 * 1000),
        destroy: jest.fn(),
        increment: jest.fn().mockResolvedValue(true)
      };
      PasswordResetToken.findOne.mockResolvedValue(record);

      await expect(authService.resetPassword({ email: 'user@example.com', code: '000000', newPassword: 'NewPassword123!' }))
        .rejects.toThrow('INVALID_RESET_CODE');
      expect(record.increment).toHaveBeenCalledWith('attempts');
      expect(record.destroy).not.toHaveBeenCalled();
    });

    it('должен бросать RESET_CODE_LOCKED после превышения числа попыток', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', is_active: true });

      const record = {
        token_hash: CODE_HASH,
        attempts: 5,
        expires_at: new Date(Date.now() + 15 * 60 * 1000),
        destroy: jest.fn().mockResolvedValue(true),
        increment: jest.fn()
      };
      PasswordResetToken.findOne.mockResolvedValue(record);

      await expect(authService.resetPassword({ email: 'user@example.com', code: CODE, newPassword: 'NewPassword123!' }))
        .rejects.toThrow('RESET_CODE_LOCKED');
      expect(record.destroy).toHaveBeenCalled();
    });

    it('должен бросать RESET_CODE_EXPIRED если код просрочен', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue({ id: 1, email: 'user@example.com', is_active: true });

      const expiredRecord = {
        token_hash: CODE_HASH,
        attempts: 0,
        expires_at: new Date(Date.now() - 1000),
        destroy: jest.fn().mockResolvedValue(true),
        increment: jest.fn()
      };
      PasswordResetToken.findOne.mockResolvedValue(expiredRecord);

      await expect(authService.resetPassword({ email: 'user@example.com', code: CODE, newPassword: 'NewPassword123!' }))
        .rejects.toThrow('RESET_CODE_EXPIRED');
      expect(expiredRecord.destroy).toHaveBeenCalled();
      expect(tx.rollback).toHaveBeenCalled();
    });

    it('должен бросать USER_INACTIVE если пользователь неактивен', async () => {
      const tx = makeTransaction();
      User.sequelize.transaction.mockResolvedValue(tx);
      User.findOne.mockResolvedValue({ id: 2, email: 'inactive@example.com', is_active: false });

      const record = {
        token_hash: CODE_HASH,
        attempts: 0,
        expires_at: new Date(Date.now() + 15 * 60 * 1000),
        destroy: jest.fn(),
        increment: jest.fn()
      };
      PasswordResetToken.findOne.mockResolvedValue(record);

      await expect(authService.resetPassword({ email: 'inactive@example.com', code: CODE, newPassword: 'NewPassword123!' }))
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
