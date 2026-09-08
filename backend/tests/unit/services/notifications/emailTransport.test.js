jest.mock('../../../../src/config/mailer', () => ({
  host: 'mail.test',
  port: 587,
  useStartTls: true,
  username: 'no-reply@test',
  password: 'secret',
  fromAddress: 'no-reply@test',
  fromName: 'RabbitFarm',
  isConfigured: true
}));
jest.mock('../../../../src/utils/logger', () => ({
  info: jest.fn(), warn: jest.fn(), error: jest.fn()
}));

const mockSendMail = jest.fn();
jest.mock('nodemailer', () => ({
  createTransport: jest.fn(() => ({ sendMail: mockSendMail }))
}));

const nodemailer = require('nodemailer');
const config = require('../../../../src/config/mailer');
const {
  sendPasswordResetEmail,
  sendAnnouncementEmail
} = require('../../../../src/services/notifications/emailTransport');

describe('emailTransport', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('sendPasswordResetEmail', () => {
    it('бросает permanent-ошибку и не трогает nodemailer, если не настроено', async () => {
      config.isConfigured = false;

      await expect(sendPasswordResetEmail({ to: 'user@example.com', code: '123456' }))
        .rejects.toMatchObject({ message: 'EMAIL_NOT_CONFIGURED', permanent: true });
      expect(nodemailer.createTransport).not.toHaveBeenCalled();

      config.isConfigured = true;
    });

    it('отправляет письмо с кодом через SMTP-транспорт из конфига', async () => {
      mockSendMail.mockResolvedValue({ messageId: 'abc' });

      const result = await sendPasswordResetEmail({ to: 'user@example.com', code: '123456' });

      expect(nodemailer.createTransport).toHaveBeenCalledWith(
        expect.objectContaining({ host: 'mail.test', port: 587, requireTLS: true })
      );
      expect(mockSendMail).toHaveBeenCalledWith(
        expect.objectContaining({
          from: '"RabbitFarm" <no-reply@test>',
          to: 'user@example.com',
          text: expect.stringContaining('123456')
        })
      );
      expect(result).toEqual({ messageId: 'abc' });
    });

    it('помечает ошибку авторизации (EAUTH) как permanent', async () => {
      const err = new Error('bad credentials');
      err.code = 'EAUTH';
      mockSendMail.mockRejectedValue(err);

      await expect(sendPasswordResetEmail({ to: 'user@example.com', code: '123456' }))
        .rejects.toMatchObject({ permanent: true });
    });

    it('помечает ответ 5xx от сервера как permanent', async () => {
      const err = new Error('mailbox unavailable');
      err.responseCode = 550;
      mockSendMail.mockRejectedValue(err);

      await expect(sendPasswordResetEmail({ to: 'user@example.com', code: '123456' }))
        .rejects.toMatchObject({ permanent: true });
    });

    it('не помечает сетевую ошибку как permanent', async () => {
      const err = new Error('connection timed out');
      err.code = 'ETIMEDOUT';
      mockSendMail.mockRejectedValue(err);

      await expect(sendPasswordResetEmail({ to: 'user@example.com', code: '123456' }))
        .rejects.toMatchObject({ permanent: false });
    });
  });

  describe('sendAnnouncementEmail', () => {
    const announcement = {
      to: 'owner@example.com',
      subject: 'Плановые работы',
      text: 'В субботу сервис будет недоступен с 2:00 до 4:00.'
    };

    it('бросает permanent-ошибку и не трогает nodemailer, если не настроено', async () => {
      config.isConfigured = false;

      await expect(sendAnnouncementEmail(announcement))
        .rejects.toMatchObject({ message: 'EMAIL_NOT_CONFIGURED', permanent: true });
      expect(nodemailer.createTransport).not.toHaveBeenCalled();

      config.isConfigured = true;
    });

    it('отправляет объявление получателю с заголовком и текстом как есть', async () => {
      mockSendMail.mockResolvedValue({ messageId: 'abc' });

      const result = await sendAnnouncementEmail(announcement);

      expect(mockSendMail).toHaveBeenCalledWith({
        from: '"RabbitFarm" <no-reply@test>',
        to: 'owner@example.com',
        subject: 'Плановые работы',
        text: 'В субботу сервис будет недоступен с 2:00 до 4:00.'
      });
      expect(result).toEqual({ messageId: 'abc' });
    });

    it('помечает ошибку авторизации (EAUTH) как permanent', async () => {
      const err = new Error('bad credentials');
      err.code = 'EAUTH';
      mockSendMail.mockRejectedValue(err);

      await expect(sendAnnouncementEmail(announcement))
        .rejects.toMatchObject({ permanent: true });
    });

    it('не помечает сетевую ошибку как permanent — рассылку можно повторить', async () => {
      const err = new Error('connection timed out');
      err.code = 'ETIMEDOUT';
      mockSendMail.mockRejectedValue(err);

      await expect(sendAnnouncementEmail(announcement))
        .rejects.toMatchObject({ permanent: false });
    });
  });
});
