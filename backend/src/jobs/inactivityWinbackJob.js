const cron = require('node-cron');
const { Farm } = require('../models');
const platformAdminService = require('../services/platformAdminService');
const { notifyFarmOwners } = require('../services/notifications/farmOwnerNotifier');
const logger = require('../utils/logger');

// На час позже дайджеста и напоминаний о тарифе: и то и другое уходит в
// 08:00, а «мы по вам скучали» вперемешку с «просрочены вакцинации» в одну
// секунду — это не разговор, а очередь пушей.
const CRON_SCHEDULE = '0 9 * * *';
const MS_PER_DAY = 24 * 60 * 60 * 1000;

/**
 * Пороги молчания, на которых зовём ферму вернуться — от большего к меньшему,
 * чтобы `find` возвращал самый поздний из достигнутых.
 *
 * Две недели — ещё «закрутились, забыли»; месяц — уже уходящий клиент.
 * Дальше не зовём: третье письмо в ту же дверь читается как спам.
 */
const REMINDER_DAYS = [30, 14];

/**
 * Сколько календарных дней прошло с `date`, без учёта времени суток: вход
 * вчера в 23:59 и вчера в 00:01 — одинаково «один день назад».
 */
function daysSince(date, now = new Date()) {
  const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const past = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  return Math.round((startOfToday - past) / MS_PER_DAY);
}

/**
 * Самый поздний достигнутый порог или `null`, если ферма ещё в строю.
 *
 * `>=`, а не строгое равенство: задача может не отработать ровно на 14-й день
 * (рестарт, простой) — тогда ферма получит приглашение назавтра, а не
 * потеряет его навсегда. От ежедневного повтора защищает не точность дня, а
 * запомненный порог (`inactivity_notified_days`).
 */
function reminderStage(inactiveDays) {
  return REMINDER_DAYS.find((days) => inactiveDays >= days) ?? null;
}

function _message(farm, stage) {
  if (stage === 14) {
    return {
      title: 'Давно вас не было',
      body: `В хозяйство «${farm.name}» не заходили две недели. Загляните в приложение: отметьте кормления, взвешивания и окролы, чтобы записи не отстали от жизни фермы.`
    };
  }

  return {
    title: 'Ферма ждёт вас',
    body: `В хозяйстве «${farm.name}» не были уже месяц. Все ваши записи на месте — откройте приложение и продолжите с того, на чём остановились.`
  };
}

/**
 * Одна ферма: позвать вернуться на 14-й и на 30-й день молчания, по одному
 * разу на порог.
 *
 * Активность фермы — та же, по которой платформенный админ видит фильтр «не
 * заходили N дней»: последний вход кого-либо из её людей. Ни одного входа
 * вообще — считаем от создания фермы: зарегистрировались и не вернулись —
 * это тот же уход, только раньше.
 *
 * Порог запоминается ПОСЛЕ отправки. Если пуш не ушёл, запись не делается —
 * задача попробует завтра, а не спишет неотправленное как доставленное.
 */
async function _processFarm(farm, lastActive) {
  const since = lastActive ? new Date(lastActive) : new Date(farm.created_at);
  const stage = reminderStage(daysSince(since));

  if (stage === null) {
    // Ферма вернулась. Забываем отправленное, чтобы в следующий раз позвать
    // её заново, а не молчать из-за прошлогодней отметки.
    if (farm.inactivity_notified_days !== null) {
      await farm.update({ inactivity_notified_days: null });
    }
    return;
  }

  if (farm.inactivity_notified_days === stage) return;

  await notifyFarmOwners(farm.id, {
    ..._message(farm, stage),
    data: { type: 'farm_inactive', route: '/today' }
  });

  await farm.update({ inactivity_notified_days: stage });
}

/**
 * Обход живых ферм.
 *
 * Приостановленные пропускаем: доступ им закрыт целиком (`authenticate`), и
 * звать в приложение, которое не пустит, — издевательство, а не забота.
 * Мягко удалённые — тем более (см. `notificationDigestJob`).
 */
async function runWinbackReminders() {
  const farms = await Farm.findAll({ where: { deleted_at: null } });
  const living = farms.filter((farm) => farm.status !== 'suspended');
  if (living.length === 0) return;

  const lastActiveByFarm = await platformAdminService.lastActiveByFarm(living.map((farm) => farm.id));

  for (const farm of living) {
    try {
      await _processFarm(farm, lastActiveByFarm[farm.id] || null);
    } catch (error) {
      logger.error('Inactivity winback failed for farm', { farmId: farm.id, error: error.message });
    }
  }
}

function startInactivityWinbackJob() {
  const task = cron.schedule(CRON_SCHEDULE, () => {
    runWinbackReminders().catch((error) =>
      logger.error('Inactivity winback job failed', { error: error.message }));
  });

  logger.info('Inactivity winback job started', { schedule: CRON_SCHEDULE });
  return task;
}

module.exports = { startInactivityWinbackJob, runWinbackReminders, daysSince, reminderStage };
