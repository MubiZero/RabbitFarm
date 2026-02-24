const taskService = require('../services/taskService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Task Controller
 * Handles all task and reminder operations
 */

exports.create = async (req, res, next) => {
  try {
    const task = await taskService.createTask({ ...req.body, user_id: req.user.id });
    return ApiResponse.success(res, task, 'Задача успешно создана', 201);
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.error(res, 'Клетка не найдена', 404);
    if (error.message === 'ASSIGNEE_NOT_FOUND') return ApiResponse.error(res, 'Исполнитель не найден', 404);
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const task = await taskService.getTaskById(req.params.id, req.user.id);
    return ApiResponse.success(res, task, 'Задача получена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    next(error);
  }
};

exports.list = async (req, res, next) => {
  try {
    const result = await taskService.listTasks(req.user.id, req.query);
    return ApiResponse.success(res, result, 'Список задач получен');
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const task = await taskService.updateTask(req.params.id, req.user.id, req.body);
    return ApiResponse.success(res, task, 'Задача успешно обновлена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.error(res, 'Клетка не найдена', 404);
    if (error.message === 'ASSIGNEE_NOT_FOUND') return ApiResponse.error(res, 'Пользователь не найден', 404);
    next(error);
  }
};

exports.delete = async (req, res, next) => {
  try {
    await taskService.deleteTask(req.params.id, req.user.id);
    return ApiResponse.success(res, null, 'Задача успешно удалена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    next(error);
  }
};

exports.getStatistics = async (req, res, next) => {
  try {
    const stats = await taskService.getStatistics(req.user.id);
    return ApiResponse.success(res, stats, 'Статистика получена');
  } catch (error) {
    next(error);
  }
};

exports.getUpcoming = async (req, res, next) => {
  try {
    const { days = 7 } = req.query;
    const tasks = await taskService.getUpcoming(req.user.id, days);
    return ApiResponse.success(res, tasks, 'Предстоящие задачи получены');
  } catch (error) {
    next(error);
  }
};

exports.completeTask = async (req, res, next) => {
  try {
    const task = await taskService.completeTask(req.params.id, req.user.id);
    return ApiResponse.success(res, task, 'Задача выполнена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    next(error);
  }
};

module.exports = exports;
