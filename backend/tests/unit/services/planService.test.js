jest.mock('../../../src/models', () => ({
  Plan: {
    findAll: jest.fn(),
    findByPk: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn()
  },
  Farm: {
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

const { Plan, Farm, Rabbit, User } = require('../../../src/models');
const planService = require('../../../src/services/planService');

describe('PlanService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('бросает PLAN_NAME_EXISTS, если тариф с таким именем уже есть', async () => {
      Plan.findOne.mockResolvedValue({ id: 1 });

      await expect(planService.create({ name: 'Pro' })).rejects.toThrow('PLAN_NAME_EXISTS');
      expect(Plan.create).not.toHaveBeenCalled();
    });

    it('создаёт тариф, если имя свободно', async () => {
      Plan.findOne.mockResolvedValue(null);
      Plan.create.mockResolvedValue({ id: 1, name: 'Pro' });

      const plan = await planService.create({ name: 'Pro', max_rabbits: 100 });

      expect(plan.id).toBe(1);
      expect(Plan.create).toHaveBeenCalledWith({ name: 'Pro', max_rabbits: 100 });
    });

    it('бросает DEFAULT_PLAN_EXISTS, если пытаются сделать вторым default', async () => {
      // Первый findOne — проверка имени, второй — проверка на существующий default.
      Plan.findOne
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce({ id: 1, name: 'Free', is_default: true });

      await expect(planService.create({ name: 'Pro', is_default: true }))
        .rejects.toThrow('DEFAULT_PLAN_EXISTS');
      expect(Plan.create).not.toHaveBeenCalled();
    });

    it('создаёт default-тариф, если другого default ещё нет', async () => {
      Plan.findOne.mockResolvedValueOnce(null).mockResolvedValueOnce(null);
      Plan.create.mockResolvedValue({ id: 1, name: 'Free', is_default: true });

      const plan = await planService.create({ name: 'Free', is_default: true });

      expect(plan.is_default).toBe(true);
    });
  });

  describe('update / delete', () => {
    it('бросает PLAN_NOT_FOUND при правке несуществующего тарифа', async () => {
      Plan.findByPk.mockResolvedValue(null);

      await expect(planService.update(999, { name: 'X' })).rejects.toThrow('PLAN_NOT_FOUND');
    });

    it('удаление тарифа не трогает фермы — только сам план', async () => {
      const plan = { id: 1, destroy: jest.fn().mockResolvedValue(undefined) };
      Plan.findByPk.mockResolvedValue(plan);

      const result = await planService.delete(1);

      expect(plan.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('бросает DEFAULT_PLAN_EXISTS, если другой тариф уже default', async () => {
      const plan = { id: 2, name: 'Pro', is_default: false, update: jest.fn() };
      Plan.findByPk.mockResolvedValue(plan);
      Plan.findOne.mockResolvedValue({ id: 1, name: 'Free', is_default: true });

      await expect(planService.update(2, { is_default: true }))
        .rejects.toThrow('DEFAULT_PLAN_EXISTS');
      expect(plan.update).not.toHaveBeenCalled();
    });

    it('не проверяет на дубль default, если тариф и так уже default', async () => {
      const plan = { id: 1, name: 'Free', is_default: true, update: jest.fn().mockResolvedValue(undefined) };
      Plan.findByPk.mockResolvedValue(plan);

      await planService.update(1, { is_default: true, price: 10 });

      expect(Plan.findOne).not.toHaveBeenCalled();
      expect(plan.update).toHaveBeenCalledWith({ is_default: true, price: 10 });
    });
  });

  describe('getDefault', () => {
    it('возвращает тариф с is_default: true', async () => {
      const plan = { id: 1, name: 'Free', is_default: true };
      Plan.findOne.mockResolvedValue(plan);

      await expect(planService.getDefault()).resolves.toBe(plan);
      expect(Plan.findOne).toHaveBeenCalledWith({ where: { is_default: true } });
    });

    it('возвращает null, если дефолтного тарифа нет', async () => {
      Plan.findOne.mockResolvedValue(null);

      await expect(planService.getDefault()).resolves.toBeNull();
    });
  });

  describe('isExpired', () => {
    it('false, если у фермы нет срока действия (бесплатный тариф)', () => {
      expect(planService.isExpired({ plan_expires_at: null })).toBe(false);
    });

    it('true, если срок действия в прошлом', () => {
      expect(planService.isExpired({ plan_expires_at: '2020-01-01' })).toBe(true);
    });

    it('false, если срок действия в будущем', () => {
      const future = new Date(Date.now() + 1000 * 60 * 60 * 24 * 365 * 10).toISOString();
      expect(planService.isExpired({ plan_expires_at: future })).toBe(false);
    });
  });

  describe('getEffectiveLimit', () => {
    const future = () => new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

    it('null, если у фермы нет тарифа', () => {
      expect(planService.getEffectiveLimit({ plan: null }, 'rabbits')).toBeNull();
      expect(planService.getEffectiveLimit(null, 'staff')).toBeNull();
    });

    it('null, если у тарифа предел не задан — поблажка не расширяет «нет лимита»', () => {
      const farm = { plan: { max_rabbits: null }, extra_rabbits: 50, extras_until: future() };

      expect(planService.getEffectiveLimit(farm, 'rabbits')).toBeNull();
    });

    it('предел тарифа, если поблажки нет', () => {
      const farm = { plan: { max_rabbits: 30, max_staff: 2 }, extra_rabbits: null, extra_staff: null };

      expect(planService.getEffectiveLimit(farm, 'rabbits')).toBe(30);
      expect(planService.getEffectiveLimit(farm, 'staff')).toBe(2);
    });

    it('складывает активную поблажку с пределом тарифа', () => {
      const farm = {
        plan: { max_rabbits: 30, max_staff: 2 },
        extra_rabbits: 50,
        extra_staff: 1,
        extras_until: future()
      };

      expect(planService.getEffectiveLimit(farm, 'rabbits')).toBe(80);
      expect(planService.getEffectiveLimit(farm, 'staff')).toBe(3);
    });

    it('считает поблажку без срока бессрочной, а не просроченной', () => {
      const farm = { plan: { max_rabbits: 30 }, extra_rabbits: 50, extras_until: null };

      expect(planService.getEffectiveLimit(farm, 'rabbits')).toBe(80);
    });

    it('не учитывает истёкшую поблажку', () => {
      const farm = { plan: { max_rabbits: 30 }, extra_rabbits: 50, extras_until: '2020-01-01' };

      expect(planService.getEffectiveLimit(farm, 'rabbits')).toBe(30);
    });
  });

  describe('assertRabbitLimit', () => {
    it('не бросает, если у фермы нет плана', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: null });

      await expect(planService.assertRabbitLimit(1)).resolves.toBeUndefined();
      expect(Rabbit.count).not.toHaveBeenCalled();
    });

    it('не бросает, если у плана лимит не задан (max_rabbits = null)', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { max_rabbits: null } });

      await expect(planService.assertRabbitLimit(1)).resolves.toBeUndefined();
      expect(Rabbit.count).not.toHaveBeenCalled();
    });

    it('бросает RABBIT_LIMIT_REACHED, если количество кроликов достигло лимита', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { max_rabbits: 10 } });
      Rabbit.count.mockResolvedValue(10);

      await expect(planService.assertRabbitLimit(1)).rejects.toThrow('RABBIT_LIMIT_REACHED');
    });

    it('не бросает, если лимит ещё не достигнут', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { max_rabbits: 10 } });
      Rabbit.count.mockResolvedValue(9);

      await expect(planService.assertRabbitLimit(1)).resolves.toBeUndefined();
    });

    it('не бросает при упоре в предел тарифа, если действует поблажка', async () => {
      const future = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan: { max_rabbits: 10 },
        extra_rabbits: 5,
        extras_until: future
      });
      Rabbit.count.mockResolvedValue(12);

      await expect(planService.assertRabbitLimit(1)).resolves.toBeUndefined();
    });

    it('бросает, когда поблажка истекла и предел снова тарифный', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan: { max_rabbits: 10 },
        extra_rabbits: 5,
        extras_until: '2020-01-01'
      });
      Rabbit.count.mockResolvedValue(12);

      await expect(planService.assertRabbitLimit(1)).rejects.toThrow('RABBIT_LIMIT_REACHED');
    });

    it('бросает при упоре уже в расширенный поблажкой предел', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan: { max_rabbits: 10 },
        extra_rabbits: 5,
        extras_until: null
      });
      Rabbit.count.mockResolvedValue(15);

      await expect(planService.assertRabbitLimit(1)).rejects.toThrow('RABBIT_LIMIT_REACHED');
    });
  });

  describe('assertStaffLimit', () => {
    it('бросает STAFF_LIMIT_REACHED, если состав фермы достиг лимита', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { max_staff: 3 } });
      User.count.mockResolvedValue(3);

      await expect(planService.assertStaffLimit(1)).rejects.toThrow('STAFF_LIMIT_REACHED');
    });

    it('не бросает, если у фермы нет плана', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: null });

      await expect(planService.assertStaffLimit(1)).resolves.toBeUndefined();
      expect(User.count).not.toHaveBeenCalled();
    });

    it('не бросает при упоре в предел тарифа, если действует поблажка по людям', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { max_staff: 3 }, extra_staff: 2, extras_until: null });
      User.count.mockResolvedValue(3);

      await expect(planService.assertStaffLimit(1)).resolves.toBeUndefined();
    });

    it('бросает, когда поблажка по людям истекла', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan: { max_staff: 3 },
        extra_staff: 2,
        extras_until: '2020-01-01'
      });
      User.count.mockResolvedValue(3);

      await expect(planService.assertStaffLimit(1)).rejects.toThrow('STAFF_LIMIT_REACHED');
    });
  });

  describe('getUsage', () => {
    it('отдаёт limit: null по обоим ресурсам, если у фермы нет плана', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: null });
      Rabbit.count.mockResolvedValue(26);
      User.count.mockResolvedValue(2);

      const usage = await planService.getUsage(1);

      expect(usage).toEqual({
        rabbits: { used: 26, limit: null },
        staff: { used: 2, limit: null },
        plan: null
      });
    });

    it('отдаёт лимиты из плана рядом с фактическим потреблением', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan_id: 7,
        plan_expires_at: null,
        plan: { id: 7, name: 'Базовый', price: 50, max_rabbits: 30, max_staff: null }
      });
      Rabbit.count.mockResolvedValue(26);
      User.count.mockResolvedValue(2);

      const usage = await planService.getUsage(1);

      expect(usage).toEqual({
        rabbits: { used: 26, limit: 30 },
        staff: { used: 2, limit: null },
        plan: { id: 7, name: 'Базовый', price: 50, expires_at: null, is_expired: false }
      });
    });

    it('показывает предел уже с активной поблажкой, а не голый тарифный', async () => {
      const future = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan_id: 7,
        plan_expires_at: null,
        plan: { id: 7, name: 'Базовый', price: 50, max_rabbits: 30, max_staff: 2 },
        extra_rabbits: 50,
        extra_staff: 1,
        extras_until: future
      });
      Rabbit.count.mockResolvedValue(40);
      User.count.mockResolvedValue(2);

      const usage = await planService.getUsage(1);

      expect(usage).toEqual({
        rabbits: { used: 40, limit: 80 },
        staff: { used: 2, limit: 3 },
        plan: { id: 7, name: 'Базовый', price: 50, expires_at: null, is_expired: false }
      });
    });

    it('возвращает тарифный предел, если поблажка истекла', async () => {
      Farm.findByPk.mockResolvedValue({
        id: 1,
        plan: { max_rabbits: 30, max_staff: 2 },
        extra_rabbits: 50,
        extras_until: '2020-01-01'
      });
      Rabbit.count.mockResolvedValue(40);
      User.count.mockResolvedValue(2);

      const usage = await planService.getUsage(1);

      expect(usage.rabbits.limit).toBe(30);
      expect(usage.staff.limit).toBe(2);
    });
  });

  describe('isPlanFree', () => {
    it('тариф без цены (null) — бесплатный', () => {
      expect(planService.isPlanFree({ price: null })).toBe(true);
    });

    it('тариф с ценой ровно 0 — бесплатный, даже если price пришёл строкой из MySQL DECIMAL', () => {
      // mysql2 без decimalNumbers: true (см. src/config/database.js) отдаёт
      // DECIMAL строкой — наивное `!price` ошиблось бы здесь: "0.00" truthy.
      expect(planService.isPlanFree({ price: '0.00' })).toBe(true);
      expect(planService.isPlanFree({ price: 0 })).toBe(true);
    });

    it('тариф с ненулевой ценой — не бесплатный, строка или число одинаково', () => {
      expect(planService.isPlanFree({ price: '50.00' })).toBe(false);
      expect(planService.isPlanFree({ price: 50 })).toBe(false);
    });
  });

  describe('getRenewalQuote', () => {
    it('бросает NO_PLAN, если ферме не назначен тариф', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: null });

      await expect(planService.getRenewalQuote(1)).rejects.toThrow('NO_PLAN');
    });

    it('бросает PLAN_FREE, если у тарифа нет цены', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { name: 'Бесплатный', price: null } });

      await expect(planService.getRenewalQuote(1)).rejects.toThrow('PLAN_FREE');
    });

    it('бросает PLAN_FREE и для тарифа с ценой ровно 0, пришедшей строкой из MySQL', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { name: 'Бесплатный', price: '0.00' } });

      await expect(planService.getRenewalQuote(1)).rejects.toThrow('PLAN_FREE');
    });

    it('считает сумму и описание по тарифу фермы, а не по телу запроса', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { name: 'Базовый', price: 50 } });

      const quote = await planService.getRenewalQuote(1);

      expect(quote).toEqual({ amount: 50, description: 'Тариф «Базовый»', plan: 'Базовый' });
    });
  });

  describe('extendPlanExpiry', () => {
    it('ничего не делает, если у фермы уже нет платного тарифа', async () => {
      const farm = { id: 1, plan: null, update: jest.fn() };
      Farm.findByPk.mockResolvedValue(farm);

      const result = await planService.extendPlanExpiry(1);

      expect(result).toBeNull();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('ничего не делает и для тарифа с ценой ровно 0, пришедшей строкой из MySQL', async () => {
      const farm = { id: 1, plan: { price: '0.00' }, update: jest.fn() };
      Farm.findByPk.mockResolvedValue(farm);

      const result = await planService.extendPlanExpiry(1);

      expect(result).toBeNull();
      expect(farm.update).not.toHaveBeenCalled();
    });

    it('продлевает от текущего срока, если он ещё не истёк', async () => {
      const future = new Date(Date.now() + 5 * 24 * 60 * 60 * 1000);
      const farm = {
        id: 1,
        plan: { price: 50 },
        plan_expires_at: future.toISOString(),
        update: jest.fn().mockResolvedValue(undefined)
      };
      Farm.findByPk.mockResolvedValue(farm);

      const result = await planService.extendPlanExpiry(1);

      const expected = new Date(future.getTime() + 30 * 24 * 60 * 60 * 1000);
      expect(result.getTime()).toBe(expected.getTime());
      expect(farm.update).toHaveBeenCalledWith({ plan_expires_at: result });
    });

    it('продлевает от «сейчас», если срок уже истёк', async () => {
      const past = new Date(Date.now() - 5 * 24 * 60 * 60 * 1000);
      const farm = {
        id: 1,
        plan: { price: 50 },
        plan_expires_at: past.toISOString(),
        update: jest.fn().mockResolvedValue(undefined)
      };
      Farm.findByPk.mockResolvedValue(farm);

      const before = Date.now();
      const result = await planService.extendPlanExpiry(1);
      const after = Date.now();

      const minExpected = before + 30 * 24 * 60 * 60 * 1000;
      const maxExpected = after + 30 * 24 * 60 * 60 * 1000;
      expect(result.getTime()).toBeGreaterThanOrEqual(minExpected);
      expect(result.getTime()).toBeLessThanOrEqual(maxExpected);
    });
  });
});
