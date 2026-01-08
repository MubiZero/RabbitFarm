const { Task, Rabbit, Cage, User } = require('../models');
const { Op } = require('sequelize');
const ApiResponse = require('../utils/apiResponse');

/**
 * Task Controller
 * Handles all task and reminder operations
 */

/**
 * Create a new task
 * POST /api/v1/tasks
 */
exports.create = async (req, res, next) => {
  try {
    const {
      title,
      description,
      type,
      status,
      priority,
      due_date,
      rabbit_id,
      cage_id,
      assigned_to,
      is_recurring,
      recurrence_rule,
      reminder_before,
      notes
    } = req.body;

    // Validate rabbit_id if provided
    if (rabbit_id) {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbit_id,
          user_id: req.user.id
        }
      });
      if (!rabbit) {
        return ApiResponse.error(res, 'Кролик не найден', 404);
      }
    }

    // Validate cage_id if provided and belongs to user
    if (cage_id) {
      const cage = await Cage.findOne({
        where: { id: cage_id, user_id: req.user.id }
      });
      if (!cage) {
        return ApiResponse.error(res, 'Клетка не найдена', 404);
      }
    }

    // Validate assigned_to if provided
    if (assigned_to) {
      const user = await User.findByPk(assigned_to);
      if (!user) {
        return ApiResponse.error(res, 'Исполнитель не найден', 404);
      }
    }

    const task = await Task.create({
      title,
      description,
      type,
      status: status || 'pending',
      priority: priority || 'medium',
      due_date,
      rabbit_id,
      cage_id,
      assigned_to,
      created_by: req.user.id,
      is_recurring: is_recurring || false,
      recurrence_rule,
      reminder_before,
      notes
    });

    // Fetch created task with associations
    const createdTask = await Task.findByPk(task.id, {
      include: [
        {
          model: Rabbit,
          as: 'rabbit'
        },
        {
          model: Cage,
          as: 'cage'
        },
        {
          model: User,
          as: 'assignedTo',
          attributes: ['id', 'full_name', 'email']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'full_name', 'email']
        }
      ]
    });

    return ApiResponse.success(res, createdTask, 'Задача успешно создана', 201);
  } catch (error) {
    next(error);
  }
};

/**
 * Get task by ID
 * GET /api/v1/tasks/:id
 */
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const task = await Task.findOne({
      where: {
        id,
        created_by: req.user.id // Verify ownership
      },
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'tag_id']
        },
        {
          model: Cage,
          as: 'cage',
          attributes: ['id', 'number', 'location']
        },
        {
          model: User,
          as: 'assignedTo',
          attributes: ['id', 'full_name', 'email']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'full_name', 'email']
        }
      ]
    });

    if (!task) {
      return ApiResponse.error(res, 'Задача не найдена', 404);
    }

    return ApiResponse.success(res, task, 'Задача получена');
  } catch (error) {
    next(error);
  }
};

/**
 * Get list of tasks with filters
 * GET /api/v1/tasks
 */
exports.list = async (req, res, next) => {
  try {
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
      created_by,
      from_date,
      to_date,
      overdue_only,
      today_only
    } = req.query;

    const offset = (page - 1) * limit;
    const where = {
      created_by: req.user.id // Filter by user
    };

    // Filters
    if (type) {
      where.type = type;
    }

    if (status) {
      where.status = status;
    }

    if (priority) {
      where.priority = priority;
    }

    if (rabbit_id) {
      where.rabbit_id = rabbit_id;
    }

    if (cage_id) {
      where.cage_id = cage_id;
    }

    if (assigned_to) {
      where.assigned_to = assigned_to;
    }

    if (created_by) {
      where.created_by = created_by;
    }

    // Date filters
    if (from_date || to_date) {
      where.due_date = {};
      if (from_date) {
        where.due_date[Op.gte] = from_date;
      }
      if (to_date) {
        where.due_date[Op.lte] = to_date;
      }
    }

    // Overdue tasks only
    if (overdue_only === 'true') {
      where.due_date = {
        [Op.lt]: new Date()
      };
      where.status = {
        [Op.in]: ['pending', 'in_progress']
      };
    }

    // Today's tasks only
    if (today_only === 'true') {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);

      where.due_date = {
        [Op.gte]: today,
        [Op.lt]: tomorrow
      };
    }

    const { count, rows } = await Task.findAndCountAll({
      where,
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'tag_id']
        },
        {
          model: Cage,
          as: 'cage',
          attributes: ['id', 'number', 'location']
        },
        {
          model: User,
          as: 'assignedTo',
          attributes: ['id', 'full_name', 'email']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'full_name', 'email']
        }
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    return ApiResponse.success(res, {
      tasks: rows,
      pagination: {
        total: count,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(count / limit)
      }
    }, 'Список задач получен');
  } catch (error) {
    next(error);
  }
};

