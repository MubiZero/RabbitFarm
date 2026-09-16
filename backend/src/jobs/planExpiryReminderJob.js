const cron = require('node-cron');
const { Op } = require('sequelize');
const { Farm, Plan } = require('../models');
const { notifyFarmOwners } = require('../services/notifications/farmOwnerNotifier');
const logger = require('../utils/logger');
const { hourInZone } = require('../utils/dateRange');

// Раз в час, как и notificationDigestJob: напоминание уходит в восемь утра
// **хозяйства**, а не сервера. «Тариф кончается завтра» посреди ночи — это
// сообщение, которое прочитают уже после того, как ферму закроют на чтение.
const CRON_SCHEDULE = '0 * * * *';

/** Час хозяйства, в который уходит напоминание. */
const REMINDER_HOUR = 8;
const MS_PER_DAY = 24 * 60 * 60 * 1000;
const MS_PER_HOUR = 60 * 60 * 1000;

// Запас между истечением тарифа и переводом в read_only. Банк подтверждает
// платёж не мгновенно: ферма платит в день истечения вечером, подтверждение
// приходит ночью — без запаса она успевает получить «доступ только для
// чтения» за уже оплаченный тариф. Часы, а не дни: это про задержку
// подтверждения, а не про отсрочку платежа.
const DEFAULT_GRACE_HOURS = 6;

/**
 * Разница в календарных днях, без учёта времени суток: до `date` осталось
 * 7 дней — независимо от того, истекает тариф в полночь или в 23:59.
 */
function daysUntil(date, now = new Date()) {
  const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const target = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  return Math.round((target - startOfToday) / MS_PER_DAY);
}

/**
 * Читается на каждом проходе, а не один раз при загрузке модуля — значение
 * меняют, чтобы подстроиться под живую задержку банка, и перезапуск сервиса
 * ради этого не нужен. Пустая или некорректная переменная — дефолт, а не 0:
 * `PLAN_EXPIRY_GRACE_HOURS=` в .env не должен молча отключать запас.
 */
function graceHours() {
  const raw = process.env.PLAN_EXPIRY_GRACE_HOURS;
  if (raw == null || raw === '') return DEFAULT_GRACE_HOURS;

  const hours = Number(raw);
  return Number.isFinite(hours) && hours >= 0 ? hours : DEFAULT_GRACE_HOURS;
}

/** Момент, начиная с которого просрочку уже нельзя списать на задержку банка. */
function readOnlyDueAt(planExpiresAt) {
  return new Date(new Date(planExpiresAt).getTime() + graceHours() * MS_PER_HOUR);
}

async function _notifyFarm(farm, key) {
  await notifyFarmOwners(farm.id, {
    key,
    params: { plan: farm.plan.name },
    data: { type: 'plan_expiry', route: '/subscription' }
  });
}

/**
 * Один платный тариф: напоминание за 7 и за 1 день, перевод в `read_only`
 * при истечении и напоминания на 3-й и 14-й день просрочки (см.
 * docs/plans/PLATFORM-ADMIN.md, 4.2).
 *
 * `days <= 0`, а не строго `=== 0` — самовосстанавливается, если задача не
 * отработала ровно в день истечения (пропущенный рестарт и т.п.), вместо
 * того чтобы навсегда пропустить перевод в read_only.
 *
 * Порогов ровно по одному календарному дню, а флага «уже отправляли» нет
 * намеренно: задача ходит раз в сутки, и день совпадает с порогом один раз —
 * тот же приём, что и у напоминаний до истечения.
 */
async function _processFarm(farm, now = new Date()) {
  const days = daysUntil(farm.plan_expires_at, now);

  // Напоминания уходят в восемь утра хозяйства: задача ходит каждый час и
  // будит только те фермы, у которых этот час наступил.
  //
  // Закрытие доступа ниже этой проверке НЕ подчиняется намеренно: перевод в
  // режим чтения — не разговор с человеком, а следствие неоплаченного
  // тарифа. Ждать утра значило бы оставить ферму работать на истёкшем
  // тарифе лишние часы, а у фермы в другом поясе — почти сутки.
  const isReminderHour = hourInZone(farm.timezone, now) === REMINDER_HOUR;

  if (days === 7 || days === 1) {
    if (isReminderHour) {
      await _notifyFarm(farm, days === 7 ? 'planExpiringWeek' : 'planExpiringTomorrow');
    }
    return;
  }

  if (days <= 0 && farm.status === 'active') {
    // В запасе на подтверждение банка ферма ещё работает как обычно — и
    // молчим тоже: напоминание «тариф истёк» ферме, которая заплатила час
    // назад, вернётся жалобой.
    if (readOnlyDueAt(farm.plan_expires_at) > now) return;

    await farm.update({ status: 'read_only' });
    await _notifyFarm(farm, 'planExpired');
    return;
  }

  // Просрочка без напоминаний — недополученная выручка: ферма видит только
  // пассивный баннер в приложении и легко про оплату забывает.
  //
  // Отсчёт от `plan_expires_at`, а не от момента самого перевода: момент
  // перевода нигде не хранится, а с запасом в несколько часов он всё равно
  // приходится на тот же день или следующий. `read_only` в условии — потому
  // что текст говорит «записи не сохраняются»: приостановленной ферме
  // (`suspended`) это неправда, ей продление доступа не откроет.
  if (farm.status === 'read_only' && (days === -3 || days === -14) && isReminderHour) {
    await _notifyFarm(farm, days === -3 ? 'planReadOnlyThreeDays' : 'planUnpaidTwoWeeks');
  }
}

/**
 * Обход всех платных ферм с известным сроком. Бесплатный тариф по умолчанию
 * бессрочен (`plan_expires_at = null`) — таким фермам напоминать нечего.
 */
async function runReminders(now = new Date()) {
  // Один момент на весь проход: обход тысячи ферм может перевалить за
  // полночь, и тогда часть ферм считалась бы по вчерашним порогам, а часть
  // по сегодняшним.
  const farms = await Farm.findAll({
    where: { deleted_at: null, plan_expires_at: { [Op.not]: null } },
    include: [{ model: Plan, as: 'plan' }]
  });

  for (const farm of farms) {
    // Тариф сняли, а срок в базе остался — нечего напоминать и не за что
    // переводить в read_only.
    if (!farm.plan) continue;


    try {
      await _processFarm(farm, now);
    } catch (error) {
      logger.error('Plan expiry reminder failed for farm', { farmId: farm.id, error: error.message });
    }
  }
}

function startPlanExpiryReminderJob() {
  const task = cron.schedule(CRON_SCHEDULE, () => {
    runReminders().catch((error) => logger.error('Plan expiry reminder job failed', { error: error.message }));
  });

  logger.info('Plan expiry reminder job started', { schedule: CRON_SCHEDULE });
  return task;
}

module.exports = { startPlanExpiryReminderJob, runReminders, daysUntil, graceHours };
