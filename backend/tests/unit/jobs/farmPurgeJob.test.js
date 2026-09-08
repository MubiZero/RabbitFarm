/**
 * Физическая зачистка мягко удалённых ферм (см.
 * docs/plans/PLATFORM-ADMIN.md, 2.4).
 */
jest.mock('../../../src/models', () => ({
  Farm: { findAll: jest.fn() },
  Rabbit: { destroy: jest.fn() },
  Breeding: { destroy: jest.fn() },
  Birth: { destroy: jest.fn() },
  FeedingRecord: { destroy: jest.fn() }
}));
jest.mock('../../../src/utils/fileStorage', () => ({
  deleteByPrefix: jest.fn()
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Op } = require('sequelize');
const { Farm, Rabbit, Breeding, Birth, FeedingRecord } = require('../../../src/models');
const fileStorage = require('../../../src/utils/fileStorage');
const logger = require('../../../src/utils/logger');
const { runPurge, purgeFarm } = require('../../../src/jobs/farmPurgeJob');

const MS_PER_DAY = 24 * 60 * 60 * 1000;
const BLOCKING = [FeedingRecord, Birth, Breeding, Rabbit];
const mockFarm = (id) => ({ id, destroy: jest.fn().mockResolvedValue(undefined) });

describe('farmPurgeJob', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    fileStorage.deleteByPrefix.mockResolvedValue(undefined);
    for (const Model of BLOCKING) {
      Model.destroy.mockResolvedValue(0);
    }
  });

  describe('purgeFarm', () => {
    it('сносит файлы фермы по её префиксу до удаления самой записи', async () => {
      const farm = mockFarm(42);
      const order = [];
      fileStorage.deleteByPrefix.mockImplementation(async () => order.push('files'));
      farm.destroy.mockImplementation(async () => order.push('row'));

      await purgeFarm(farm);

      expect(fileStorage.deleteByPrefix).toHaveBeenCalledWith('farm-42/');
      // Порядок обязателен: после destroy у записи не осталось бы `id`,
      // из которого собирается префикс, и файлы стали бы сиротами.
      expect(order).toEqual(['files', 'row']);
    });

    // Каскада фермы недостаточно: внутри одной фермы есть RESTRICT-ключи
    // (rabbits.breed_id -> breeds, breedings/births -> rabbits,
    // feeding_records.feed_id -> feeds), и DELETE FROM farms падает, пока эти
    // строки на месте. Проверено живьём против rabbitfarm_test.
    it('сносит мешающие каскаду таблицы снизу вверх и только потом саму ферму', async () => {
      const farm = mockFarm(42);
      const order = [];
      FeedingRecord.destroy.mockImplementation(async () => order.push('feeding_records'));
      Birth.destroy.mockImplementation(async () => order.push('births'));
      Breeding.destroy.mockImplementation(async () => order.push('breedings'));
      Rabbit.destroy.mockImplementation(async () => order.push('rabbits'));
      farm.destroy.mockImplementation(async () => order.push('farm'));

      await purgeFarm(farm);

      expect(order).toEqual(['feeding_records', 'births', 'breedings', 'rabbits', 'farm']);
      for (const Model of BLOCKING) {
        expect(Model.destroy).toHaveBeenCalledWith({ where: { farm_id: 42 } });
      }
    });
  });

  describe('runPurge', () => {
    it('ищет только фермы, удалённые больше 30 дней назад', async () => {
      Farm.findAll.mockResolvedValue([]);

      await runPurge();

      const { where } = Farm.findAll.mock.calls[0][0];
      const cutoff = where.deleted_at[Op.lt];
      const expected = Date.now() - 30 * MS_PER_DAY;
      // Точное сравнение с датой бессмысленно (между вызовами проходит время)
      // — важно, что порог именно тридцатидневный.
      expect(Math.abs(cutoff.getTime() - expected)).toBeLessThan(5000);
    });

    it('зачищает все найденные фермы', async () => {
      const farms = [mockFarm(1), mockFarm(2)];
      Farm.findAll.mockResolvedValue(farms);

      await runPurge();

      expect(fileStorage.deleteByPrefix).toHaveBeenCalledWith('farm-1/');
      expect(fileStorage.deleteByPrefix).toHaveBeenCalledWith('farm-2/');
      expect(farms[0].destroy).toHaveBeenCalled();
      expect(farms[1].destroy).toHaveBeenCalled();
    });

    it('ничего не делает, если удалённых ферм с истёкшим сроком нет', async () => {
      Farm.findAll.mockResolvedValue([]);

      await runPurge();

      expect(fileStorage.deleteByPrefix).not.toHaveBeenCalled();
    });

    it('одна упавшая ферма не прерывает обход остальных', async () => {
      const failing = mockFarm(1);
      failing.destroy.mockRejectedValue(new Error('FK constraint'));
      const healthy = mockFarm(2);
      Farm.findAll.mockResolvedValue([failing, healthy]);

      await expect(runPurge()).resolves.toBeUndefined();

      expect(healthy.destroy).toHaveBeenCalled();
      expect(logger.error).toHaveBeenCalledWith('Farm purge failed', expect.objectContaining({ farmId: 1 }));
    });
  });
});
