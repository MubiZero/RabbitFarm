jest.mock('../../../src/models', () => ({
  Farm: {
    findAndCountAll: jest.fn(),
    findByPk: jest.fn()
  },
  Plan: {
    findByPk: jest.fn()
  },
  Rabbit: {
    count: jest.fn()
  },
  User: {
    count: jest.fn()
  }
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Farm, Plan, Rabbit, User } = require('../../../src/models');
const platformAdminService = require('../../../src/services/platformAdminService');

describe('PlatformAdminService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('listFarms', () => {
    it('добавляет к каждой ферме фактическое число кроликов и участников', async () => {
      const farms = [
        { id: 1, toJSON: () => ({ id: 1, name: 'Ферма 1' }) },
        { id: 2, toJSON: () => ({ id: 2, name: 'Ферма 2' }) }
      ];
      Farm.findAndCountAll.mockResolvedValue({ count: 2, rows: farms });
      Rabbit.count.mockResolvedValue([{ farm_id: 1, count: 5 }]);
      User.count.mockResolvedValue([{ farm_id: 1, count: 2 }, { farm_id: 2, count: 1 }]);

      const result = await platformAdminService.listFarms({ page: 1, limit: 20 });

      expect(result.items).toEqual([
        { id: 1, name: 'Ферма 1', rabbits_count: 5, staff_count: 2 },
        { id: 2, name: 'Ферма 2', rabbits_count: 0, staff_count: 1 }
      ]);
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 2, totalPages: 1 });
    });

    it('запрашивает вместе с фермой её тариф и владельца', async () => {
      Farm.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await platformAdminService.listFarms();

      const { include } = Farm.findAndCountAll.mock.calls[0][0];
      expect(include).toEqual(expect.arrayContaining([
        expect.objectContaining({ as: 'plan' }),
        expect.objectContaining({ as: 'owner' })
      ]));
    });

    it('не запрашивает счётчики, если ферм нет', async () => {
      Farm.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      const result = await platformAdminService.listFarms();

      expect(Rabbit.count).not.toHaveBeenCalled();
      expect(User.count).not.toHaveBeenCalled();
      expect(result.items).toEqual([]);
    });
  });

  describe('getFarm', () => {
    it('отдаёт ферму вместе с её фактическим потреблением', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 7,
        toJSON: () => ({ id: 7, name: 'Ферма 7', plan: { id: 2 } })
      });
      Rabbit.count.mockResolvedValue(12);
      User.count.mockResolvedValue(3);

      const farm = await platformAdminService.getFarm(7);

      expect(farm).toEqual({
        id: 7,
        name: 'Ферма 7',
        plan: { id: 2 },
        rabbits_count: 12,
        staff_count: 3
      });
    });

    it('бросает FARM_NOT_FOUND для несуществующей фермы', async () => {
      Farm.findByPk.mockResolvedValue(null);
      Rabbit.count.mockResolvedValue(0);
      User.count.mockResolvedValue(0);

      await expect(platformAdminService.getFarm(999)).rejects.toThrow('FARM_NOT_FOUND');
    });
  });

  describe('assignPlan', () => {
    it('бросает FARM_NOT_FOUND для несуществующей фермы', async () => {
      Farm.findByPk.mockResolvedValue(null);

      await expect(platformAdminService.assignPlan(999, 1)).rejects.toThrow('FARM_NOT_FOUND');
    });

    it('бросает PLAN_NOT_FOUND, если назначаемый тариф не существует', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, update: jest.fn() });
      Plan.findByPk.mockResolvedValue(null);

      await expect(platformAdminService.assignPlan(1, 999)).rejects.toThrow('PLAN_NOT_FOUND');
    });

    it('снимает тариф, когда planId = null, не проверяя существование плана', async () => {
      const farm = { id: 1, update: jest.fn().mockResolvedValue(undefined) };
      Farm.findByPk
        .mockResolvedValueOnce(farm)
        .mockResolvedValueOnce({ id: 1, toJSON: () => ({ id: 1, plan: null }) });
      Rabbit.count.mockResolvedValue(0);
      User.count.mockResolvedValue(1);

      await platformAdminService.assignPlan(1, null);

      expect(Plan.findByPk).not.toHaveBeenCalled();
      expect(farm.update).toHaveBeenCalledWith({ plan_id: null });
    });

    it('не назначает выключенный тариф', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, update: jest.fn() });
      Plan.findByPk.mockResolvedValue({ id: 2, name: 'Pro', is_active: false });

      await expect(platformAdminService.assignPlan(1, 2)).rejects.toThrow('PLAN_INACTIVE');
    });

    it('назначает тариф, когда он существует', async () => {
      const farm = { id: 1, update: jest.fn().mockResolvedValue(undefined) };
      Farm.findByPk
        .mockResolvedValueOnce(farm)
        .mockResolvedValueOnce({ id: 1, toJSON: () => ({ id: 1, plan: { id: 2 } }) });
      Plan.findByPk.mockResolvedValue({ id: 2, name: 'Pro', is_active: true });
      Rabbit.count.mockResolvedValue(5);
      User.count.mockResolvedValue(2);

      const result = await platformAdminService.assignPlan(1, 2);

      expect(farm.update).toHaveBeenCalledWith({ plan_id: 2 });
      expect(result.plan.id).toBe(2);
      // Ответ той же формы, что и элемент списка: с потреблением, иначе
      // после назначения тарифа клиенту пришлось бы перечитывать страницу
      // целиком, чтобы показать «сколько уже израсходовано из лимита».
      expect(result.rabbits_count).toBe(5);
      expect(result.staff_count).toBe(2);
    });
  });
});
