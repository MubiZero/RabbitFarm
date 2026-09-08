jest.mock('../../../src/models', () => ({
  Announcement: {
    create: jest.fn(),
    findAndCountAll: jest.fn()
  },
  Farm: {
    findAll: jest.fn(),
    findByPk: jest.fn()
  },
  User: {
    findAll: jest.fn()
  }
}));
jest.mock('../../../src/services/notificationService', () => ({
  sendToUsers: jest.fn()
}));
jest.mock('../../../src/services/notifications/emailTransport', () => ({
  sendAnnouncementEmail: jest.fn()
}));
jest.mock('../../../src/services/platformAdminService', () => ({
  listFarms: jest.fn()
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Announcement, Farm, User } = require('../../../src/models');
const notificationService = require('../../../src/services/notificationService');
const { sendAnnouncementEmail } = require('../../../src/services/notifications/emailTransport');
const platformAdminService = require('../../../src/services/platformAdminService');
const logger = require('../../../src/utils/logger');
const announcementService = require('../../../src/services/announcementService');

const baseInput = {
  adminId: 1,
  title: 'Плановые работы',
  body: 'В субботу сервис будет недоступен с 2:00 до 4:00.',
  channels: ['push'],
  targetType: 'all'
};

describe('AnnouncementService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    Farm.findAll.mockResolvedValue([]);
    User.findAll.mockResolvedValue([]);
    notificationService.sendToUsers.mockResolvedValue({ sent: 0, failed: 0 });
    sendAnnouncementEmail.mockResolvedValue({ messageId: 'msg' });
    Announcement.create.mockImplementation((values) => Promise.resolve({ id: 10, ...values }));
  });

  describe('create — выбор получателей', () => {
    it('при target_type=all берёт все незаудалённые фермы', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      User.findAll.mockResolvedValue([{ id: 5, farm_id: 1, email: 'a@example.com' }]);

      await announcementService.create({ ...baseInput, targetType: 'all' });

      expect(Farm.findAll).toHaveBeenCalledWith(expect.objectContaining({
        where: { deleted_at: null }
      }));
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        target_type: 'all',
        target_farm_id: null,
        target_filter: null,
        farms_count: 2
      }));
    });

    it('при target_type=farm бьёт по одной ферме и пишет её в target_farm_id', async () => {
      Farm.findByPk.mockResolvedValue({ id: 7 });
      User.findAll.mockResolvedValue([{ id: 5, farm_id: 7, email: 'a@example.com' }]);

      await announcementService.create({
        ...baseInput,
        targetType: 'farm',
        targetFarmId: 7
      });

      expect(Farm.findByPk).toHaveBeenCalledWith(7);
      expect(Farm.findAll).not.toHaveBeenCalled();
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        target_type: 'farm',
        target_farm_id: 7,
        target_filter: null,
        farms_count: 1,
        recipients_count: 1
      }));
    });

    it('при target_type=farm бросает FARM_NOT_FOUND и ничего не отправляет', async () => {
      Farm.findByPk.mockResolvedValue(null);

      await expect(
        announcementService.create({ ...baseInput, targetType: 'farm', targetFarmId: 99 })
      ).rejects.toThrow('FARM_NOT_FOUND');

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(sendAnnouncementEmail).not.toHaveBeenCalled();
      expect(Announcement.create).not.toHaveBeenCalled();
    });

    it('при target_type=filter переиспользует фильтр списка ферм целиком, без пагинации', async () => {
      platformAdminService.listFarms.mockResolvedValue({
        items: [{ id: 3 }, { id: 4 }],
        pagination: { page: 1, limit: Number.MAX_SAFE_INTEGER, total: 2, totalPages: 1 }
      });
      User.findAll.mockResolvedValue([{ id: 5, farm_id: 3, email: 'a@example.com' }]);

      await announcementService.create({
        ...baseInput,
        targetType: 'filter',
        targetFilter: 'no_plan'
      });

      expect(platformAdminService.listFarms).toHaveBeenCalledWith({
        filter: 'no_plan',
        limit: Number.MAX_SAFE_INTEGER
      });
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        target_type: 'filter',
        target_filter: 'no_plan',
        target_farm_id: null,
        farms_count: 2
      }));
    });

    it('ищет только активных участников найденных ферм', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      User.findAll.mockResolvedValue([{ id: 5, farm_id: 1, email: 'a@example.com' }]);

      await announcementService.create(baseInput);

      expect(User.findAll).toHaveBeenCalledWith(expect.objectContaining({
        where: { farm_id: [1, 2], is_active: true }
      }));
    });

    it('бросает NO_RECIPIENTS и ничего не отправляет, если под фильтр не попала ни одна ферма', async () => {
      platformAdminService.listFarms.mockResolvedValue({
        items: [],
        pagination: { page: 1, limit: Number.MAX_SAFE_INTEGER, total: 0, totalPages: 0 }
      });

      await expect(
        announcementService.create({ ...baseInput, targetType: 'filter', targetFilter: 'suspended' })
      ).rejects.toThrow('NO_RECIPIENTS');

      expect(User.findAll).not.toHaveBeenCalled();
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(Announcement.create).not.toHaveBeenCalled();
    });

    it('бросает NO_RECIPIENTS, если у найденных ферм нет ни одного активного пользователя', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      User.findAll.mockResolvedValue([]);

      await expect(announcementService.create(baseInput)).rejects.toThrow('NO_RECIPIENTS');

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(Announcement.create).not.toHaveBeenCalled();
    });
  });

  describe('create — каналы', () => {
    it('шлёт пуш по каждой ферме отдельно, своими получателями', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      User.findAll.mockResolvedValue([
        { id: 5, farm_id: 1, email: 'a@example.com' },
        { id: 6, farm_id: 1, email: 'b@example.com' },
        { id: 7, farm_id: 2, email: 'c@example.com' }
      ]);

      await announcementService.create({ ...baseInput, channels: ['push'] });

      expect(notificationService.sendToUsers).toHaveBeenCalledTimes(2);
      expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [5, 6], {
        title: baseInput.title,
        body: baseInput.body,
        data: { type: 'announcement' }
      });
      expect(notificationService.sendToUsers).toHaveBeenCalledWith(2, [7], expect.anything());
      expect(sendAnnouncementEmail).not.toHaveBeenCalled();
    });

    it('складывает статистику пушей по всем фермам', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      User.findAll.mockResolvedValue([
        { id: 5, farm_id: 1, email: 'a@example.com' },
        { id: 7, farm_id: 2, email: 'c@example.com' }
      ]);
      notificationService.sendToUsers
        .mockResolvedValueOnce({ sent: 2, failed: 1 })
        .mockResolvedValueOnce({ sent: 3, failed: 0 });

      await announcementService.create({ ...baseInput, channels: ['push'] });

      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        stats: { push: { sent: 5, failed: 1 }, email: { sent: 0, failed: 0 } }
      }));
    });

    it('сбой пуша по одной ферме не срывает рассылку остальным', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      User.findAll.mockResolvedValue([
        { id: 5, farm_id: 1, email: 'a@example.com' },
        { id: 7, farm_id: 2, email: 'c@example.com' }
      ]);
      notificationService.sendToUsers
        .mockRejectedValueOnce(new Error('FCM down'))
        .mockResolvedValueOnce({ sent: 1, failed: 0 });

      await announcementService.create({ ...baseInput, channels: ['push'] });

      expect(notificationService.sendToUsers).toHaveBeenCalledTimes(2);
      expect(logger.error).toHaveBeenCalled();
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        stats: { push: { sent: 1, failed: 0 }, email: { sent: 0, failed: 0 } }
      }));
    });

    it('шлёт письмо каждому получателю с заголовком и текстом объявления', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      User.findAll.mockResolvedValue([
        { id: 5, farm_id: 1, email: 'a@example.com' },
        { id: 6, farm_id: 1, email: 'b@example.com' }
      ]);

      await announcementService.create({ ...baseInput, channels: ['email'] });

      expect(sendAnnouncementEmail).toHaveBeenCalledTimes(2);
      expect(sendAnnouncementEmail).toHaveBeenCalledWith({
        to: 'a@example.com',
        subject: baseInput.title,
        text: baseInput.body
      });
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        stats: { push: { sent: 0, failed: 0 }, email: { sent: 2, failed: 0 } }
      }));
    });

    it('сбой письма одному получателю не срывает отправку остальным', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      User.findAll.mockResolvedValue([
        { id: 5, farm_id: 1, email: 'bad@example.com' },
        { id: 6, farm_id: 1, email: 'b@example.com' }
      ]);
      sendAnnouncementEmail
        .mockRejectedValueOnce(new Error('EMAIL_NOT_CONFIGURED'))
        .mockResolvedValueOnce({ messageId: 'msg' });

      await announcementService.create({ ...baseInput, channels: ['email'] });

      expect(sendAnnouncementEmail).toHaveBeenCalledTimes(2);
      expect(logger.error).toHaveBeenCalled();
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        stats: { push: { sent: 0, failed: 0 }, email: { sent: 1, failed: 1 } }
      }));
    });

    it('шлёт в оба канала, если запрошены оба', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      User.findAll.mockResolvedValue([{ id: 5, farm_id: 1, email: 'a@example.com' }]);
      notificationService.sendToUsers.mockResolvedValue({ sent: 1, failed: 0 });

      await announcementService.create({ ...baseInput, channels: ['push', 'email'] });

      expect(notificationService.sendToUsers).toHaveBeenCalledTimes(1);
      expect(sendAnnouncementEmail).toHaveBeenCalledTimes(1);
      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        channels: ['push', 'email']
      }));
    });

    it('отбрасывает неподдерживаемый канал sms и не пытается его отправить', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      User.findAll.mockResolvedValue([{ id: 5, farm_id: 1, email: 'a@example.com' }]);

      await announcementService.create({ ...baseInput, channels: ['sms', 'email'] });

      expect(Announcement.create).toHaveBeenCalledWith(expect.objectContaining({
        channels: ['email']
      }));
      expect(sendAnnouncementEmail).toHaveBeenCalledTimes(1);
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });
  });

  describe('create — запись в историю', () => {
    it('сохраняет объявление с автором, текстом и числом получателей', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
      User.findAll.mockResolvedValue([
        { id: 5, farm_id: 1, email: 'a@example.com' },
        { id: 7, farm_id: 2, email: 'c@example.com' }
      ]);
      notificationService.sendToUsers.mockResolvedValue({ sent: 1, failed: 0 });

      const result = await announcementService.create({ ...baseInput, channels: ['push'] });

      expect(Announcement.create).toHaveBeenCalledWith({
        admin_id: 1,
        title: baseInput.title,
        body: baseInput.body,
        channels: ['push'],
        target_type: 'all',
        target_farm_id: null,
        target_filter: null,
        farms_count: 2,
        recipients_count: 2,
        stats: { push: { sent: 2, failed: 0 }, email: { sent: 0, failed: 0 } }
      });
      expect(result).toEqual(expect.objectContaining({ id: 10 }));
    });
  });

  describe('list', () => {
    it('отдаёт постраничный список, свежие сверху', async () => {
      Announcement.findAndCountAll.mockResolvedValue({
        count: 2,
        rows: [{ id: 2 }, { id: 1 }]
      });

      const result = await announcementService.list({ page: 1, limit: 20 });

      expect(Announcement.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({
          order: [['created_at', 'DESC']],
          limit: 20,
          offset: 0
        })
      );
      expect(result.items).toEqual([{ id: 2 }, { id: 1 }]);
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 2, totalPages: 1 });
    });

    it('считает offset по номеру страницы', async () => {
      Announcement.findAndCountAll.mockResolvedValue({ count: 25, rows: [] });

      const result = await announcementService.list({ page: '3', limit: '10' });

      expect(Announcement.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({ limit: 10, offset: 20 })
      );
      expect(result.pagination).toEqual({ page: 3, limit: 10, total: 25, totalPages: 3 });
    });

    it('подставляет первую страницу по 20 записей, если параметров нет', async () => {
      Announcement.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await announcementService.list();

      expect(Announcement.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({ limit: 20, offset: 0 })
      );
    });
  });
});
