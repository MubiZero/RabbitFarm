const transactionService = require('../services/transactionService');
const fileStorage = require('../utils/fileStorage');
const ApiResponse = require('../utils/apiResponse');

/**
 * Transaction Controller
 * Handles all financial transaction operations (income and expenses)
 */

exports.create = async (req, res, next) => {
  try {
    // Чек снимают телефоном у кассы, поэтому он приходит файлом, а не
    // ссылкой: поле `receipt_url` существовало с самого начала, но взять
    // этот URL человеку было негде.
    delete req.body.receipt_attached;
    if (req.file) {
      req.body.receipt_url = await fileStorage.uploadFile(req.farmId, 'receipts', req.file);
    }

    const transaction = await transactionService.createTransaction({
      ...req.body,
      farm_id: req.farmId,
      author_id: req.user.id
    });
    return ApiResponse.success(res, transaction, 'Транзакция успешно создана', 201);
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404, 'RABBIT_NOT_FOUND');
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const transaction = await transactionService.getTransactionById(req.params.id, req.farmId);
    return ApiResponse.success(res, transaction, 'Транзакция получена');
  } catch (error) {
    if (error.message === 'TRANSACTION_NOT_FOUND') return ApiResponse.error(res, 'Транзакция не найдена', 404, 'TRANSACTION_NOT_FOUND');
    next(error);
  }
};

exports.list = async (req, res, next) => {
  try {
    const result = await transactionService.listTransactions(req.farmId, req.query);
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
    delete req.body.receipt_attached;
    if (req.file) {
      req.body.receipt_url = await fileStorage.uploadFile(req.farmId, 'receipts', req.file);
    }

    // Прежний чек убирается и когда его заменили, и когда сняли: файл,
    // на который больше никто не ссылается, иначе остаётся в хранилище
    // навсегда и молча занимает место фермы по тарифу.
    const previous = req.body.receipt_url !== undefined
      ? await transactionService.getTransactionById(req.params.id, req.farmId).catch(() => null)
      : null;

    const transaction = await transactionService.updateTransaction(req.params.id, req.farmId, req.body);

    if (previous && previous.receipt_url && previous.receipt_url !== transaction.receipt_url) {
      await fileStorage.deleteFile(previous.receipt_url);
    }
    return ApiResponse.success(res, transaction, 'Транзакция успешно обновлена');
  } catch (error) {
    if (error.message === 'TRANSACTION_NOT_FOUND') return ApiResponse.error(res, 'Транзакция не найдена', 404, 'TRANSACTION_NOT_FOUND');
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404, 'RABBIT_NOT_FOUND');
    next(error);
  }
};

exports.delete = async (req, res, next) => {
  try {
    await transactionService.deleteTransaction(req.params.id, req.farmId);
    return ApiResponse.success(res, null, 'Транзакция успешно удалена');
  } catch (error) {
    if (error.message === 'TRANSACTION_NOT_FOUND') return ApiResponse.error(res, 'Транзакция не найдена', 404, 'TRANSACTION_NOT_FOUND');
    next(error);
  }
};

exports.getStatistics = async (req, res, next) => {
  try {
    const stats = await transactionService.getStatistics(req.farmId, req.query);
    return ApiResponse.success(res, stats, 'Статистика получена');
  } catch (error) {
    next(error);
  }
};

exports.getRabbitTransactions = async (req, res, next) => {
  try {
    const result = await transactionService.getRabbitTransactions(req.params.rabbitId, req.farmId);
    return ApiResponse.success(res, result, 'Транзакции кролика получены');
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404, 'RABBIT_NOT_FOUND');
    next(error);
  }
};

exports.getMonthlyReport = async (req, res, next) => {
  try {
    const { year, month } = req.query;
    const result = await transactionService.getMonthlyReport(req.farmId, year, month);
    return ApiResponse.success(res, result, 'Месячный отчет получен');
  } catch (error) {
    if (error.message === 'YEAR_MONTH_REQUIRED') {
      return ApiResponse.error(res, 'Необходимо указать год и месяц', 400, 'PERIOD_REQUIRED');
    }
    next(error);
  }
};

module.exports = exports;
