const { Op, fn, col } = require('sequelize');
const { Farm, Payment, Photo, Plan, Rabbit, User } = require('../models');
const planService = require('./planService');
const JWTUtil = require('../utils/jwt');

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

/**
 * Потребление фермы уже уперлось в предел её тарифа (по кроликам или по людям).
 *
 * Предел берём у `planService` — тот же, по которому сервер реально откажет:
 * ферма с активной поблажкой ещё не упёрлась, и в фильтре «упёрлась в предел»
 * её быть не должно, иначе админ пойдёт разбираться с тем, чего нет.
 */
function isAtLimit(farm) {
  if (!farm.plan) return false; // без тарифа ограничений нет — упираться некуда
  const rabbitsLimit = planService.getEffectiveLimit(farm, 'rabbits');
  const staffLimit = planService.getEffectiveLimit(farm, 'staff');
  const rabbitsAtLimit = rabbitsLimit != null && farm.rabbits_count >= rabbitsLimit;
  const staffAtLimit = staffLimit != null && farm.staff_count >= staffLimit;
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
    // Мягко удалённые фермы (см. 2.4) не засоряют обычный список: их видно
    // только в собственном режиме просмотра `deleted` — он же единственный
    // способ заметить, что уходит на физическую зачистку, и успеть вернуть
    // удалённое по ошибке.
    if (filter === 'deleted') {
      where.deleted_at = { [Op.ne]: null };
    } else {
      where.deleted_at = null;
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
    } else if (filter === 'suspended') {
      items = items.filter((farm) => farm.status === 'suspended');
    } else if (filter === 'expired') {
      // Тот же `isExpired`, по которому решается судьба доступа фермы, — иначе
      // «просрочена» в админке и «просрочена» в проверке лимитов разошлись бы.
      items = items.filter((farm) => planService.isExpired(farm));
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

    // В режиме удалённых порядок задан самим смыслом экрана: срок до
    // физической зачистки идёт от даты удаления, поэтому свежеудалённые
    // сверху, а не «новые по дате создания».
    items = filter === 'deleted'
      ? [...items].sort((a, b) => new Date(b.deleted_at).getTime() - new Date(a.deleted_at).getTime())
      : this._sortFarms(items, sort);

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

  /**
   * Одна ферма со всем, что нужно карточке клиента (см.
   * docs/plans/PLATFORM-ADMIN.md, 2.1): тариф, владелец, потребление,
   * последняя активность, состав с ролями и входами, последние платежи и
   * занятое фотографиями место.
   *
   * Все запросы уходят вместе: карточка открывается одним движением, и
   * последовательная цепочка из семи запросов растянула бы её открытие на
   * сумму задержек вместо самой долгой из них.
   */
  async getFarm(farmId) {
    const [farm, rabbitsCount, staffCount, lastActive, staff, payments, photoBytes, rabbitPhotoBytes] =
      await Promise.all([
        Farm.findByPk(farmId, { include: FARM_INCLUDES }),
        Rabbit.count({ where: { farm_id: farmId } }),
        User.count({ where: { farm_id: farmId } }),
        User.max('last_login_at', { where: { farm_id: farmId } }),
        User.findAll({
          where: { farm_id: farmId },
          attributes: ['id', 'full_name', 'email', 'phone', 'role', 'is_active', 'last_login_at'],
          order: [['id', 'ASC']]
        }),
        // Двадцати хватает, чтобы увидеть историю оплат клиента; вся история
        // на карточке не нужна, а у эндпоинта нет пагинации.
        // Без raw_response — сырой ответ банка тяжёлый и ему нечего делать
        // в ответе на просмотр карточки клиента.
        Payment.findAll({
          where: { farm_id: farmId },
          attributes: ['id', 'amount', 'currency', 'status', 'description', 'created_at'],
          order: [['created_at', 'DESC']],
          limit: 20
        }),
        // Место считается по двум таблицам: фото галереи и одиночное фото
        // кролика лежат отдельно (см. 1.6). SUM по пустой выборке — NULL.
        Photo.sum('size_bytes', { where: { farm_id: farmId } }),
        Rabbit.sum('photo_size_bytes', { where: { farm_id: farmId } })
      ]);

    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    return {
      ...farm.toJSON(),
      rabbits_count: rabbitsCount,
      staff_count: staffCount,
      last_active: lastActive || null,
      staff,
      payments,
      storage_bytes: (photoBytes || 0) + (rabbitPhotoBytes || 0)
    };
  }

  /**
   * Сменить статус доступа фермы (`active` / `read_only` / `suspended`) —
   * см. docs/plans/PLATFORM-ADMIN.md, 2.2. Ответ той же формы, что и везде
   * в этом сервисе, чтобы клиент обновил карточку, а не перечитывал её.
   */
  async updateStatus(farmId, status) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    await farm.update({ status });

    return this.getFarm(farmId);
  }

  /**
   * Продлить платный тариф вручную (см. docs/plans/PLATFORM-ADMIN.md, 4.1) —
   * например, клиент оплатил наличными, мимо `Payment`. Админ ставит точную
   * дату, а не «плюс месяц»: это тот же ручной инструмент, что и `extras_until`
   * в 2.3, а не автоматическое продление по оплате (см. `planService.extendPlanExpiry`).
   */
  async extendPlan(farmId, planExpiresAt) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    await farm.update({ plan_expires_at: planExpiresAt });

    return this.getFarm(farmId);
  }

  /**
   * Разовая поблажка сверх тарифа — не смена тарифа (см.
   * docs/plans/PLATFORM-ADMIN.md, 2.3): тариф остаётся тем же, а по
   * истечении `extras_until` предел сам возвращается к тарифному.
   */
  async updateExtras(farmId, data) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    // Состав полей ограничен Joi-схемой (`updateFarmExtrasSchema`) — сюда
    // доезжают только extra_rabbits / extra_staff / extras_until.
    await farm.update(data);

    return this.getFarm(farmId);
  }

  /**
   * Токен входа под клиентом, только чтение (см.
   * docs/plans/PLATFORM-ADMIN.md, 3.2). Выдаётся на владельца фермы — того,
   * кого фактически видит саппорт, когда открывает приложение её глазами —
   * с claim'ами `read_only` и `impersonated_by`, проверяемыми в
   * `middleware/auth.js`. Сама запись в журнал — забота вызывающего
   * контроллера, здесь только выпуск токена.
   */
  async impersonate(farmId, adminId) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }
    if (!farm.owner_id) {
      throw new Error('FARM_NO_OWNER');
    }

    const owner = await User.findByPk(farm.owner_id);
    if (!owner) {
      throw new Error('FARM_NO_OWNER');
    }

    const token = JWTUtil.generateImpersonationToken({
      id: owner.id,
      email: owner.email,
      role: owner.role,
      tv: owner.token_version || 0,
      impersonated_by: adminId
    });

    return {
      access_token: token,
      farm: { id: farm.id, name: farm.name },
      owner: { id: owner.id, full_name: owner.full_name }
    };
  }

  /**
   * Мягкое удаление — доступ закрывается сразу (`authenticate`), сама запись
   * и все её данные ждут физической зачистки 30 дней (см. `jobs/farmPurgeJob`).
   * `confirmName` — обязательное подтверждение: админ должен набрать точное
   * название фермы, сервер это перепроверяет сам, не доверяя клиенту.
   */
  async softDelete(farmId, confirmName) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }
    if (farm.name !== confirmName) {
      throw new Error('CONFIRM_NAME_MISMATCH');
    }

    await farm.update({ deleted_at: new Date() });

    return this.getFarm(farmId);
  }

  /**
   * Сводка платформы целиком (см. docs/plans/PLATFORM-ADMIN.md, этап 5) —
   * один агрегирующий запрос вместо подсчёта по загруженным страницам
   * списка ферм: иначе «12 ферм» означало бы «столько успело догрузиться».
   *
   * Мягко удалённые фермы не входят ни в одну из «ферм всего» категорий —
   * тот же скоуп, что и в `listFarms` по умолчанию. Место в MinIO — исключение:
   * их файлы физически ещё не зачищены (ждут `jobs/farmPurgeJob`), значит
   * это реально занятые байты, и они всё равно посчитаны через `Photo`/
   * `Rabbit`, не привязанные к скоупу удаления фермы.
   */
  async getSummary() {
    const cutoff = new Date(Date.now() - DEFAULT_INACTIVE_DAYS * MS_PER_DAY);

    const [farms, registrations30d, rabbitsTotal, photoBytes, rabbitPhotoBytes] = await Promise.all([
      Farm.findAll({ where: { deleted_at: null }, include: [{ model: Plan, as: 'plan' }] }),
      Farm.count({ where: { deleted_at: null, created_at: { [Op.gte]: cutoff } } }),
      // Явный { tenantScope: 'all' } — это и правда сводка по всем фермам
      // сразу, а не забытый farm_id (см. src/utils/tenancy.js): без него
      // хук на Rabbit/Photo отказывает в запросе без условия по ферме.
      Rabbit.count({ tenantScope: 'all' }),
      Photo.sum('size_bytes', { tenantScope: 'all' }),
      Rabbit.sum('photo_size_bytes', { tenantScope: 'all' })
    ]);

    const farmIds = farms.map((farm) => farm.id);
    const [rabbitCounts, staffCounts, lastActiveByFarm] = await Promise.all([
      farmIds.length ? Rabbit.count({ where: { farm_id: farmIds }, group: ['farm_id'] }) : [],
      farmIds.length ? User.count({ where: { farm_id: farmIds }, group: ['farm_id'] }) : [],
      farmIds.length ? this._lastActiveByFarm(farmIds) : {}
    ]);
    const rabbitsByFarm = Object.fromEntries(rabbitCounts.map((row) => [row.farm_id, Number(row.count)]));
    const staffByFarm = Object.fromEntries(staffCounts.map((row) => [row.farm_id, Number(row.count)]));

    const summary = {
      total: farms.length,
      free: 0,
      paid: 0,
      no_plan: 0,
      expired: 0,
      suspended: 0,
      at_limit: 0
    };
    let inactive30d = 0;
    const cutoffTime = cutoff.getTime();

    for (const farm of farms) {
      if (!farm.plan) {
        summary.no_plan += 1;
      } else if (Number(farm.plan.price) === 0) {
        summary.free += 1;
      } else {
        summary.paid += 1;
      }

      if (planService.isExpired(farm)) summary.expired += 1;
      if (farm.status === 'suspended') summary.suspended += 1;
      if (isAtLimit({
        plan: farm.plan,
        rabbits_count: rabbitsByFarm[farm.id] || 0,
        staff_count: staffByFarm[farm.id] || 0,
        extra_rabbits: farm.extra_rabbits,
        extra_staff: farm.extra_staff,
        extras_until: farm.extras_until
      })) {
        summary.at_limit += 1;
      }

      const lastActive = lastActiveByFarm[farm.id] || null;
      if (!lastActive || new Date(lastActive).getTime() < cutoffTime) {
        inactive30d += 1;
      }
    }

    return {
      farms: summary,
      registrations_30d: registrations30d,
      inactive_30d: inactive30d,
      rabbits_total: rabbitsTotal,
      storage_bytes: (photoBytes || 0) + (rabbitPhotoBytes || 0)
    };
  }

  /**
   * Отменить мягкое удаление. Срок 30 дней здесь не проверяется намеренно:
   * если запись ещё существует, значит зачистка до неё не дошла — а раз
   * данные на месте, возвращать их можно.
   */
  async restore(farmId) {
    const farm = await Farm.findByPk(farmId);
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }
    if (!farm.deleted_at) {
      throw new Error('FARM_NOT_DELETED');
    }

    await farm.update({ deleted_at: null });

    return this.getFarm(farmId);
  }
}

module.exports = new PlatformAdminService();
