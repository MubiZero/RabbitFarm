const taskService = require('../services/taskService');
const ApiResponse = require('../utils/apiResponse');
const { localizeTask } = require('../i18n/tasks');

/**
 * Task Controller
 * Handles all task and reminder operations
 */

/**
 * Задачи, заведённые сервером (пальпация, маточник, отсадка), отдаются на
 * языке того, кто их запросил: в базе лежит ключ шаблона, а не готовый
 * русский текст. Задачи, написанные человеком, проходят как есть.
 */
const forReader = (req) => (task) => localizeTask(task, req.user.language);

exports.create = async (req, res, next) => {
  try {
    const task = await taskService.createTask({ ...req.body, farm_id: req.farmId, author_id: req.user.id });
    return ApiResponse.success(res, forReader(req)(task), 'Задача успешно создана', 201);
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.error(res, 'Клетка не найдена', 404);
    if (error.message === 'ASSIGNEE_NOT_FOUND') return ApiResponse.error(res, 'Исполнитель не найден', 404);
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const task = await taskService.getTaskById(req.params.id, req.farmId);
    return ApiResponse.success(res, forReader(req)(task), 'Задача получена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    next(error);
  }
};

exports.list = async (req, res, next) => {
  try {
    const result = await taskService.listTasks(req.farmId, req.query, req.farmTimezone);
    // Общий конверт пагинации. Раньше каждый сервис лепил свой: items/rows/
    // tasks/transactions и totalPages/pages — клиенту приходилось угадывать
    // форму в каждом репозитории, и в медкартах он угадал неверно.
    return ApiResponse.paginated(res, result.items.map(forReader(req)), result.page, result.limit, result.total, 'Список задач получен');
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const task = await taskService.updateTask(req.params.id, req.farmId, req.body, req.user.id);
    return ApiResponse.success(res, forReader(req)(task), 'Задача успешно обновлена');
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
    await taskService.deleteTask(req.params.id, req.farmId);
    return ApiResponse.success(res, null, 'Задача успешно удалена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    next(error);
  }
};

exports.getStatistics = async (req, res, next) => {
  try {
    const stats = await taskService.getStatistics(req.farmId);
    return ApiResponse.success(res, stats, 'Статистика получена');
  } catch (error) {
    next(error);
  }
};

exports.getUpcoming = async (req, res, next) => {
  try {
    const { days = 7 } = req.query;
    const tasks = await taskService.getUpcoming(req.farmId, days);
    return ApiResponse.success(res, tasks.map(forReader(req)), 'Предстоящие задачи получены');
  } catch (error) {
    next(error);
  }
};

exports.completeTask = async (req, res, next) => {
  try {
    const task = await taskService.completeTask(req.params.id, req.farmId);
    return ApiResponse.success(res, forReader(req)(task), 'Задача выполнена');
  } catch (error) {
    if (error.message === 'TASK_NOT_FOUND') return ApiResponse.error(res, 'Задача не найдена', 404);
    next(error);
  }
};

module.exports = exports;
