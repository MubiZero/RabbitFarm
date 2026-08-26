const transactionService = require('../services/transactionService');
const ApiResponse = require('../utils/apiResponse');
const { farmMemberIds } = require('../utils/farm');

/**
 * Transaction Controller
 * Handles all financial transaction operations (income and expenses)
 */

/**
 * Ферма запроса: её идентификатор и состав.
 *
 * Идентификатор нужен для проверки поголовья (кролик принадлежит ферме),
 * состав — для самой книги: у транзакции нет колонки фермы, она опознаётся
 * по автору, а автором может быть любой работник хозяйства.
 */
const requestFarm = async (req) => ({
  id: req.farmId,
  memberIds: await farmMemberIds(req.farmId)
});

exports.create = async (req, res, next) => {
  try {
    const transaction = await transactionService.createTransaction({
      ...req.body,
      farm_id: req.farmId,
      author_id: req.user.id
    });
    return ApiResponse.success(res, transaction, 'Транзакция успешно создана', 201);
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const transaction = await transactionService.getTransactionById(req.params.id, await requestFarm(req));
    return ApiResponse.success(res, transaction, 'Транзакция получена');
  } catch (error) {
    if (error.message === 'TRANSACTION_NOT_FOUND') return ApiResponse.error(res, 'Транзакция не найдена', 404);
    next(error);
  }
};

exports.list = async (req, res, next) => {
  try {
    const result = await transactionService.listTransactions(await requestFarm(req), req.query);
    // Общий конверт пагинации. Раньше каждый сервис лепил свой: items/rows/
    // tasks/transactions и totalPages/pages — клиенту приходилось угадывать
    // форму в каждом репозитории, и в медкартах он угадал неверно.
    return ApiResponse.paginated(res, result.items, result.page, result.limit, result.total, 'Список транзакций получен');
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const transaction = await transactionService.updateTransaction(req.params.id, await requestFarm(req), req.body);
    return ApiResponse.success(res, transaction, 'Транзакция успешно обновлена');
  } catch (error) {
    if (error.message === 'TRANSACTION_NOT_FOUND') return ApiResponse.error(res, 'Транзакция не найдена', 404);
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    next(error);
  }
};

exports.delete = async (req, res, next) => {
  try {
    await transactionService.deleteTransaction(req.params.id, await requestFarm(req));
    return ApiResponse.success(res, null, 'Транзакция успешно удалена');
  } catch (error) {
    if (error.message === 'TRANSACTION_NOT_FOUND') return ApiResponse.error(res, 'Транзакция не найдена', 404);
    next(error);
  }
};

exports.getStatistics = async (req, res, next) => {
  try {
    const stats = await transactionService.getStatistics(await requestFarm(req), req.query);
    return ApiResponse.success(res, stats, 'Статистика получена');
  } catch (error) {
    next(error);
  }
};

exports.getRabbitTransactions = async (req, res, next) => {
  try {
    const result = await transactionService.getRabbitTransactions(req.params.rabbitId, await requestFarm(req));
    return ApiResponse.success(res, result, 'Транзакции кролика получены');
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    next(error);
  }
};

exports.getMonthlyReport = async (req, res, next) => {
  try {
    const { year, month } = req.query;
    const result = await transactionService.getMonthlyReport(await requestFarm(req), year, month);
    return ApiResponse.success(res, result, 'Месячный отчет получен');
  } catch (error) {
    if (error.message === 'YEAR_MONTH_REQUIRED') {
      return ApiResponse.error(res, 'Необходимо указать год и месяц', 400);
    }
    next(error);
  }
};

module.exports = exports;