/**
 * Update task
 * PUT /api/v1/tasks/:id
 */
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const {
      title,
      description,
      type,
      status,
      priority,
      due_date,
      completed_at,
      rabbit_id,
      cage_id,
      assigned_to,
      is_recurring,
      recurrence_rule,
      reminder_before,
      notes
    } = req.body;

    const task = await Task.findOne({
      where: {
        id,
        created_by: req.user.id // Verify ownership
      }
    });

    if (!task) {
      return ApiResponse.error(res, 'Задача не найдена', 404);
    }

    // Validate references if provided
    if (rabbit_id && rabbit_id !== task.rabbit_id) {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbit_id,
          user_id: req.user.id
        }
      });
      if (!rabbit) {
        return ApiResponse.error(res, 'Кролик не найден', 404);
      }
    }

    if (cage_id && cage_id !== task.cage_id) {
      const cage = await Cage.findOne({
        where: { id: cage_id, user_id: req.user.id }
      });
      if (!cage) {
        return ApiResponse.error(res, 'Клетка не найдена', 404);
      }
    }

    if (assigned_to) {
      const user = await User.findByPk(assigned_to);
      if (!user) {
        return ApiResponse.error(res, 'Пользователь не найден', 404);
      }
    }

    // Auto-set completed_at when status changes to completed
    let updateData = {
      title,
      description,
      type,
      status,
      priority,
      due_date,
      rabbit_id,
      cage_id,
      assigned_to,
      is_recurring,
      recurrence_rule,
      reminder_before,
      notes
    };

    if (status === 'completed' && !completed_at) {
      updateData.completed_at = new Date();
    } else if (status !== 'completed') {
      updateData.completed_at = null;
    } else if (completed_at) {
      updateData.completed_at = completed_at;
    }

    await task.update(updateData);

    // Fetch updated task with associations
    const updatedTask = await Task.findByPk(id, {
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'tag_id']
        },
        {
          model: Cage,
          as: 'cage',
          attributes: ['id', 'number', 'location']
        },
        {
          model: User,
          as: 'assignedTo',
          attributes: ['id', 'full_name', 'email']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'full_name', 'email']
        }
      ]
    });

    return ApiResponse.success(res, updatedTask, 'Задача успешно обновлена');
  } catch (error) {
    next(error);
  }
};

/**
 * Delete task
 * DELETE /api/v1/tasks/:id
 */
exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;

    const task = await Task.findOne({
      where: {
        id,
        created_by: req.user.id // Verify ownership
      }
    });

    if (!task) {
      return ApiResponse.error(res, 'Задача не найдена', 404);
    }

    await task.destroy();

    return ApiResponse.success(res, null, 'Задача успешно удалена');
  } catch (error) {
    next(error);
  }
};

/**
 * Get task statistics
 * GET /api/v1/tasks/statistics
 */
exports.getStatistics = async (req, res, next) => {
  try {
    const where = { created_by: req.user.id };

    // Total tasks by status
    const totalPending = await Task.count({ where: { ...where, status: 'pending' } });
    const totalInProgress = await Task.count({ where: { ...where, status: 'in_progress' } });
    const totalCompleted = await Task.count({ where: { ...where, status: 'completed' } });
    const totalCancelled = await Task.count({ where: { ...where, status: 'cancelled' } });

    // Overdue tasks
    const overdueCount = await Task.count({
      where: {
        ...where,
        due_date: {
          [Op.lt]: new Date()
        },
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      }
    });

    // Today's tasks
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const todayCount = await Task.count({
      where: {
        ...where,
        due_date: {
          [Op.gte]: today,
          [Op.lt]: tomorrow
        },
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      }
    });

    // Tasks by type
    const tasksByType = await Task.findAll({
      attributes: [
        'type',
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      where,
      group: ['type']
    });

    // Tasks by priority
    const tasksByPriority = await Task.findAll({
      attributes: [
        'priority',
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      where: {
        ...where,
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      },
      group: ['priority']
    });

    return ApiResponse.success(res, {
      total_pending: totalPending,
      total_in_progress: totalInProgress,
      total_completed: totalCompleted,
      total_cancelled: totalCancelled,
      overdue_count: overdueCount,
      today_count: todayCount,
      tasks_by_type: tasksByType.map(item => ({
        type: item.type,
        count: parseInt(item.dataValues.count)
      })),
      tasks_by_priority: tasksByPriority.map(item => ({
        priority: item.priority,
        count: parseInt(item.dataValues.count)
      }))
    }, 'Статистика получена');
  } catch (error) {
    next(error);
  }
};

/**
 * Get upcoming tasks
 * GET /api/v1/tasks/upcoming
 */
exports.getUpcoming = async (req, res, next) => {
  try {
    const { days = 7 } = req.query;

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const futureDate = new Date(today);
    futureDate.setDate(futureDate.getDate() + parseInt(days));

    const tasks = await Task.findAll({
      where: {
        created_by: req.user.id, // Filter by user
        due_date: {
          [Op.gte]: today,
          [Op.lt]: futureDate
        },
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      },
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'tag_id']
        },
        {
          model: Cage,
          as: 'cage',
          attributes: ['id', 'number', 'location']
        },
        {
          model: User,
          as: 'assignedTo',
          attributes: ['id', 'full_name', 'email']
        }
      ],
      order: [['due_date', 'ASC'], ['priority', 'DESC']]
    });

    return ApiResponse.success(res, tasks, 'Предстоящие задачи получены');
  } catch (error) {
    next(error);
  }
};

/**
 * Complete task
 * POST /api/v1/tasks/:id/complete
 */
exports.completeTask = async (req, res, next) => {
  try {
    const { id } = req.params;

    const task = await Task.findOne({
      where: {
        id,
        created_by: req.user.id // Verify ownership
      }
    });

    if (!task) {
      return ApiResponse.error(res, 'Задача не найдена', 404);
    }

    await task.update({
      status: 'completed',
      completed_at: new Date()
    });

    const updatedTask = await Task.findByPk(id, {
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'tag_id']
        },
        {
          model: Cage,
          as: 'cage',
          attributes: ['id', 'number', 'location']
        },
        {
          model: User,
          as: 'assignedTo',
          attributes: ['id', 'full_name', 'email']
        }
      ]
    });

    return ApiResponse.success(res, updatedTask, 'Задача выполнена');
  } catch (error) {
    next(error);
  }
};

module.exports = exports;
