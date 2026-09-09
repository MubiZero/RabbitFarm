const cron = require('node-cron');
const { Op, col } = require('sequelize');
const { Farm, User, Vaccination, Task, Feed } = require('../models');
const notificationService = require('../services/notificationService');
const logger = require('../utils/logger');

// 08:00 каждый день, время сервера (пояс задан через TZ, см. backend/Dockerfile:
// без него контейнер живёт в UTC). Не «раз в 24 часа от старта», как
// tokenCleanup — важно бить в одно и то же время суток, а не плыть вместе
// с рестартами.
const CRON_SCHEDULE = '0 8 * * *';

/**
 * Кому в этой ферме уходит дайджест: владельцы и менеджеры, кто его не
 * выключил (`digest_enabled`, см. Настройки на клиенте). Персональный пуш по
 * своей задаче (ниже) этим списком не ограничен — это не дайджест, а прямое
 * назначение, и своя настройка выключения ему не нужна.
 */
async function _digestRecipients(farmId) {
  const members = await User.findAll({
    where: { farm_id: farmId, role: { [Op.in]: ['owner', 'manager'] }, is_active: true, digest_enabled: true },
    attributes: ['id']
  });
  return members.map(m => m.id);
}

/**
 * Дайджест по одной ферме.
 *
 * Раз в сутки, а не по одному пушу на каждый простроченный пункт — иначе на
 * 5 просроченных вакцинаций пять пушей каждый день. Исключение — задачи с
 * назначенным исполнителем: там пуш точечный, ему одному, а не в общий счёт.
 */
async function runDigestForFarm(farmId) {
  const now = new Date();
  const recipients = await _digestRecipients(farmId);

  // То же условие, что и в vaccinationController.getStatistics (overdue).
  const overdueVaccinations = await Vaccination.count({
    where: { farm_id: farmId, next_vaccination_date: { [Op.lt]: now, [Op.not]: null } }
  });
  if (overdueVaccinations > 0 && recipients.length > 0) {
    await notificationService.sendToUsers(farmId, recipients, {
      title: 'Просроченные вакцинации',
      body: `Просрочено: ${overdueVaccinations}`,
      data: { type: 'vaccination_digest', route: '/vaccinations' }
    });
  }

  // То же условие, что и в feedService.getLowStock.
  const lowStockFeeds = await Feed.count({
    where: { farm_id: farmId, [Op.and]: [{ current_stock: { [Op.lte]: col('min_stock') } }] }
  });
  if (lowStockFeeds > 0 && recipients.length > 0) {
    await notificationService.sendToUsers(farmId, recipients, {
      title: 'Низкий остаток корма',
      body: `Кормов ниже минимума: ${lowStockFeeds}`,
      data: { type: 'feed_digest', route: '/feeds' }
    });
  }

  // То же условие, что и overdue_only в taskService.listTasks.
  const overdueTasks = await Task.findAll({
    where: { farm_id: farmId, due_date: { [Op.lt]: now }, status: { [Op.in]: ['pending', 'in_progress'] } },
    attributes: ['id', 'title', 'assigned_to']
  });

  const withAssignee = overdueTasks.filter(t => t.assigned_to);
  const withoutAssignee = overdueTasks.length - withAssignee.length;

  for (const task of withAssignee) {
    await notificationService.sendToUsers(farmId, [task.assigned_to], {
      title: 'Просроченная задача',
      body: task.title,
      data: { type: 'task_overdue', route: `/tasks/${task.id}` }
    });
  }

  if (withoutAssignee > 0 && recipients.length > 0) {
    await notificationService.sendToUsers(farmId, recipients, {
      title: 'Просроченные задачи без исполнителя',
      body: `Просрочено: ${withoutAssignee}`,
      data: { type: 'task_digest', route: '/tasks' }
    });
  }
}

async function runDigest() {
  // Мягко удалённые фермы обходим: доступ им уже закрыт (`authenticate`), и
  // пуш «у вас просрочены вакцинации» ушёл бы туда, куда нельзя войти.
  const farms = await Farm.findAll({ attributes: ['id'], where: { deleted_at: null } });

  for (const farm of farms) {
    try {
      await runDigestForFarm(farm.id);
    } catch (error) {
      logger.error('Notification digest failed for farm', { farmId: farm.id, error: error.message });
    }
  }
}

function startNotificationDigestJob() {
  const task = cron.schedule(CRON_SCHEDULE, () => {
    runDigest().catch(error => logger.error('Notification digest failed', { error: error.message }));
  });

  logger.info('Notification digest job started', { schedule: CRON_SCHEDULE });
  return task;
}

module.exports = { startNotificationDigestJob, runDigest, runDigestForFarm };
