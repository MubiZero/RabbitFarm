/**
 * Обход ферм в суточном дайджесте. Полное покрытие самих правил дайджеста
 * здесь не цель — проверяется выбор ферм, которым он вообще положен.
 */
jest.mock('../../../src/models', () => ({
  Farm: { findAll: jest.fn() },
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

const { Farm, Vaccination, Task, Feed } = require('../../../src/models');
const notificationService = require('../../../src/services/notificationService');
const { runDigest } = require('../../../src/jobs/notificationDigestJob');

describe('notificationDigestJob.runDigest', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    Vaccination.count.mockResolvedValue(0);
    Feed.count.mockResolvedValue(0);
    Task.findAll.mockResolvedValue([]);
  });

  it('не рассылает дайджест мягко удалённым фермам — входить туда всё равно нельзя', async () => {
    Farm.findAll.mockResolvedValue([]);

    await runDigest();

    expect(Farm.findAll).toHaveBeenCalledWith(expect.objectContaining({
      where: { deleted_at: null }
    }));
  });

  it('обходит все живые фермы', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
    Vaccination.count.mockResolvedValue(3);

    await runDigest();

    expect(notificationService.sendToRoles).toHaveBeenCalledWith(1, ['owner', 'manager'], expect.anything());
    expect(notificationService.sendToRoles).toHaveBeenCalledWith(2, ['owner', 'manager'], expect.anything());
  });
});
