/**
 * Приглашение вернуться на 14-й и 30-й день молчания фермы — тот же признак
 * неактивности, который платформенный админ видит фильтром `inactive_days`.
 */
jest.mock('../../../src/models', () => ({
  Farm: { findAll: jest.fn() }
}));
jest.mock('../../../src/services/platformAdminService', () => ({
  lastActiveByFarm: jest.fn().mockResolvedValue({})
}));
jest.mock('../../../src/services/notifications/farmOwnerNotifier', () => ({
  notifyFarmOwners: jest.fn().mockResolvedValue({ owners: 1 })
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Farm } = require('../../../src/models');
const platformAdminService = require('../../../src/services/platformAdminService');
const { notifyFarmOwners } = require('../../../src/services/notifications/farmOwnerNotifier');
const logger = require('../../../src/utils/logger');
const { runWinbackReminders, daysSince, reminderStage } = require('../../../src/jobs/inactivityWinbackJob');

const MS_PER_DAY = 24 * 60 * 60 * 1000;
const daysAgo = (n) => new Date(Date.now() - n * MS_PER_DAY);

const mockFarm = ({
  id = 1,
  name = 'Заря',
  status = 'active',
  inactivity_notified_days = null,
  created_at = daysAgo(200),
  deleted_at = null
} = {}) => ({
  id,
  name,
  status,
  inactivity_notified_days,
  created_at,
  deleted_at,
  update: jest.fn().mockResolvedValue(undefined)
});

/** Последний вход по ферме — то, что отдаёт общий признак активности. */
const lastActive = (map) => platformAdminService.lastActiveByFarm.mockResolvedValue(map);

describe('inactivityWinbackJob', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    notifyFarmOwners.mockResolvedValue({ owners: 1 });
    lastActive({});
  });

  describe('daysSince', () => {
    it('считает календарные дни, без учёта времени суток', () => {
      const now = new Date(2026, 8, 24, 0, 5);
      const past = new Date(2026, 8, 10, 23, 50);

      expect(daysSince(past, now)).toBe(14);
    });

    it('ноль для сегодняшнего входа', () => {
      const now = new Date(2026, 8, 24, 18, 0);

      expect(daysSince(new Date(2026, 8, 24, 1, 0), now)).toBe(0);
    });
  });

  describe('reminderStage', () => {
    it.each([
      [0, null],
      [13, null],
      [14, 14],
      [29, 14],
      [30, 30],
      [90, 30]
    ])('%i дней молчания → порог %p', (inactiveDays, expected) => {
      expect(reminderStage(inactiveDays)).toBe(expected);
    });
  });

  describe('runWinbackReminders', () => {
    it('ищет только не удалённые фермы', async () => {
      Farm.findAll.mockResolvedValue([]);

      await runWinbackReminders();

      expect(Farm.findAll).toHaveBeenCalledWith({ where: { deleted_at: null } });
      expect(platformAdminService.lastActiveByFarm).not.toHaveBeenCalled();
    });

    it('на 14-й день молчания зовёт владельца и запоминает порог', async () => {
      const farm = mockFarm();
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(14) });

      await runWinbackReminders();

      expect(notifyFarmOwners).toHaveBeenCalledWith(farm.id, expect.objectContaining({
        title: 'Давно вас не было',
        data: { type: 'farm_inactive', route: '/today' }
      }));
      expect(notifyFarmOwners.mock.calls[0][1].body).toContain('«Заря»');
      expect(farm.update).toHaveBeenCalledWith({ inactivity_notified_days: 14 });
    });

    it('на 30-й день — отдельный текст и свой порог', async () => {
      const farm = mockFarm({ inactivity_notified_days: 14 });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(30) });

      await runWinbackReminders();

      expect(notifyFarmOwners).toHaveBeenCalledWith(farm.id, expect.objectContaining({
        title: 'Ферма ждёт вас'
      }));
      expect(farm.update).toHaveBeenCalledWith({ inactivity_notified_days: 30 });
    });

    it('молчит, пока порог не достигнут', async () => {
      const farm = mockFarm();
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(13) });

      await runWinbackReminders();

      expect(notifyFarmOwners).not.toHaveBeenCalled();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('не шлёт то же приглашение второй раз', async () => {
      const farm = mockFarm({ inactivity_notified_days: 14 });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(20) });

      await runWinbackReminders();

      expect(notifyFarmOwners).not.toHaveBeenCalled();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('не теряет порог, если день был пропущен', async () => {
      const farm = mockFarm();
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(17) });

      await runWinbackReminders();

      expect(farm.update).toHaveBeenCalledWith({ inactivity_notified_days: 14 });
    });

    it('вернувшейся ферме сбрасывает отметку, чтобы позвать её и в следующий раз', async () => {
      const farm = mockFarm({ inactivity_notified_days: 30 });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(1) });

      await runWinbackReminders();

      expect(notifyFarmOwners).not.toHaveBeenCalled();
      expect(farm.update).toHaveBeenCalledWith({ inactivity_notified_days: null });
    });

    it('активной ферме без отметки ничего не пишет', async () => {
      const farm = mockFarm();
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(2) });

      await runWinbackReminders();

      expect(farm.update).not.toHaveBeenCalled();
    });

    it('ни одного входа вообще — считает от создания фермы', async () => {
      const farm = mockFarm({ created_at: daysAgo(31) });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({});

      await runWinbackReminders();

      expect(farm.update).toHaveBeenCalledWith({ inactivity_notified_days: 30 });
    });

    it('свежую ферму без входов не трогает', async () => {
      const farm = mockFarm({ created_at: daysAgo(3) });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({});

      await runWinbackReminders();

      expect(notifyFarmOwners).not.toHaveBeenCalled();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('приостановленную ферму не зовёт — войти она всё равно не сможет', async () => {
      const farm = mockFarm({ status: 'suspended' });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(40) });

      await runWinbackReminders();

      expect(notifyFarmOwners).not.toHaveBeenCalled();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('ферму в режиме только для чтения зовёт — доступ к приложению у неё есть', async () => {
      const farm = mockFarm({ status: 'read_only' });
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(14) });

      await runWinbackReminders();

      expect(notifyFarmOwners).toHaveBeenCalled();
    });

    it('не запоминает порог, если уведомление не ушло', async () => {
      const farm = mockFarm();
      Farm.findAll.mockResolvedValue([farm]);
      lastActive({ 1: daysAgo(14) });
      notifyFarmOwners.mockRejectedValueOnce(new Error('fcm down'));

      await runWinbackReminders();

      expect(farm.update).not.toHaveBeenCalled();
      expect(logger.error).toHaveBeenCalled();
    });

    it('одна упавшая ферма не останавливает обработку остальных', async () => {
      const broken = mockFarm({ id: 1 });
      const healthy = mockFarm({ id: 2 });
      Farm.findAll.mockResolvedValue([broken, healthy]);
      lastActive({ 1: daysAgo(14), 2: daysAgo(14) });
      notifyFarmOwners
        .mockRejectedValueOnce(new Error('fcm down'))
        .mockResolvedValue({ owners: 1 });

      await runWinbackReminders();

      expect(notifyFarmOwners).toHaveBeenCalledTimes(2);
      expect(healthy.update).toHaveBeenCalledWith({ inactivity_notified_days: 14 });
    });
  });
});
