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
  });

  describe('getUsage', () => {
    it('отдаёт limit: null по обоим ресурсам, если у фермы нет плана', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: null });
      Rabbit.count.mockResolvedValue(26);
      User.count.mockResolvedValue(2);

      const usage = await planService.getUsage(1);

      expect(usage).toEqual({
        rabbits: { used: 26, limit: null },
        staff: { used: 2, limit: null }
      });
    });

    it('отдаёт лимиты из плана рядом с фактическим потреблением', async () => {
      Farm.findByPk.mockResolvedValue({ id: 1, plan: { max_rabbits: 30, max_staff: null } });
      Rabbit.count.mockResolvedValue(26);
      User.count.mockResolvedValue(2);

      const usage = await planService.getUsage(1);

      expect(usage).toEqual({
        rabbits: { used: 26, limit: 30 },
        staff: { used: 2, limit: null }
      });
    });
  });
});
