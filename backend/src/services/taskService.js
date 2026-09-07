const { Task, Rabbit, Cage, User } = require('../models');
const { Op, fn, col } = require('sequelize');
const logger = require('../utils/logger');
const { startOfDayUtc, nextDayUtc } = require('../utils/dateRange');
const notificationService = require('./notificationService');

const notifyAssignee = (task, farmId) => {
  notificationService.sendToUsers(farmId, [task.assigned_to], {
    title: 'Вам назначена задача',
    body: task.title,
    data: { type: 'task', route: '/tasks' }
  }).catch(error => {
    logger.error('Task assignment notification failed', { taskId: task.id, error: error.message });
  });
};

const TASK_INCLUDE = [
  { model: Rabbit, as: 'rabbit', attributes: ['id', 'name', 'tag_id'] },
  { model: Cage, as: 'cage', attributes: ['id', 'number', 'location'] },
  { model: User, as: 'assignedTo', attributes: ['id', 'full_name', 'email'] },
  { model: User, as: 'creator', attributes: ['id', 'full_name', 'email'] }
];

/**
 * Исполнителем может быть только человек с той же фермы.
 *
 * Раньше проверялось лишь существование пользователя, поэтому задачу можно
 * было назначить работнику чужой фермы: она появлялась в его списке — фильтр
 * идёт по assigned_to.
 */
const assertAssigneeBelongsToFarm = async (assigneeId, farmId) => {
  const assignee = await User.findOne({ where: { id: assigneeId, farm_id: farmId } });

  if (!assignee) {
    throw new Error('ASSIGNEE_NOT_FOUND');
  }
};

const RECURRENCE_OFFSETS = {
  daily: (d) => d.setDate(d.getDate() + 1),
  weekly: (d) => d.setDate(d.getDate() + 7),
  biweekly: (d) => d.setDate(d.getDate() + 14),
  monthly: (d) => d.setMonth(d.getMonth() + 1),
  quarterly: (d) => d.setMonth(d.getMonth() + 3),
  yearly: (d) => d.setFullYear(d.getFullYear() + 1)
};

/**
 * Task service
 * Business logic for task management
 */
class TaskService {
  async createTask(data) {
    const { rabbit_id, cage_id, assigned_to, farm_id, author_id } = data;

    if (rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: rabbit_id, farm_id } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    if (cage_id) {
      const cage = await Cage.findOne({ where: { id: cage_id, farm_id } });
      if (!cage) throw new Error('CAGE_NOT_FOUND');
    }

    if (assigned_to) {
      await assertAssigneeBelongsToFarm(assigned_to, farm_id);
    }

    if (data.recurrence_rule && !RECURRENCE_OFFSETS[data.recurrence_rule.toLowerCase()]) {
      throw new Error('INVALID_RECURRENCE_RULE');
    }

    const task = await Task.create({
      farm_id,
      title: data.title,
      description: data.description,
      type: data.type,
      status: data.status || 'pending',
      priority: data.priority || 'medium',
      due_date: data.due_date,
      rabbit_id,
      cage_id,
      assigned_to,
      created_by: author_id,
      is_recurring: data.is_recurring || false,
      recurrence_rule: data.recurrence_rule,
      reminder_before: data.reminder_before,
      notes: data.notes
    });

    const created = await Task.findOne({
      where: { id: task.id, farm_id },
      include: [
        { ...TASK_INCLUDE[0], where: { farm_id }, required: false },
        { ...TASK_INCLUDE[1], where: { farm_id }, required: false },
        TASK_INCLUDE[2],
        TASK_INCLUDE[3]
      ]
    });

    logger.info('Task created', { taskId: task.id });

    if (assigned_to && assigned_to !== author_id) {
      notifyAssignee(created, farm_id);
    }

    return created;
  }

  async getTaskById(id, farmId) {
    const task = await Task.findOne({
      where: { id, farm_id: farmId },
      include: TASK_INCLUDE
    });
    if (!task) throw new Error('TASK_NOT_FOUND');
    return task;
  }

