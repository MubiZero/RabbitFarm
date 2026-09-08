jest.mock('../../../src/models', () => ({
  Farm: {
    findAll: jest.fn(),
    findByPk: jest.fn()
  },
  Plan: {
    findByPk: jest.fn()
  },
  Rabbit: {
    count: jest.fn()
  },
  User: {
    count: jest.fn(),
    max: jest.fn(),
    findAll: jest.fn()
  }
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Op } = require('sequelize');
const { Farm, Plan, Rabbit, User } = require('../../../src/models');
const platformAdminService = require('../../../src/services/platformAdminService');

describe('PlatformAdminService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    User.findAll.mockResolvedValue([]);
  });

  describe('listFarms', () => {
    it('добавляет к каждой ферме фактическое число кроликов, участников и последнюю активность', async () => {
      const farms = [
        { id: 1, toJSON: () => ({ id: 1, name: 'Ферма 1' }) },
        { id: 2, toJSON: () => ({ id: 2, name: 'Ферма 2' }) }
      ];
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([{ farm_id: 1, count: 5 }]);
      User.count.mockResolvedValue([{ farm_id: 1, count: 2 }, { farm_id: 2, count: 1 }]);
      User.findAll.mockResolvedValue([{ farm_id: 1, last_active: '2026-08-01T00:00:00.000Z' }]);

      const result = await platformAdminService.listFarms({ page: 1, limit: 20 });

      expect(result.items).toEqual([
        { id: 1, name: 'Ферма 1', rabbits_count: 5, staff_count: 2, last_active: '2026-08-01T00:00:00.000Z' },
        { id: 2, name: 'Ферма 2', rabbits_count: 0, staff_count: 1, last_active: null }
      ]);
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 2, totalPages: 1 });
    });

    it('запрашивает вместе с фермой её тариф и владельца', async () => {
      Farm.findAll.mockResolvedValue([]);

      await platformAdminService.listFarms();

      const { include } = Farm.findAll.mock.calls[0][0];
      expect(include).toEqual(expect.arrayContaining([
        expect.objectContaining({ as: 'plan' }),
        expect.objectContaining({ as: 'owner' })
      ]));
    });

    it('не запрашивает счётчики, если ферм нет', async () => {
      Farm.findAll.mockResolvedValue([]);

      const result = await platformAdminService.listFarms();

      expect(Rabbit.count).not.toHaveBeenCalled();
      expect(User.count).not.toHaveBeenCalled();
      expect(User.findAll).not.toHaveBeenCalled();
      expect(result.items).toEqual([]);
    });

    it('ищет по названию фермы или контактам владельца', async () => {
      Farm.findAll.mockResolvedValue([]);

      await platformAdminService.listFarms({ search: 'Иванов' });

      const { where } = Farm.findAll.mock.calls[0][0];
      expect(where[Op.or]).toEqual([
        { name: { [Op.like]: '%Иванов%' } },
        { '$owner.full_name$': { [Op.like]: '%Иванов%' } },
        { '$owner.email$': { [Op.like]: '%Иванов%' } },
        { '$owner.phone$': { [Op.like]: '%Иванов%' } }
      ]);
    });

    it('фильтр no_plan отбирает фермы без тарифа на уровне SQL', async () => {
      Farm.findAll.mockResolvedValue([]);

      await platformAdminService.listFarms({ filter: 'no_plan' });

      expect(Farm.findAll.mock.calls[0][0].where).toEqual({ plan_id: null });
    });

    it('фильтр at_limit оставляет только фермы, упёршиеся в предел тарифа', async () => {
      const farms = [
        { id: 1, toJSON: () => ({ id: 1, plan: { max_rabbits: 10, max_staff: null } }) },
        { id: 2, toJSON: () => ({ id: 2, plan: { max_rabbits: 10, max_staff: null } }) },
        { id: 3, toJSON: () => ({ id: 3, plan: null }) }
      ];
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([{ farm_id: 1, count: 10 }, { farm_id: 2, count: 3 }, { farm_id: 3, count: 999 }]);
      User.count.mockResolvedValue([]);

      const result = await platformAdminService.listFarms({ filter: 'at_limit' });

      // Ферма 1 упёрлась в лимит кроликов, ферма 3 без тарифа — ограничений
      // для неё нет, сколько бы кроликов ни было.
      expect(result.items.map((farm) => farm.id)).toEqual([1]);
    });

    it('фильтр inactive_days отбирает фермы без входов дольше N дней, включая тех, кто не заходил вовсе', async () => {
      const oldDate = new Date(Date.now() - 60 * 24 * 60 * 60 * 1000).toISOString();
      const recentDate = new Date().toISOString();
      const farms = [
        { id: 1, toJSON: () => ({ id: 1 }) },
        { id: 2, toJSON: () => ({ id: 2 }) },
        { id: 3, toJSON: () => ({ id: 3 }) }
      ];
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([]);
      User.count.mockResolvedValue([]);
      User.findAll.mockResolvedValue([
        { farm_id: 1, last_active: oldDate },
        { farm_id: 2, last_active: recentDate }
        // farm 3 вообще не встречается — ни разу не заходили
      ]);

      const result = await platformAdminService.listFarms({ filter: 'inactive_days', days: 30 });

      expect(result.items.map((farm) => farm.id).sort()).toEqual([1, 3]);
    });

    it('сортировка usage ставит фермы с наибольшим потреблением кроликов сверху', async () => {
      const farms = [
        { id: 1, toJSON: () => ({ id: 1 }) },
        { id: 2, toJSON: () => ({ id: 2 }) }
      ];
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([{ farm_id: 1, count: 3 }, { farm_id: 2, count: 8 }]);
      User.count.mockResolvedValue([]);

      const result = await platformAdminService.listFarms({ sort: 'usage' });

      expect(result.items.map((farm) => farm.id)).toEqual([2, 1]);
    });

    it('сортировка last_active ставит недавно заходивших сверху', async () => {
      const farms = [
        { id: 1, toJSON: () => ({ id: 1 }) },
        { id: 2, toJSON: () => ({ id: 2 }) }
      ];
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([]);
      User.count.mockResolvedValue([]);
      User.findAll.mockResolvedValue([
        { farm_id: 1, last_active: '2026-01-01T00:00:00.000Z' },
        { farm_id: 2, last_active: '2026-08-01T00:00:00.000Z' }
      ]);

      const result = await platformAdminService.listFarms({ sort: 'last_active' });

      expect(result.items.map((farm) => farm.id)).toEqual([2, 1]);
    });

    it('по умолчанию сортирует по дате создания, новые сверху', async () => {
      const farms = [
        { id: 1, toJSON: () => ({ id: 1, created_at: '2026-01-01T00:00:00.000Z' }) },
        { id: 2, toJSON: () => ({ id: 2, created_at: '2026-08-01T00:00:00.000Z' }) }
      ];
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([]);
      User.count.mockResolvedValue([]);

      const result = await platformAdminService.listFarms();

      expect(result.items.map((farm) => farm.id)).toEqual([2, 1]);
    });

    it('фильтрует и сортирует до пагинации, а не после', async () => {
      // 3 фермы упёрлись в лимит, лимит страницы — 2: вторая страница
      // должна отдать оставшуюся третью, а не быть пустой.
      const farms = Array.from({ length: 3 }, (_, i) => ({
        id: i + 1,
        toJSON: () => ({ id: i + 1, plan: { max_rabbits: 5, max_staff: null } })
      }));
      Farm.findAll.mockResolvedValue(farms);
      Rabbit.count.mockResolvedValue([{ farm_id: 1, count: 5 }, { farm_id: 2, count: 5 }, { farm_id: 3, count: 5 }]);
      User.count.mockResolvedValue([]);

      const result = await platformAdminService.listFarms({ filter: 'at_limit', page: 2, limit: 2 });

      expect(result.pagination).toEqual({ page: 2, limit: 2, total: 3, totalPages: 2 });
      expect(result.items.map((farm) => farm.id)).toEqual([3]);
    });
  });

  describe('getFarm', () => {
    it('отдаёт ферму вместе с её фактическим потреблением и последней активностью', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 7,
        toJSON: () => ({ id: 7, name: 'Ферма 7', plan: { id: 2 } })
      });
      Rabbit.count.mockResolvedValue(12);
      User.count.mockResolvedValue(3);
      User.max.mockResolvedValue('2026-08-01T00:00:00.000Z');

      const farm = await platformAdminService.getFarm(7);

      expect(farm).toEqual({
        id: 7,
        name: 'Ферма 7',
        plan: { id: 2 },
        rabbits_count: 12,
        staff_count: 3,
        last_active: '2026-08-01T00:00:00.000Z'
      });
    });

    it('отдаёт last_active = null, если у фермы ещё никто не заходил', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 7,
        toJSON: () => ({ id: 7, name: 'Ферма 7' })
      });
      Rabbit.count.mockResolvedValue(0);
      User.count.mockResolvedValue(1);
      User.max.mockResolvedValue(null);

      const farm = await platformAdminService.getFarm(7);

      expect(farm.last_active).toBeNull();
    });

    it('бросает FARM_NOT_FOUND для несуществующей фермы', async () => {
      Farm.findByPk.mockResolvedValue(null);
      Rabbit.count.mockResolvedValue(0);
      User.count.mockResolvedValue(0);
      User.max.mockResolvedValue(null);

      await expect(platformAdminService.getFarm(999)).rejects.toThrow('FARM_NOT_FOUND');
    });
  });

  describe('assignPlan', () => {
    beforeEach(() => {
      User.max.mockResolvedValue(null);
    });

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
