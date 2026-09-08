const { Farm, Plan, Rabbit, User } = require('../models');

/**
 * Платформенная админка: список ферм со сводкой по использованию и
 * назначение им тарифа. В отличие от остального сервиса, здесь нарочно
 * видно сразу все фермы — это единственное место в бэкенде, где так можно.
 */

/**
 * Что нужно знать о ферме платформенному админу помимо её названия: на каком
 * она тарифе и с кем по ней связаться. Одно и то же для списка и для одной
 * фермы, чтобы ответы этих двух эндпоинтов не расходились по форме.
 */
const FARM_INCLUDES = [
  { model: Plan, as: 'plan' },
  { model: User, as: 'owner', attributes: ['id', 'full_name', 'email', 'phone'] }
];

class PlatformAdminService {
  /** Фермы постранично, с текущим планом и фактическим потреблением. */
  async listFarms({ page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;
    const offset = (safePage - 1) * safeLimit;

    const { count, rows: farms } = await Farm.findAndCountAll({
      include: FARM_INCLUDES,
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

  /**
   * Назначить (или снять — `planId: null`) тариф ферме.
   *
   * Возвращает ферму в том же виде, в каком она приходит в списке, — вместе
   * с потреблением. Иначе после назначения тарифа клиенту негде взять
   * «сколько уже израсходовано из нового лимита», кроме перезагрузки всего
   * списка: а ответ на смену одной строки не должен стоить целой страницы.
   */
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
      // Выключенный тариф больше не выдаётся — иначе `is_active` был бы
      // флагом без последствий. Фермы, которым его уже назначили, остаются
      // на нём: выключение закрывает продажи, а не работу хозяйства.
      if (!plan.is_active) {
        throw new Error('PLAN_INACTIVE');
      }
    }

    await farm.update({ plan_id: planId });

    return this.getFarm(farmId);
  }

  /** Одна ферма с тарифом, владельцем и фактическим потреблением. */
  async getFarm(farmId) {
    const [farm, rabbitsCount, staffCount] = await Promise.all([
      Farm.findByPk(farmId, { include: FARM_INCLUDES }),
      Rabbit.count({ where: { farm_id: farmId } }),
      User.count({ where: { farm_id: farmId } })
    ]);

    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    return {
      ...farm.toJSON(),
      rabbits_count: rabbitsCount,
      staff_count: staffCount
    };
  }
}

module.exports = new PlatformAdminService();
