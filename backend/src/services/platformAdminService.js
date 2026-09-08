const { Farm, Plan, Rabbit, User } = require('../models');
const logger = require('../utils/logger');

/**
 * Платформенная админка: список ферм со сводкой по использованию и
 * назначение им тарифа. В отличие от остального сервиса, здесь нарочно
 * видно сразу все фермы — это единственное место в бэкенде, где так можно.
 */
class PlatformAdminService {
  /** Фермы постранично, с текущим планом и фактическим потреблением. */
  async listFarms({ page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;
    const offset = (safePage - 1) * safeLimit;

    const { count, rows: farms } = await Farm.findAndCountAll({
      include: [{ model: Plan, as: 'plan' }],
      order: [['created_at', 'DESC']],
      limit: safeLimit,
      offset
    });

    const farmIds = farms.map((farm) => farm.id);
    const rabbitCounts = farmIds.length
      ? await Rabbit.count({ where: { farm_id: farmIds }, group: ['farm_id'] })
      : [];
    const staffCounts = farmIds.length
      ? await User.count({ where: { farm_id: farmIds }, group: ['farm_id'] })
      : [];

    const rabbitsByFarm = Object.fromEntries(rabbitCounts.map((row) => [row.farm_id, Number(row.count)]));
    const staffByFarm = Object.fromEntries(staffCounts.map((row) => [row.farm_id, Number(row.count)]));

    return {
      items: farms.map((farm) => ({
        ...farm.toJSON(),
        rabbits_count: rabbitsByFarm[farm.id] || 0,
        staff_count: staffByFarm[farm.id] || 0
      })),
      pagination: {
        page: safePage,
        limit: safeLimit,
        total: count,
        totalPages: Math.ceil(count / safeLimit)
      }
    };
  }

  /** Назначить (или снять — `planId: null`) тариф ферме. */
  async assignPlan(farmId, planId) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    if (planId !== null) {
      const plan = await Plan.findByPk(planId);
      if (!plan) {
        throw new Error('PLAN_NOT_FOUND');
      }
    }

    await farm.update({ plan_id: planId });
    logger.info('Farm plan assigned', { farmId, planId });

    return Farm.findByPk(farmId, { include: [{ model: Plan, as: 'plan' }] });
  }
}

module.exports = new PlatformAdminService();
