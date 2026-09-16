jest.mock('../../../src/models', () => ({
  DeviceToken: {
    findAll: jest.fn(),
    destroy: jest.fn()
  },
  User: {
    findAll: jest.fn()
  }
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

jest.mock('../../../src/config/firebase', () => ({
  isConfigured: false,
  projectId: 'test-project',
  clientEmail: 'test@example.com',
  privateKey: 'test-key'
}));

const mockMessaging = { sendEachForMulticast: jest.fn() };
jest.mock('firebase-admin', () => ({
  apps: [],
  app: jest.fn(),
  initializeApp: jest.fn(() => ({})),
  credential: { cert: jest.fn() },
  messaging: jest.fn(() => mockMessaging)
}));

const { Op } = require('sequelize');
const { DeviceToken, User } = require('../../../src/models');
const firebaseConfig = require('../../../src/config/firebase');
const logger = require('../../../src/utils/logger');
const notificationService = require('../../../src/services/notificationService');

describe('notificationService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    firebaseConfig.isConfigured = false;
    notificationService._app = null;
  });

  describe('sendToUsers', () => {
    it('ничего не отправляет, если получателей нет', async () => {
      const result = await notificationService.sendToUsers(1, [], { title: 't', body: 'b' });

      expect(DeviceToken.findAll).not.toHaveBeenCalled();
      expect(result).toEqual({ sent: 0, failed: 0 });
    });

    it('молча пропускает отправку, если Firebase не настроен', async () => {
      const result = await notificationService.sendToUsers(1, [5], { title: 't', body: 'b' });

      expect(DeviceToken.findAll).not.toHaveBeenCalled();
      expect(logger.warn).toHaveBeenCalled();
      expect(result).toEqual({ sent: 0, failed: 0 });
    });

    it('возвращает нули, если ни у одного получателя нет устройств', async () => {
      firebaseConfig.isConfigured = true;
      DeviceToken.findAll.mockResolvedValue([]);

      const result = await notificationService.sendToUsers(1, [5], { title: 't', body: 'b' });

      expect(mockMessaging.sendEachForMulticast).not.toHaveBeenCalled();
      expect(result).toEqual({ sent: 0, failed: 0 });
    });

    it('шлёт пуш на токены получателей, когда Firebase настроен', async () => {
      firebaseConfig.isConfigured = true;
      DeviceToken.findAll.mockResolvedValue([
        { token: 'token-a' },
        { token: 'token-b' }
      ]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [{ success: true }, { success: true }]
      });

      await notificationService.sendToUsers(1, [5, 6], {
        title: 'Заголовок',
        body: 'Текст',
        data: { type: 'note', count: 3 }
      });

      expect(mockMessaging.sendEachForMulticast).toHaveBeenCalledWith({
        tokens: ['token-a', 'token-b'],
        notification: { title: 'Заголовок', body: 'Текст' },
        // data должна быть строками — FCM других типов не принимает.
        data: { type: 'note', count: '3' }
      });
      expect(DeviceToken.destroy).not.toHaveBeenCalled();
    });

    it('удаляет протухшие токены по ответу FCM', async () => {
      firebaseConfig.isConfigured = true;
      DeviceToken.findAll.mockResolvedValue([
        { token: 'token-live' },
        { token: 'token-dead' }
      ]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [
          { success: true },
          { success: false, error: { code: 'messaging/registration-token-not-registered' } }
        ]
      });

      await notificationService.sendToUsers(1, [5, 6], { title: 't', body: 'b' });

      expect(DeviceToken.destroy).toHaveBeenCalledWith({
        where: { farm_id: 1, token: { [Op.in]: ['token-dead'] } }
      });
    });

    // Счёт по токенам, а не по людям — нужен объявлениям платформенного админа.
    it('считает доставленные и недоставленные токены', async () => {
      firebaseConfig.isConfigured = true;
      DeviceToken.findAll.mockResolvedValue([
        { token: 'token-a' },
        { token: 'token-b' },
        { token: 'token-c' }
      ]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [
          { success: true },
          { success: false, error: { code: 'messaging/internal-error' } },
          { success: true }
        ]
      });

      const result = await notificationService.sendToUsers(1, [5, 6], { title: 't', body: 'b' });

      expect(result).toEqual({ sent: 2, failed: 1 });
    });
  });

  describe('язык уведомления', () => {
    beforeEach(() => {
      firebaseConfig.isConfigured = true;
    });

    it('шлёт каждому на его языке — одним запросом на язык', async () => {
      DeviceToken.findAll.mockResolvedValue([
        { token: 'ru-token', user_id: 5 },
        { token: 'tg-token', user_id: 6 },
        { token: 'ru-token-2', user_id: 5 }
      ]);
      User.findAll.mockResolvedValue([
        { id: 5, language: 'ru' },
        { id: 6, language: 'tg' }
      ]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [{ success: true }, { success: true }]
      });

      await notificationService.sendToUsers(1, [5, 6], {
        i18n: { key: 'feedDigest', params: { count: 2 } },
        data: { type: 'feed_digest' }
      });

      expect(mockMessaging.sendEachForMulticast).toHaveBeenCalledTimes(2);

      const calls = mockMessaging.sendEachForMulticast.mock.calls.map(c => c[0]);
      const russian = calls.find(c => c.tokens.includes('ru-token'));
      const tajik = calls.find(c => c.tokens.includes('tg-token'));

      expect(russian.tokens).toEqual(['ru-token', 'ru-token-2']);
      expect(russian.notification.title).toBe('Мало корма');
      expect(tajik.notification.title).toBe('Хӯрок кам мондааст');
    });

    it('человеку без языка достаётся русский, а не пустое уведомление', async () => {
      DeviceToken.findAll.mockResolvedValue([{ token: 'tok', user_id: 5 }]);
      // Пользователя могли удалить между выборкой токенов и этим запросом.
      User.findAll.mockResolvedValue([]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [{ success: true }]
      });

      await notificationService.sendToUsers(1, [5], {
        i18n: { key: 'feedDigest', params: { count: 1 } }
      });

      const [payload] = mockMessaging.sendEachForMulticast.mock.calls[0];
      expect(payload.notification.title).toBe('Мало корма');
    });

    it('готовый текст (объявление админа) языками не трогает', async () => {
      DeviceToken.findAll.mockResolvedValue([{ token: 'tok', user_id: 5 }]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [{ success: true }]
      });

      await notificationService.sendToUsers(1, [5], {
        title: 'Объявление',
        body: 'Текст от администратора'
      });

      expect(User.findAll).not.toHaveBeenCalled();
      const [payload] = mockMessaging.sendEachForMulticast.mock.calls[0];
      expect(payload.notification.title).toBe('Объявление');
    });

    it('протухшие токены убирает и при разбивке по языкам', async () => {
      DeviceToken.findAll.mockResolvedValue([
        { token: 'ru-token', user_id: 5 },
        { token: 'tg-token', user_id: 6 }
      ]);
      User.findAll.mockResolvedValue([
        { id: 5, language: 'ru' },
        { id: 6, language: 'tg' }
      ]);
      mockMessaging.sendEachForMulticast.mockResolvedValue({
        responses: [
          {
            success: false,
            error: { code: 'messaging/registration-token-not-registered' }
          }
        ]
      });

      const result = await notificationService.sendToUsers(1, [5, 6], {
        i18n: { key: 'feedDigest', params: { count: 1 } }
      });

      expect(result).toEqual({ sent: 0, failed: 2 });
      expect(DeviceToken.destroy).toHaveBeenCalledWith({
        where: { farm_id: 1, token: { [Op.in]: ['ru-token', 'tg-token'] } }
      });
    });
  });

  describe('sendToRoles', () => {
    it('находит участников фермы с нужной ролью и шлёт им', async () => {
      User.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      DeviceToken.findAll.mockResolvedValue([]);

      await notificationService.sendToRoles(1, ['owner', 'manager'], { title: 't', body: 'b' });

      expect(User.findAll).toHaveBeenCalledWith(expect.objectContaining({
        where: expect.objectContaining({ farm_id: 1, is_active: true })
      }));
    });
  });
});
