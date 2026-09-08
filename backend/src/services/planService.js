const { Plan, Farm, Rabbit, User } = require('../models');
const logger = require('../utils/logger');

/**
 * Тарифные планы и проверка лимитов фермы.
 *
 * Ферма без назначенного плана (`farms.plan_id = NULL`) — без ограничений:
 * лимиты включаются только когда платформенный админ явно назначил план.
 * Так же и с полями плана `max_rabbits`/`max_staff` — NULL в них означает
 * «без ограничения» на этот конкретный ресурс.
 */
class PlanService {
  async list() {
    return Plan.findAll({ order: [['id', 'ASC']] });
  }

  async getById(planId) {
    const plan = await Plan.findByPk(planId);
    if (!plan) {
      throw new Error('PLAN_NOT_FOUND');
    }
    return plan;
  }

  async create(data) {
    const existing = await Plan.findOne({ where: { name: data.name } });
    if (existing) {
      throw new Error('PLAN_NAME_EXISTS');
    }

    if (data.is_default) {
      await this._assertNoDefaultPlan();
    }

    const plan = await Plan.create(data);
    logger.info('Plan created', { planId: plan.id, name: plan.name });
    return plan;
  }

  async update(planId, data) {
    const plan = await this.getById(planId);

    if (data.name && data.name !== plan.name) {
      const existing = await Plan.findOne({ where: { name: data.name } });
      if (existing) {
        throw new Error('PLAN_NAME_EXISTS');
      }
    }

    if (data.is_default && !plan.is_default) {
      await this._assertNoDefaultPlan();
    }

    await plan.update(data);
    logger.info('Plan updated', { planId });
    return plan;
  }

  /**
   * Бросает `DEFAULT_PLAN_EXISTS`, если default уже назначен другому тарифу.
   * Осознанное решение: второй `is_default` не проходит молча переключая
   * старый — админ должен сперва явно снять флаг со старого тарифа.
   */
  async _assertNoDefaultPlan() {
    const existingDefault = await Plan.findOne({ where: { is_default: true } });
    if (existingDefault) {
      throw new Error('DEFAULT_PLAN_EXISTS');
    }
  }

  /** Удаление плана не трогает фермы — они просто становятся безлимитными. */
  async delete(planId) {
    const plan = await this.getById(planId);
    await plan.destroy();
    logger.info('Plan deleted', { planId });
    return { success: true };
  }

  /**
   * Тариф, который автоматически достаётся новой ферме при регистрации.
   * `null`, если такого тарифа ещё не завели через админку.
   */
  async getDefault() {
    return Plan.findOne({ where: { is_default: true } });
  }

  /**
   * `true`, если у платного тарифа фермы истёк срок действия. Бесплатный
   * тариф по умолчанию бессрочен (`plan_expires_at = null`), поэтому такая
   * ферма никогда не просрочена.
   */
  isExpired(farm) {
    if (!farm?.plan_expires_at) return false;
    return new Date(farm.plan_expires_at) < new Date();
  }

  /** Ферма вместе с её текущим планом — единая точка для проверок лимита. */
  async _getFarmWithPlan(farmId) {
    return Farm.findByPk(farmId, { include: [{ model: Plan, as: 'plan' }] });
  }

  /**
   * Бросает `RABBIT_LIMIT_REACHED`, если по тарифу фермы больше нельзя
   * заводить кроликов. Вызывается перед созданием кролика.
   */
  async assertRabbitLimit(farmId) {
    const farm = await this._getFarmWithPlan(farmId);
    const maxRabbits = farm?.plan?.max_rabbits;
    if (!maxRabbits) return;

    const count = await Rabbit.count({ where: { farm_id: farmId } });
    if (count >= maxRabbits) {
      throw new Error('RABBIT_LIMIT_REACHED');
    }
  }

  /**
   * Бросает `STAFF_LIMIT_REACHED`, если по тарифу фермы больше нельзя
   * добавлять участников. Вызывается перед приглашением и перед его
   * активацией — приглашение не должно уводить в тупик, если за время его
   * действия ферма уже упёрлась в лимит.
   */
  async assertStaffLimit(farmId) {
    const farm = await this._getFarmWithPlan(farmId);
    const maxStaff = farm?.plan?.max_staff;
    if (!maxStaff) return;

    const count = await User.count({ where: { farm_id: farmId } });
    if (count >= maxStaff) {
      throw new Error('STAFF_LIMIT_REACHED');
    }
  }
}

module.exports = new PlanService();
