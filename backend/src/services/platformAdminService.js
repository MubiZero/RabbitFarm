const { Op, fn, col } = require('sequelize');
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

const MS_PER_DAY = 24 * 60 * 60 * 1000;
const DEFAULT_INACTIVE_DAYS = 30;

/** Потребление фермы уже уперлось в предел её тарифа (по кроликам или по людям). */
function isAtLimit(farm) {
  const plan = farm.plan;
  if (!plan) return false; // без тарифа ограничений нет — упираться некуда
  const rabbitsAtLimit = plan.max_rabbits != null && farm.rabbits_count >= plan.max_rabbits;
  const staffAtLimit = plan.max_staff != null && farm.staff_count >= plan.max_staff;
  return rabbitsAtLimit || staffAtLimit;
}

class PlatformAdminService {
  /**
   * Фермы постранично, с текущим планом, фактическим потреблением и
   * последней активностью; с поиском, фильтром и сортировкой.
   *
   * Платформа — про десятки ферм, а не про миллион строк (см.
   * docs/ARCHITECTURE.md: тот же дух, что и «не рисовать MRR при нуле
   * клиентов» — не строить инфраструктуру под нагрузку, которой нет).
   * Фильтр `at_limit` и сортировки `usage`/`last_active` должны применяться
   * ДО пагинации — иначе на странице может оказаться меньше строк, чем
   * лимит, хотя подходящих на самом деле больше. Расписывать ради этого
   * коррелированные подзапросы с `HAVING` — сложность без выгоды на таком
   * масштабе: проще и надёжнее забрать все фермы, подходящие под
   * `search`/`no_plan` (это ещё обычный SQL `WHERE`), одним запросом,
   * досчитать потребление и активность, отфильтровать/отсортировать в JS —
   * и только потом нарезать страницу.
   */
  async listFarms({ page = 1, limit = 20, search, filter, sort, days } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;

    const where = {};
    if (search) {
      const like = { [Op.like]: `%${search}%` };
      where[Op.or] = [
        { name: like },
        { '$owner.full_name$': like },
        { '$owner.email$': like },
        { '$owner.phone$': like }
      ];
    }
    if (filter === 'no_plan') {
      where.plan_id = null;
    }

    const farms = await Farm.findAll({ include: FARM_INCLUDES, where });

    const farmIds = farms.map((farm) => farm.id);
    const [rabbitCounts, staffCounts, lastActiveByFarm] = await Promise.all([
      farmIds.length ? Rabbit.count({ where: { farm_id: farmIds }, group: ['farm_id'] }) : [],
      farmIds.length ? User.count({ where: { farm_id: farmIds }, group: ['farm_id'] }) : [],
      farmIds.length ? this._lastActiveByFarm(farmIds) : {}
    ]);

    const rabbitsByFarm = Object.fromEntries(rabbitCounts.map((row) => [row.farm_id, Number(row.count)]));
    const staffByFarm = Object.fromEntries(staffCounts.map((row) => [row.farm_id, Number(row.count)]));

    let items = farms.map((farm) => ({
      ...farm.toJSON(),
      rabbits_count: rabbitsByFarm[farm.id] || 0,
      staff_count: staffByFarm[farm.id] || 0,
      last_active: lastActiveByFarm[farm.id] || null
    }));

    if (filter === 'at_limit') {
      items = items.filter(isAtLimit);
    } else if (filter === 'inactive_days') {
      // Сколько дней считать «не заходили» — настраиваемо через `days`, но
      // по умолчанию месяц: чипу в мобилке не нужен пикер, чтобы включить
      // фильтр одним касанием.
      const thresholdDays = parseInt(days) || DEFAULT_INACTIVE_DAYS;
      const cutoff = Date.now() - thresholdDays * MS_PER_DAY;
      // Нет ни одного входа вообще — тоже «не заходили», и даже тревожнее
      // протухшей даты; такую ферму фильтр обязан отдавать.
      items = items.filter((farm) => !farm.last_active || new Date(farm.last_active).getTime() < cutoff);
    }

    items = this._sortFarms(items, sort);

    const total = items.length;
    const offset = (safePage - 1) * safeLimit;

    return {
      items: items.slice(offset, offset + safeLimit),
      pagination: {
        page: safePage,
        limit: safeLimit,
        total,
        totalPages: Math.ceil(total / safeLimit)
      }
    };
  }

  /** Сортировка уже посчитанных ферм — потребление и активность известны только после JS-подсчёта. */
  _sortFarms(items, sort) {
    const sorted = [...items];
    if (sort === 'usage') {
      sorted.sort((a, b) => b.rabbits_count - a.rabbits_count);
    } else if (sort === 'last_active') {
      sorted.sort((a, b) => {
        const at = a.last_active ? new Date(a.last_active).getTime() : 0;
        const bt = b.last_active ? new Date(b.last_active).getTime() : 0;
        return bt - at;
      });
    } else {
      sorted.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
    }
    return sorted;
  }

  /** `max(last_login_at)` по каждой из перечисленных ферм одним запросом. */
  async _lastActiveByFarm(farmIds) {
    const rows = await User.findAll({
      attributes: ['farm_id', [fn('MAX', col('last_login_at')), 'last_active']],
      where: { farm_id: farmIds },
      group: ['farm_id'],
      raw: true
    });
    return Object.fromEntries(rows.map((row) => [row.farm_id, row.last_active]));
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

  /** Одна ферма с тарифом, владельцем, фактическим потреблением и последней активностью. */
  async getFarm(farmId) {
    const [farm, rabbitsCount, staffCount, lastActive] = await Promise.all([
      Farm.findByPk(farmId, { include: FARM_INCLUDES }),
      Rabbit.count({ where: { farm_id: farmId } }),
      User.count({ where: { farm_id: farmId } }),
      User.max('last_login_at', { where: { farm_id: farmId } })
    ]);

    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    return {
      ...farm.toJSON(),
      rabbits_count: rabbitsCount,
      staff_count: staffCount,
      last_active: lastActive || null
    };
  }
}

module.exports = new PlatformAdminService();
