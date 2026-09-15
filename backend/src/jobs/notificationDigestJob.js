const cron = require('node-cron');
const { NEST_BOX_BEFORE_BIRTH } = require('../utils/breedingCycle');
const { overdueRabbits } = require('../utils/vaccinationDue');
const { Op, col } = require('sequelize');
const { Farm, User, Vaccination, Task, Feed, Breeding, Birth, Rabbit, Cage } = require('../models');
const notificationService = require('../services/notificationService');
const { taskTitle } = require('../i18n/tasks');
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

  // Кролики, а не строки истории: привитый пять раз давал пять «просрочек»,
  // павшие и проданные считались наравне с живыми, и это число уходило
  // пушем каждое утро, не уменьшаясь (см. utils/vaccinationDue).
  const overdueVaccinations = await overdueRabbits(farmId);
  if (overdueVaccinations > 0 && recipients.length > 0) {
    await notificationService.sendToUsers(farmId, recipients, {
      i18n: { key: 'vaccinationDigest', params: { count: overdueVaccinations } },
      data: { type: 'vaccination_digest', route: '/vaccinations' }
    });
  }

  // То же условие, что и в feedService.getLowStock.
  const lowStockFeeds = await Feed.count({
    where: { farm_id: farmId, [Op.and]: [{ current_stock: { [Op.lte]: col('min_stock') } }] }
  });
  if (lowStockFeeds > 0 && recipients.length > 0) {
    await notificationService.sendToUsers(farmId, recipients, {
      i18n: { key: 'feedDigest', params: { count: lowStockFeeds } },
      data: { type: 'feed_digest', route: '/feeds' }
    });
  }

  // То же условие, что и overdue_only в taskService.listTasks.
  const overdueTasks = await Task.findAll({
    where: { farm_id: farmId, due_date: { [Op.lt]: now }, status: { [Op.in]: ['pending', 'in_progress'] } },
    attributes: ['id', 'title', 'title_key', 'title_params', 'assigned_to']
  });

  const withAssignee = overdueTasks.filter(t => t.assigned_to);
  const withoutAssignee = overdueTasks.length - withAssignee.length;

  for (const task of withAssignee) {
    await notificationService.sendToUsers(farmId, [task.assigned_to], {
      i18n: {
        key: 'taskOverdue',
        params: (language) => ({ task: taskTitle(task, language) })
      },
      data: { type: 'task_overdue', route: `/tasks/${task.id}` }
    });
  }

  if (withoutAssignee > 0 && recipients.length > 0) {
    await notificationService.sendToUsers(farmId, recipients, {
      i18n: { key: 'taskDigest', params: { count: withoutAssignee } },
      data: { type: 'task_digest', route: '/tasks' }
    });
  }

  await _notifyUpcomingKindlings(farmId, now, recipients);
}

/**
 * За сколько дней предупреждать о будущем окроле.
 *
 * Ровно столько же, за сколько заводится задача «поставить маточник»: это
 * одно и то же дело, и два разных дня для него сбивали человека с толку —
 * задача звала в среду, пуш напоминал в четверг.
 */
const KINDLING_WARNING_DAYS = NEST_BOX_BEFORE_BIRTH;

/**
 * Скорый окрол: одно письмо на каждую самку, а не общий счётчик.
 *
 * Тут счётчик «ожидается окролов: 3» бесполезен — человеку надо знать, к
 * какой клетке идти с маточником. Поэтому в тексте номер клетки: на ферме
 * говорят «четырнадцатая окотилась», а не «самка А-0231».
 */
async function _notifyUpcomingKindlings(farmId, now, recipients) {
  if (recipients.length === 0) return;

  const target = new Date(now);
  target.setDate(target.getDate() + KINDLING_WARNING_DAYS);
  const targetDate = target.toISOString().split('T')[0];

  const upcoming = await Breeding.findAll({
    where: {
      farm_id: farmId,
      expected_birth_date: targetDate,
      status: { [Op.in]: ['planned', 'completed'] }
    },
    attributes: ['id'],
    include: [
      {
        model: Rabbit,
        as: 'female',
        attributes: ['id', 'name', 'tag_id'],
        include: [{ model: Cage, attributes: ['number'] }]
      },
      // Уже окотившиеся отсеиваются здесь же: к записи о случке привязан
      // окрол, значит предупреждать не о чем.
      { model: Birth, attributes: ['id'], required: false }
    ]
  });

  for (const breeding of upcoming) {
    if (breeding.Births && breeding.Births.length > 0) continue;

    const female = breeding.female;
    const cageNumber = female && female.Cage ? female.Cage.number : null;
    const femaleName = female ? (female.name || female.tag_id) : null;
    // Ни клетки, ни клички — сказать человеку нечего, а «окрол послезавтра»
    // без адреса только заставит его искать по всей ферме.
    if (!cageNumber && !femaleName) continue;

    await notificationService.sendToUsers(farmId, recipients, {
      i18n: { key: 'kindlingSoon', params: { cageNumber, femaleName } },
      data: { type: 'kindling_soon', route: `/breeding/${breeding.id}` }
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
