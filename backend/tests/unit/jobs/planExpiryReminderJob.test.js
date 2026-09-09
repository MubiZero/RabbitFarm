/**
 * Напоминания о продлении тарифа — до истечения и после, — а также перевод
 * в read_only с запасом на подтверждение банка (см.
 * docs/plans/PLATFORM-ADMIN.md, 4.2).
 */
jest.mock('../../../src/models', () => ({
  Farm: { findAll: jest.fn() },
  Plan: {},
  User: { findAll: jest.fn() }
}));
jest.mock('../../../src/services/notificationService', () => ({
  sendToUsers: jest.fn().mockResolvedValue({ sent: 0, failed: 0 })
}));
jest.mock('../../../src/services/notifications/emailTransport', () => ({
  sendAnnouncementEmail: jest.fn().mockResolvedValue(undefined)
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Farm, User } = require('../../../src/models');
const notificationService = require('../../../src/services/notificationService');
const { sendAnnouncementEmail } = require('../../../src/services/notifications/emailTransport');
const logger = require('../../../src/utils/logger');
const { runReminders, daysUntil, graceHours } = require('../../../src/jobs/planExpiryReminderJob');

const MS_PER_DAY = 24 * 60 * 60 * 1000;
const MS_PER_HOUR = 60 * 60 * 1000;
const inDays = (n) => new Date(Date.now() + n * MS_PER_DAY);
const inHours = (n) => new Date(Date.now() + n * MS_PER_HOUR);

const mockFarm = ({ id = 1, status = 'active', plan = { name: 'Базовый' }, plan_expires_at }) => ({
  id,
  status,
  plan,
  plan_expires_at,
  update: jest.fn().mockResolvedValue(undefined)
});

const mockOwners = (owners) => User.findAll.mockResolvedValue(owners);

describe('planExpiryReminderJob', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockOwners([{ id: 9, email: 'owner@example.com' }]);
    delete process.env.PLAN_EXPIRY_GRACE_HOURS;
  });

  afterAll(() => {
    delete process.env.PLAN_EXPIRY_GRACE_HOURS;
  });

  describe('daysUntil', () => {
    it('считает по календарным дням, без учёта времени суток', () => {
      const now = new Date(2026, 8, 9, 23, 50);
      const target = new Date(2026, 8, 16, 0, 5);

      expect(daysUntil(target, now)).toBe(7);
    });

    it('отрицательное число для уже прошедшей даты', () => {
      const now = new Date(2026, 8, 9);
      const target = new Date(2026, 8, 5);

      expect(daysUntil(target, now)).toBe(-4);
    });
  });

  describe('runReminders', () => {
    it('ищет только фермы с известным сроком платного тарифа', async () => {
      Farm.findAll.mockResolvedValue([]);

      await runReminders();

      expect(Farm.findAll).toHaveBeenCalledWith(expect.objectContaining({
        where: expect.objectContaining({ deleted_at: null })
      }));
    });

    it('за 7 дней до истечения — пуш и письмо владельцу, статус не трогает', async () => {
      const farm = mockFarm({ plan_expires_at: inDays(7) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        farm.id,
        [9],
        expect.objectContaining({ title: 'Тариф скоро закончится' })
      );
      expect(sendAnnouncementEmail).toHaveBeenCalledWith(expect.objectContaining({
        to: 'owner@example.com',
        subject: 'Тариф скоро закончится'
      }));
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('за 1 день до истечения — отдельный текст «завтра»', async () => {
      const farm = mockFarm({ plan_expires_at: inDays(1) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        farm.id,
        [9],
        expect.objectContaining({ title: 'Тариф заканчивается завтра' })
      );
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('не шлёт ничего в дни, не совпадающие ни с одним порогом', async () => {
      const farm = mockFarm({ plan_expires_at: inDays(3) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(sendAnnouncementEmail).not.toHaveBeenCalled();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('когда запас на подтверждение банка прошёл — переводит активную ферму в read_only и уведомляет', async () => {
      const farm = mockFarm({ status: 'active', plan_expires_at: inHours(-7) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).toHaveBeenCalledWith({ status: 'read_only' });
      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        farm.id,
        [9],
        expect.objectContaining({ title: 'Тариф истёк' })
      );
    });

    it('внутри запаса на подтверждение банка ферма остаётся активной и без уведомлений', async () => {
      const farm = mockFarm({ status: 'active', plan_expires_at: inHours(-2) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).not.toHaveBeenCalled();
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });

    it('размер запаса берётся из PLAN_EXPIRY_GRACE_HOURS', async () => {
      process.env.PLAN_EXPIRY_GRACE_HOURS = '1';
      const farm = mockFarm({ status: 'active', plan_expires_at: inHours(-2) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).toHaveBeenCalledWith({ status: 'read_only' });
    });

    it('самовосстанавливается для просроченной фермы, если день истечения был пропущен', async () => {
      const farm = mockFarm({ status: 'active', plan_expires_at: inDays(-5) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).toHaveBeenCalledWith({ status: 'read_only' });
    });

    it('не трогает уже read_only ферму повторно', async () => {
      const farm = mockFarm({ status: 'read_only', plan_expires_at: inDays(-1) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).not.toHaveBeenCalled();
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });

    it('не снимает приостановку — read_only только для активных ферм', async () => {
      const farm = mockFarm({ status: 'suspended', plan_expires_at: inDays(-1) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).not.toHaveBeenCalled();
    });

    it('пропускает ферму, у которой срок остался, а тариф уже сняли', async () => {
      const farm = mockFarm({ plan: null, plan_expires_at: inDays(0) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).not.toHaveBeenCalled();
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });

    it('переводит в read_only даже без владельца — доступ закрывается независимо от того, кого удалось уведомить', async () => {
      mockOwners([]);
      const farm = mockFarm({ status: 'active', plan_expires_at: inHours(-7) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).toHaveBeenCalledWith({ status: 'read_only' });
      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });

    it('одна упавшая ферма не останавливает обработку остальных', async () => {
      const broken = mockFarm({ id: 1, plan_expires_at: inDays(7) });
      const healthy = mockFarm({ id: 2, plan_expires_at: inDays(7) });
      notificationService.sendToUsers
        .mockRejectedValueOnce(new Error('fcm down'))
        .mockResolvedValue({ sent: 1, failed: 0 });
      Farm.findAll.mockResolvedValue([broken, healthy]);

      await runReminders();

      expect(logger.error).toHaveBeenCalled();
      expect(notificationService.sendToUsers).toHaveBeenCalledTimes(2);
    });
  });

  describe('напоминания после перехода в read_only', () => {
    it('на 3-й день просрочки — пуш и письмо, статус не трогает', async () => {
      const farm = mockFarm({ status: 'read_only', plan_expires_at: inDays(-3) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        farm.id,
        [9],
        expect.objectContaining({ title: 'Ферма работает только на чтение' })
      );
      expect(sendAnnouncementEmail).toHaveBeenCalledWith(expect.objectContaining({
        to: 'owner@example.com',
        subject: 'Ферма работает только на чтение'
      }));
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('на 14-й день просрочки — отдельный текст про две недели', async () => {
      const farm = mockFarm({ status: 'read_only', plan_expires_at: inDays(-14) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        farm.id,
        [9],
        expect.objectContaining({ title: 'Тариф не продлён две недели' })
      );
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('в остальные дни просрочки молчит — по одному напоминанию на порог', async () => {
      for (const days of [-2, -4, -13, -15, -30]) {
        jest.clearAllMocks();
        Farm.findAll.mockResolvedValue([mockFarm({ status: 'read_only', plan_expires_at: inDays(days) })]);

        await runReminders();

        expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      }
    });

    it('ферму, которую задача пропустила, сперва переводит в read_only, а не шлёт напоминание о просрочке', async () => {
      const farm = mockFarm({ status: 'active', plan_expires_at: inDays(-3) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(farm.update).toHaveBeenCalledWith({ status: 'read_only' });
      expect(notificationService.sendToUsers).toHaveBeenCalledTimes(1);
      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        farm.id,
        [9],
        expect.objectContaining({ title: 'Тариф истёк' })
      );
    });

    it('приостановленной ферме не напоминает — продление ей доступа всё равно не откроет', async () => {
      const farm = mockFarm({ status: 'suspended', plan_expires_at: inDays(-3) });
      Farm.findAll.mockResolvedValue([farm]);

      await runReminders();

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(farm.update).not.toHaveBeenCalled();
    });

  });

  describe('graceHours', () => {
    it('по умолчанию 6 часов', () => {
      expect(graceHours()).toBe(6);
    });

    it('пустая или нечисловая переменная не отключает запас', () => {
      process.env.PLAN_EXPIRY_GRACE_HOURS = '';
      expect(graceHours()).toBe(6);

      process.env.PLAN_EXPIRY_GRACE_HOURS = 'полдня';
      expect(graceHours()).toBe(6);

      process.env.PLAN_EXPIRY_GRACE_HOURS = '-3';
      expect(graceHours()).toBe(6);
    });

    it('явный ноль отключает запас — перевод день в день', () => {
      process.env.PLAN_EXPIRY_GRACE_HOURS = '0';
      expect(graceHours()).toBe(0);
    });
  });
});
