const { Task, Rabbit, Cage, User } = require('../models');
const { Op, fn, col } = require('sequelize');
const logger = require('../utils/logger');

const TASK_INCLUDE = [
  { model: Rabbit, as: 'rabbit', attributes: ['id', 'name', 'tag_id'] },
  { model: Cage, as: 'cage', attributes: ['id', 'number', 'location'] },
  { model: User, as: 'assignedTo', attributes: ['id', 'full_name', 'email'] },
  { model: User, as: 'creator', attributes: ['id', 'full_name', 'email'] }
];

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
    const { rabbit_id, cage_id, assigned_to, user_id } = data;

    if (rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: rabbit_id, user_id } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    if (cage_id) {
      const cage = await Cage.findOne({ where: { id: cage_id, user_id } });
      if (!cage) throw new Error('CAGE_NOT_FOUND');
    }

    if (assigned_to) {
      const user = await User.findByPk(assigned_to);
      if (!user) throw new Error('ASSIGNEE_NOT_FOUND');
    }

    const task = await Task.create({
      title: data.title,
      description: data.description,
      type: data.type,
      status: data.status || 'pending',
      priority: data.priority || 'medium',
      due_date: data.due_date,
      rabbit_id,
      cage_id,
      assigned_to,
      created_by: user_id,
      is_recurring: data.is_recurring || false,
      recurrence_rule: data.recurrence_rule,
      reminder_before: data.reminder_before,
      notes: data.notes
    });

    const created = await Task.findByPk(task.id, {
      include: [
        { ...TASK_INCLUDE[0], where: { user_id }, required: false },
        { ...TASK_INCLUDE[1], where: { user_id }, required: false },
        TASK_INCLUDE[2],
        TASK_INCLUDE[3]
      ]
    });

    logger.info('Task created', { taskId: task.id });
    return created;
  }

  async getTaskById(id, userId) {
    const task = await Task.findOne({
      where: {
        id,
        [Op.or]: [{ created_by: userId }, { assigned_to: userId }]
      },
      include: TASK_INCLUDE
    });
    if (!task) throw new Error('TASK_NOT_FOUND');
    return task;
  }

  async listTasks(userId, filters = {}) {
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
    const where = {
      [Op.or]: [{ created_by: userId }, { assigned_to: userId }]
    };

    if (type) where.type = type;
    if (status) where.status = status;
    if (priority) where.priority = priority;
    if (rabbit_id) where.rabbit_id = rabbit_id;
    if (cage_id) where.cage_id = cage_id;
    if (assigned_to) where.assigned_to = assigned_to;

    if (from_date || to_date) {
      where.due_date = {};
      if (from_date) where.due_date[Op.gte] = from_date;
      if (to_date) where.due_date[Op.lte] = to_date;
    }

    if (overdue_only === 'true') {
      where.due_date = { [Op.lt]: new Date() };
      where.status = { [Op.in]: ['pending', 'in_progress'] };
    }

    if (today_only === 'true') {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);
      where.due_date = { [Op.gte]: today, [Op.lt]: tomorrow };
    }

    const { count, rows } = await Task.findAndCountAll({
      where,
      include: TASK_INCLUDE,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    return {
      tasks: rows,
      pagination: {
        total: count,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(count / limit)
      }
    };
  }

  async updateTask(id, userId, data) {
    const task = await Task.findOne({ where: { id, created_by: userId } });
    if (!task) throw new Error('TASK_NOT_FOUND');

    const { rabbit_id, cage_id, assigned_to, status, completed_at } = data;

    if (rabbit_id && rabbit_id !== task.rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: rabbit_id, user_id: userId } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    if (cage_id && cage_id !== task.cage_id) {
      const cage = await Cage.findOne({ where: { id: cage_id, user_id: userId } });
      if (!cage) throw new Error('CAGE_NOT_FOUND');
    }

    if (assigned_to) {
      const user = await User.findByPk(assigned_to);
      if (!user) throw new Error('ASSIGNEE_NOT_FOUND');
    }

    const updateData = { ...data };
    if (status === 'completed' && !completed_at) {
      updateData.completed_at = new Date();
    } else if (status !== 'completed') {
      updateData.completed_at = null;
    }

    await task.update(updateData);

    const updated = await Task.findByPk(id, { include: TASK_INCLUDE });
    logger.info('Task updated', { taskId: id });
    return updated;
  }

  async deleteTask(id, userId) {
    const task = await Task.findOne({ where: { id, created_by: userId } });
    if (!task) throw new Error('TASK_NOT_FOUND');
    await task.destroy();
    logger.info('Task deleted', { taskId: id });
    return { success: true };
  }

  async getStatistics(userId) {
    const where = {
      [Op.or]: [{ created_by: userId }, { assigned_to: userId }]
    };

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

  async getUpcoming(userId, days = 7) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const futureDate = new Date(today);
    futureDate.setDate(futureDate.getDate() + parseInt(days));

    return Task.findAll({
      where: {
        [Op.or]: [{ created_by: userId }, { assigned_to: userId }],
        due_date: { [Op.gte]: today, [Op.lt]: futureDate },
        status: { [Op.in]: ['pending', 'in_progress'] }
      },
      include: [TASK_INCLUDE[0], TASK_INCLUDE[1], TASK_INCLUDE[2]],
      order: [['due_date', 'ASC'], ['priority', 'DESC']]
    });
  }

  async completeTask(id, userId) {
    const task = await Task.findOne({
      where: { id, [Op.or]: [{ created_by: userId }, { assigned_to: userId }] }
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

    const updated = await Task.findByPk(id, { include: [TASK_INCLUDE[0], TASK_INCLUDE[1], TASK_INCLUDE[2]] });
    logger.info('Task completed', { taskId: id });
    return updated;
  }
}

module.exports = new TaskService();