  async listTasks(farmId, filters = {}) {
    const {
      page = 1,
      limit = 10,
      sort_by = 'due_date',
      sort_order = 'ASC',
      type,
      status,
      priority,
      rabbit_id,
      cage_id,
      assigned_to,
      from_date,
      to_date,
      overdue_only,
      today_only
    } = filters;

    const offset = (page - 1) * limit;
    const where = { farm_id: farmId };

    if (type) where.type = type;
    if (status) where.status = status;
    if (priority) where.priority = priority;
    if (rabbit_id) where.rabbit_id = rabbit_id;
    if (cage_id) where.cage_id = cage_id;
    if (assigned_to) where.assigned_to = assigned_to;

    // `tasks.due_date` хранит момент времени, а период задаётся календарной
    // датой: `due_date <= '2026-08-24'` означает «не позже полуночи», и задачи
    // с сегодняшним сроком выпадали из выборки. Верхняя граница — строгое
    // «раньше следующего дня», в UTC, как лежат сами записи.
    if (from_date || to_date) {
      where.due_date = {};
      if (from_date) where.due_date[Op.gte] = startOfDayUtc(from_date);
      if (to_date) where.due_date[Op.lt] = nextDayUtc(to_date);
    }

    // Флаг приходит из validate(listTasksQuerySchema, 'query'): Joi.boolean()
    // подменяет строку 'true' на булево true, поэтому сравнение только со
    // строкой не срабатывало НИКОГДА — чип фильтра горел, а список не менялся.
    // Сравниваем с обоими видами: сервис зовут и в обход валидатора.
    if (overdue_only === true || overdue_only === 'true') {
      where.due_date = { [Op.lt]: new Date() };
      where.status = { [Op.in]: ['pending', 'in_progress'] };
    }

    if (today_only === true || today_only === 'true') {
      // «Сегодня» считается в UTC по той же причине: в поясе процесса граница
      // разъезжается с тем, как лежат записи, и вечерние задачи уезжают в
      // соседние сутки.
      const now = new Date();
      where.due_date = { [Op.gte]: startOfDayUtc(now), [Op.lt]: nextDayUtc(now) };
    }

    const { count, rows } = await Task.findAndCountAll({
      where,
      include: TASK_INCLUDE,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    return { items: rows, total: count, page: parseInt(page), limit: parseInt(limit) };
  }

  async updateTask(id, farmId, data, actorId) {
    const task = await Task.findOne({ where: { id, farm_id: farmId } });
    if (!task) throw new Error('TASK_NOT_FOUND');

    const { rabbit_id, cage_id, assigned_to, status, completed_at } = data;
    const isReassignment = assigned_to !== undefined
      && assigned_to !== task.assigned_to
      && assigned_to !== actorId;

    if (rabbit_id && rabbit_id !== task.rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: rabbit_id, farm_id: farmId } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    if (cage_id && cage_id !== task.cage_id) {
      const cage = await Cage.findOne({ where: { id: cage_id, farm_id: farmId } });
      if (!cage) throw new Error('CAGE_NOT_FOUND');
    }

    if (assigned_to) {
      await assertAssigneeBelongsToFarm(assigned_to, farmId);
    }

    const updateData = { ...data };
    if (status === 'completed' && !completed_at) {
      updateData.completed_at = new Date();
    } else if (status !== 'completed') {
      updateData.completed_at = null;
    }

    await task.update(updateData);

    const updated = await Task.findOne({ where: { id, farm_id: farmId }, include: TASK_INCLUDE });
    logger.info('Task updated', { taskId: id });

    if (isReassignment) {
      notifyAssignee(updated, farmId);
    }

    return updated;
  }

  async deleteTask(id, farmId) {
    const task = await Task.findOne({ where: { id, farm_id: farmId } });
    if (!task) throw new Error('TASK_NOT_FOUND');
    await task.destroy();
    logger.info('Task deleted', { taskId: id });
    return { success: true };
  }

  async getStatistics(farmId) {
    const where = { farm_id: farmId };

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const [totalPending, totalInProgress, totalCompleted, totalCancelled, overdueCount, todayCount, tasksByType, tasksByPriority] =
      await Promise.all([
        Task.count({ where: { ...where, status: 'pending' } }),
        Task.count({ where: { ...where, status: 'in_progress' } }),
        Task.count({ where: { ...where, status: 'completed' } }),
        Task.count({ where: { ...where, status: 'cancelled' } }),
        Task.count({ where: { ...where, due_date: { [Op.lt]: new Date() }, status: { [Op.in]: ['pending', 'in_progress'] } } }),
        Task.count({ where: { ...where, due_date: { [Op.gte]: today, [Op.lt]: tomorrow }, status: { [Op.in]: ['pending', 'in_progress'] } } }),
        Task.findAll({ attributes: ['type', [fn('COUNT', col('id')), 'count']], where, group: ['type'] }),
        Task.findAll({ attributes: ['priority', [fn('COUNT', col('id')), 'count']], where: { ...where, status: { [Op.in]: ['pending', 'in_progress'] } }, group: ['priority'] })
      ]);

    return {
      total_pending: totalPending,
      total_in_progress: totalInProgress,
      total_completed: totalCompleted,
      total_cancelled: totalCancelled,
      overdue_count: overdueCount,
      today_count: todayCount,
      tasks_by_type: tasksByType.map(item => ({ type: item.type, count: parseInt(item.dataValues.count) })),
      tasks_by_priority: tasksByPriority.map(item => ({ priority: item.priority, count: parseInt(item.dataValues.count) }))
    };
  }

  async getUpcoming(farmId, days = 7) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const futureDate = new Date(today);
    futureDate.setDate(futureDate.getDate() + parseInt(days));

    return Task.findAll({
      where: {
        farm_id: farmId,
        due_date: { [Op.gte]: today, [Op.lt]: futureDate },
        status: { [Op.in]: ['pending', 'in_progress'] }
      },
      include: [TASK_INCLUDE[0], TASK_INCLUDE[1], TASK_INCLUDE[2]],
      order: [['due_date', 'ASC'], ['priority', 'DESC']]
    });
  }

  async completeTask(id, farmId) {
    const task = await Task.findOne({
      where: { id, farm_id: farmId }
    });
    if (!task) throw new Error('TASK_NOT_FOUND');

    const transaction = await Task.sequelize.transaction();
    try {
      await task.update({ status: 'completed', completed_at: new Date() }, { transaction });

      if (task.is_recurring && task.recurrence_rule) {
        const nextDueDate = new Date(task.due_date);
        const applyOffset = RECURRENCE_OFFSETS[task.recurrence_rule.toLowerCase()];
        if (applyOffset) {
          applyOffset(nextDueDate);
          if (nextDueDate > new Date(task.due_date)) {
            await Task.create({
              farm_id: farmId,
              title: task.title,
              description: task.description,
              type: task.type,
              status: 'pending',
              priority: task.priority,
              due_date: nextDueDate,
              rabbit_id: task.rabbit_id,
              cage_id: task.cage_id,
              assigned_to: task.assigned_to,
              created_by: task.created_by,
              is_recurring: true,
              recurrence_rule: task.recurrence_rule,
              reminder_before: task.reminder_before,
              notes: task.notes
            }, { transaction });
          }
        }
      }

      await transaction.commit();
    } catch (error) {
      await transaction.rollback();
      throw error;
    }

    const updated = await Task.findOne({
      where: { id, farm_id: farmId },
      include: [TASK_INCLUDE[0], TASK_INCLUDE[1], TASK_INCLUDE[2]]
    });
    logger.info('Task completed', { taskId: id });
    return updated;
  }
}

module.exports = new TaskService();
