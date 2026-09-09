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

// Один платёж продлевает платный тариф на фиксированный период, а не на
// календарный месяц (см. docs/plans/PLATFORM-ADMIN.md, 4.1) — минимум вместо
// полного аппарата подписок с пропорциональным пересчётом.
const RENEWAL_PERIOD_DAYS = 30;

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

  /**
   * `true`, если у тарифа нет цены — то есть он бесплатный.
   *
   * `price` — MySQL DECIMAL, mysql2 без `decimalNumbers: true` (см.
   * src/config/database.js) отдаёт его строкой ("0.00"), а не числом.
   * Наивное `!plan.price` ошибается ровно на явном нуле: непустая строка
   * truthy, и «бесплатный» тариф с ценой, вписанной буквально как 0 (а не
   * оставленной пустой), читался бы как платный. Единая точка для всех
   * мест, которым нужно решить «платить за это или нет» — расхождение
   * между ними уже однажды приводило к тому, что одна и та же ферма
   * считалась то бесплатной, то платной в зависимости от того, кто спрашивал.
   */
  isPlanFree(plan) {
    return plan.price == null || Number(plan.price) === 0;
  }

  /** Ферма вместе с её текущим планом — единая точка для проверок лимита. */
  async _getFarmWithPlan(farmId) {
    return Farm.findByPk(farmId, { include: [{ model: Plan, as: 'plan' }] });
  }

  /**
   * Предел ресурса с учётом активной разовой поблажки (см.
   * docs/plans/PLATFORM-ADMIN.md, 2.3). `null` — лимита нет вовсе (ни у
   * тарифа, ни у фермы без тарифа).
   *
   * Поблажка не расширяет «нет лимита»: если у тарифа `max_*` уже NULL,
   * складывать с ним нечего. Пустой `extras_until` при ненулевой поблажке —
   * «бессрочно», как и у `plan_expires_at`.
   */
  getEffectiveLimit(farm, resource) {
    const planLimit = resource === 'rabbits' ? farm?.plan?.max_rabbits : farm?.plan?.max_staff;
    if (planLimit == null) return null;

    const extra = resource === 'rabbits' ? farm.extra_rabbits : farm.extra_staff;
    if (!extra) return planLimit;

    const extraActive = !farm.extras_until || new Date(farm.extras_until) > new Date();
    return extraActive ? planLimit + extra : planLimit;
  }

  /**
   * Бросает `RABBIT_LIMIT_REACHED`, если по тарифу фермы больше нельзя
   * заводить кроликов. Вызывается перед созданием кролика.
   */
  async assertRabbitLimit(farmId) {
    const farm = await this._getFarmWithPlan(farmId);
    const maxRabbits = this.getEffectiveLimit(farm, 'rabbits');
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
    const maxStaff = this.getEffectiveLimit(farm, 'staff');
    if (!maxStaff) return;

    const count = await User.count({ where: { farm_id: farmId } });
    if (count >= maxStaff) {
      throw new Error('STAFF_LIMIT_REACHED');
    }
  }

  /**
   * Фактическое потребление фермы против пределов её тарифа — для сводки
   * «Сегодня» самой фермы («26 из 30 кроликов»). Считает теми же запросами,
   * что и проверки лимита выше (без фильтра по статусу кролика), чтобы число
   * на экране не расходилось с моментом, когда сервер реально откажет.
   * `limit: null` — без ограничения, как и везде в этом сервисе; сам предел
   * эффективный, то есть уже с разовой поблажкой, — иначе полоса на
   * «Сегодня» показывала бы «26 из 30» ферме, которой продажи выдали +50.
   */
  async getUsage(farmId) {
    const [farm, rabbitsUsed, staffUsed] = await Promise.all([
      this._getFarmWithPlan(farmId),
      Rabbit.count({ where: { farm_id: farmId } }),
      User.count({ where: { farm_id: farmId } })
    ]);

    return {
      rabbits: { used: rabbitsUsed, limit: this.getEffectiveLimit(farm, 'rabbits') },
      staff: { used: staffUsed, limit: this.getEffectiveLimit(farm, 'staff') },
      plan: farm?.plan
        ? {
            id: farm.plan.id,
            name: farm.plan.name,
            price: farm.plan.price,
            expires_at: farm.plan_expires_at,
            is_expired: this.isExpired(farm)
          }
        : null
    };
  }

  /**
   * Сколько ферме заплатить за продление текущего тарифа (см.
   * docs/plans/PLATFORM-ADMIN.md, 4.1). Сумму считает сервер по тарифу
   * фермы, а не берёт из тела запроса — иначе платящий сам бы назначал
   * себе цену.
   */
  async getRenewalQuote(farmId) {
    const farm = await this._getFarmWithPlan(farmId);
    if (!farm?.plan) {
      throw new Error('NO_PLAN');
    }
    if (this.isPlanFree(farm.plan)) {
      throw new Error('PLAN_FREE');
    }

    return {
      amount: farm.plan.price,
      description: `Тариф «${farm.plan.name}»`
    };
  }

  /**
   * Продлить платный тариф фермы после подтверждённой оплаты (см. 4.1).
   * От текущего срока, если он ещё не истёк, иначе от «сейчас» — досрочная
   * оплата не теряет уже оплаченное время.
   *
   * Ничего не делает, если у фермы уже нет платного тарифа: между созданием
   * платежа и его подтверждением админ мог снять план или назначить
   * бесплатный — деньги пришли, но продлевать нечего, это разбирается
   * вручную, а не тихо продлевает не тот тариф.
   */
  async extendPlanExpiry(farmId) {
    const farm = await this._getFarmWithPlan(farmId);
    if (!farm?.plan || this.isPlanFree(farm.plan)) {
      logger.warn('Payment completed but farm has no billable plan to extend', { farmId });
      return null;
    }

    const now = new Date();
    const base = farm.plan_expires_at && new Date(farm.plan_expires_at) > now
      ? new Date(farm.plan_expires_at)
      : now;
    const expiresAt = new Date(base.getTime() + RENEWAL_PERIOD_DAYS * 24 * 60 * 60 * 1000);

    await farm.update({ plan_expires_at: expiresAt });
    logger.info('Plan expiry extended after payment', { farmId, expiresAt });
    return expiresAt;
  }
}

module.exports = new PlanService();
