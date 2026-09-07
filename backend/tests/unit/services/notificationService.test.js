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
      await notificationService.sendToUsers(1, [], { title: 't', body: 'b' });
      expect(DeviceToken.findAll).not.toHaveBeenCalled();
    });

    it('молча пропускает отправку, если Firebase не настроен', async () => {
      await notificationService.sendToUsers(1, [5], { title: 't', body: 'b' });

      expect(DeviceToken.findAll).not.toHaveBeenCalled();
      expect(logger.warn).toHaveBeenCalled();
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
