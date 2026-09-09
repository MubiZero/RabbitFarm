/**
 * Обход ферм в суточном дайджесте. Полное покрытие самих правил дайджеста
 * здесь не цель — проверяется выбор ферм, которым он вообще положен, и
 * фильтр получателей по `digest_enabled`.
 */
jest.mock('../../../src/models', () => ({
  Farm: { findAll: jest.fn() },
  User: { findAll: jest.fn() },
  Vaccination: { count: jest.fn() },
  Task: { findAll: jest.fn() },
  Feed: { count: jest.fn() }
}));
jest.mock('../../../src/services/notificationService', () => ({
  sendToRoles: jest.fn(),
  sendToUsers: jest.fn()
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Farm, User, Vaccination, Task, Feed } = require('../../../src/models');
const notificationService = require('../../../src/services/notificationService');
const { runDigest } = require('../../../src/jobs/notificationDigestJob');

describe('notificationDigestJob.runDigest', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    Vaccination.count.mockResolvedValue(0);
    Feed.count.mockResolvedValue(0);
    Task.findAll.mockResolvedValue([]);
    User.findAll.mockResolvedValue([{ id: 10 }, { id: 11 }]);
  });

  it('не рассылает дайджест мягко удалённым фермам — входить туда всё равно нельзя', async () => {
    Farm.findAll.mockResolvedValue([]);

    await runDigest();

    expect(Farm.findAll).toHaveBeenCalledWith(expect.objectContaining({
      where: { deleted_at: null }
    }));
  });

  it('обходит все живые фермы и шлёт только тем, кто не выключил дайджест', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
    Vaccination.count.mockResolvedValue(3);

    await runDigest();

    expect(User.findAll).toHaveBeenCalledWith(expect.objectContaining({
      where: expect.objectContaining({ farm_id: 1, is_active: true, digest_enabled: true })
    }));
    expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [10, 11], expect.anything());
    expect(notificationService.sendToUsers).toHaveBeenCalledWith(2, [10, 11], expect.anything());
    // Общий канал на роли здесь больше не используется — получатели уже
    // отфильтрованы по настройке, а не решаются на стороне сервиса.
    expect(notificationService.sendToRoles).not.toHaveBeenCalled();
  });

  it('никого не выключивших дайджест — не шлёт вовсе, а не пустому списку', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }]);
    Vaccination.count.mockResolvedValue(3);
    User.findAll.mockResolvedValue([]);

    await runDigest();

    expect(notificationService.sendToUsers).not.toHaveBeenCalled();
  });

  it('персональный пуш по просроченной задаче уходит исполнителю независимо от digest_enabled', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }]);
    User.findAll.mockResolvedValue([]);
    Task.findAll.mockResolvedValue([
      { id: 5, title: 'Почистить клетку', assigned_to: 42 }
    ]);

    await runDigest();

    expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [42], expect.objectContaining({
      title: 'Просроченная задача'
    }));
  });
});
