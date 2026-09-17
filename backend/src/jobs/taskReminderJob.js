const cron = require('node-cron');
const { Op } = require('sequelize');
const { Task } = require('../models');
const notificationService = require('../services/notificationService');
const { taskTitle } = require('../i18n/tasks');
const logger = require('../utils/logger');

/**
 * Напоминание о задаче — заранее, а не после.
 *
 * Поле `reminder_before` («за сколько минут предупредить») лежало в базе с
 * самого начала и не читалось никем. Человек ставил напоминание за день до
 * прививки, спокойно про неё забывал — и узнавал на следующее утро из
 * сводки, что опоздал. То есть функция выглядела рабочей, а внутри было
 * пусто.
 *
 * Раз в пятнадцать минут — шаг выбора у самого мелкого варианта («за 15
 * минут»). Реже значит промахиваться мимо коротких напоминаний, чаще —
 * гонять запрос без повода.
 */
const CRON_SCHEDULE = '*/15 * * * *';

/**
 * Насколько поздно ещё имеет смысл напомнить.
 *
 * Сервер мог лежать или задача — не отработать: без окна проснувшийся через
 * сутки процесс разослал бы напоминания обо всём, что «наступило» за это
 * время, включая давно просроченное. Просроченным занимается утренняя
 * сводка, а это — предупреждение заранее.
 */
const MAX_LATE_MINUTES = 120;

/** Сколько осталось до срока, словами читателя. */
function leadText(minutes, language) {
  const dictionary = {
    ru: { m: 'мин', h: 'ч', d: 'дн' },
    en: { m: 'min', h: 'h', d: 'd' },
    tg: { m: 'дақ', h: 'соат', d: 'рӯз' },
    uz: { m: 'daq', h: 'soat', d: 'kun' }
  };
  const words = dictionary[language] || dictionary.ru;

  if (minutes >= 1440) return `${Math.round(minutes / 1440)} ${words.d}`;
  if (minutes >= 60) return `${Math.round(minutes / 60)} ${words.h}`;
  return `${minutes} ${words.m}`;
}

/**
 * Задачи, по которым пора напомнить прямо сейчас.
 *
 * Отбор идёт по самому сроку, а не по вычисленному моменту напоминания:
 * `due_date - reminder_before` в условии не даёт воспользоваться индексом по
 * сроку, а задач с напоминанием на ферме немного.
 */
async function _dueForReminder(now) {
  const horizon = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);

  const candidates = await Task.findAll({
    where: {
      reminder_before: { [Op.not]: null },
      reminder_sent_at: null,
      status: { [Op.in]: ['pending', 'in_progress'] },
      // Сверху — неделя вперёд: дальше самого длинного напоминания
      // заглядывать незачем. Снизу — уже наступившие сроки отсекаются
      // окном опоздания ниже.
      due_date: { [Op.lte]: horizon }
    },
    attributes: [
      'id', 'farm_id', 'title', 'title_key', 'title_params',
      'due_date', 'reminder_before', 'assigned_to', 'created_by'
    ],
    // Фоновая задача обходит все хозяйства — это и есть её работа. Страж
    // арендаторов требует сказать об этом вслух, чтобы случайный запрос без
    // отбора по ферме не прошёл незамеченным.
    tenantScope: 'all'
  });

  return candidates.filter((task) => {
    const dueAt = new Date(task.due_date).getTime();
    const remindAt = dueAt - task.reminder_before * 60 * 1000;
    const late = now.getTime() - remindAt;

    // Момент наступил и не слишком давно.
    return late >= 0 && late <= MAX_LATE_MINUTES * 60 * 1000;
  });
}

/**
 * Кому уходит напоминание.
 *
 * Исполнителю, если он назначен: это его работа, и звать всю ферму незачем.
 * Без исполнителя — тому, кто задачу завёл: иначе напоминание не получит
 * никто, а именно этого человек и добивался, когда его ставил.
 */
function _recipients(task) {
  if (task.assigned_to) return [task.assigned_to];
  if (task.created_by) return [task.created_by];
  return [];
}

async function runTaskReminders(now = new Date()) {
  const tasks = await _dueForReminder(now);

  for (const task of tasks) {
    const recipients = _recipients(task);

    // Некому напомнить — отмечаем отправленным всё равно, иначе задача
    // будет перебирать её каждые пятнадцать минут до самого срока.
    if (recipients.length > 0) {
      try {
        await notificationService.sendToUsers(task.farm_id, recipients, {
          i18n: {
            key: 'taskReminder',
            params: (language) => ({
              task: taskTitle(task, language),
              minutes: leadText(task.reminder_before, language)
            })
          },
          data: { type: 'task_reminder', route: `/tasks/${task.id}` }
        });
      } catch (error) {
        logger.error('Task reminder failed', {
          taskId: task.id,
          error: error.message
        });
        // Отметку не ставим: пусть попробует снова на следующем проходе,
        // пока не вышло окно опоздания.
        continue;
      }
    }

    await Task.update(
      { reminder_sent_at: now },
      { where: { id: task.id }, tenantScope: 'all' }
    );
  }

  return tasks.length;
}

function startTaskReminderJob() {
  const task = cron.schedule(CRON_SCHEDULE, () => {
    runTaskReminders().catch((error) =>
      logger.error('Task reminder job failed', { error: error.message }));
  });

  logger.info('Task reminder job started', { schedule: CRON_SCHEDULE });
  return task;
}

module.exports = {
  startTaskReminderJob,
  runTaskReminders,
  leadText,
  MAX_LATE_MINUTES
};
