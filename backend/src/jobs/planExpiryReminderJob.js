const cron = require('node-cron');
const { Op } = require('sequelize');
const { Farm, Plan } = require('../models');
const { notifyFarmOwners } = require('../services/notifications/farmOwnerNotifier');
const logger = require('../utils/logger');

// Тем же часом, что и notificationDigestJob — время сервера, не «раз в сутки
// от старта», чтобы не плыть вместе с рестартами.
const CRON_SCHEDULE = '0 8 * * *';
const MS_PER_DAY = 24 * 60 * 60 * 1000;

/**
 * Разница в календарных днях, без учёта времени суток: до `date` осталось
 * 7 дней — независимо от того, истекает тариф в полночь или в 23:59.
 */
function daysUntil(date, now = new Date()) {
  const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const target = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  return Math.round((target - startOfToday) / MS_PER_DAY);
}

async function _notifyFarm(farm, { title, body }) {
  await notifyFarmOwners(farm.id, {
    title,
    body,
    data: { type: 'plan_expiry', route: '/subscription' }
  });
}

/**
 * Один платный тариф: напоминание за 7 и за 1 день, перевод в `read_only`
 * при истечении (см. docs/plans/PLATFORM-ADMIN.md, 4.2).
 *
 * `<= 0`, а не строго `=== 0` — самовосстанавливается, если задача не
 * отработала ровно в день истечения (пропущенный рестарт и т.п.), вместо
 * того чтобы навсегда пропустить перевод в read_only.
 */
async function _processFarm(farm) {
  const days = daysUntil(farm.plan_expires_at);

  if (days === 7 || days === 1) {
    await _notifyFarm(farm, {
      title: days === 7 ? 'Тариф скоро закончится' : 'Тариф заканчивается завтра',
      body: days === 7
        ? `Тариф «${farm.plan.name}» действует ещё 7 дней. Продлите его в приложении, раздел «Тариф».`
        : `Тариф «${farm.plan.name}» истекает завтра. Продлите его в приложении, раздел «Тариф», чтобы не потерять доступ к записи.`
    });
    return;
  }

  if (days <= 0 && farm.status === 'active') {
    await farm.update({ status: 'read_only' });
    await _notifyFarm(farm, {
      title: 'Тариф истёк',
      body: `Тариф «${farm.plan.name}» истёк — доступ переведён в режим только для чтения. Продлите тариф в приложении, раздел «Тариф», чтобы снова вносить записи.`
    });
  }
}

/**
 * Обход всех платных ферм с известным сроком. Бесплатный тариф по умолчанию
 * бессрочен (`plan_expires_at = null`) — таким фермам напоминать нечего.
 */
async function runReminders() {
  const farms = await Farm.findAll({
    where: { deleted_at: null, plan_expires_at: { [Op.not]: null } },
    include: [{ model: Plan, as: 'plan' }]
  });

  for (const farm of farms) {
    // Тариф сняли, а срок в базе остался — нечего напоминать и не за что
    // переводить в read_only.
    if (!farm.plan) continue;

    try {
      await _processFarm(farm);
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

module.exports = { startPlanExpiryReminderJob, runReminders, daysUntil };
