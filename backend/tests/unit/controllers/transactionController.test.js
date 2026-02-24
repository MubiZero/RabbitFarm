jest.mock('../../../src/services/transactionService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const transactionService = require('../../../src/services/transactionService');
const transactionController = require('../../../src/controllers/transactionController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  params: {},
  body: {},
  query: {},
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('TransactionController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('should create transaction and return 200 with 201 statusCode', async () => {
      const transaction = { id: 1, amount: 100, type: 'income' };
      transactionService.createTransaction.mockResolvedValue(transaction);
      const req = mockReq({ body: { amount: 100, type: 'income' } });
      const res = mockRes();

      await transactionController.create(req, res, mockNext);

      expect(transactionService.createTransaction).toHaveBeenCalledWith({ amount: 100, type: 'income', user_id: 1 });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: transaction }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      transactionService.createTransaction.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ body: { rabbit_id: 99 } });
      const res = mockRes();

      await transactionController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.createTransaction.mockRejectedValue(err);
      const req = mockReq({ body: {} });
      const res = mockRes();

      await transactionController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getById', () => {
    it('should return transaction with 200', async () => {
      const transaction = { id: 1, amount: 100 };
      transactionService.getTransactionById.mockResolvedValue(transaction);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await transactionController.getById(req, res, mockNext);

      expect(transactionService.getTransactionById).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: transaction }));
    });

    it('should return 404 when TRANSACTION_NOT_FOUND', async () => {
      transactionService.getTransactionById.mockRejectedValue(new Error('TRANSACTION_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await transactionController.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.getTransactionById.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await transactionController.getById(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('list', () => {
    it('should return transaction list with 200', async () => {
      const result = { items: [{ id: 1 }], total: 1 };
      transactionService.listTransactions.mockResolvedValue(result);
      const req = mockReq({ query: { page: '1' } });
      const res = mockRes();

      await transactionController.list(req, res, mockNext);

      expect(transactionService.listTransactions).toHaveBeenCalledWith(1, { page: '1' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.listTransactions.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await transactionController.list(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('update', () => {
    it('should update transaction and return 200', async () => {
      const transaction = { id: 1, amount: 200 };
      transactionService.updateTransaction.mockResolvedValue(transaction);
      const req = mockReq({ params: { id: '1' }, body: { amount: 200 } });
      const res = mockRes();

      await transactionController.update(req, res, mockNext);

      expect(transactionService.updateTransaction).toHaveBeenCalledWith('1', 1, { amount: 200 });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: transaction }));
    });

    it('should return 404 when TRANSACTION_NOT_FOUND', async () => {
      transactionService.updateTransaction.mockRejectedValue(new Error('TRANSACTION_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: {} });
      const res = mockRes();

      await transactionController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when RABBIT_NOT_FOUND on update', async () => {
      transactionService.updateTransaction.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '1' }, body: { rabbit_id: 99 } });
      const res = mockRes();

      await transactionController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.updateTransaction.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await transactionController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('delete', () => {
    it('should delete transaction and return 200', async () => {
      transactionService.deleteTransaction.mockResolvedValue();
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await transactionController.delete(req, res, mockNext);

      expect(transactionService.deleteTransaction).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: null }));
    });

    it('should return 404 when TRANSACTION_NOT_FOUND', async () => {
      transactionService.deleteTransaction.mockRejectedValue(new Error('TRANSACTION_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await transactionController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.deleteTransaction.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await transactionController.delete(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getStatistics', () => {
    it('should return statistics with 200', async () => {
      const stats = { totalIncome: 1000, totalExpense: 500 };
      transactionService.getStatistics.mockResolvedValue(stats);
      const req = mockReq({ query: { period: 'month' } });
      const res = mockRes();

      await transactionController.getStatistics(req, res, mockNext);

      expect(transactionService.getStatistics).toHaveBeenCalledWith(1, { period: 'month' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: stats }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.getStatistics.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await transactionController.getStatistics(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getRabbitTransactions', () => {
    it('should return rabbit transactions with 200', async () => {
      const result = [{ id: 1, amount: 50 }];
      transactionService.getRabbitTransactions.mockResolvedValue(result);
      const req = mockReq({ params: { rabbitId: '5' } });
      const res = mockRes();

      await transactionController.getRabbitTransactions(req, res, mockNext);

      expect(transactionService.getRabbitTransactions).toHaveBeenCalledWith('5', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      transactionService.getRabbitTransactions.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { rabbitId: '99' } });
      const res = mockRes();

      await transactionController.getRabbitTransactions(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.getRabbitTransactions.mockRejectedValue(err);
      const req = mockReq({ params: { rabbitId: '1' } });
      const res = mockRes();

      await transactionController.getRabbitTransactions(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getMonthlyReport', () => {
    it('should return monthly report with 200', async () => {
      const result = { month: 1, year: 2025, income: 500, expense: 200 };
      transactionService.getMonthlyReport.mockResolvedValue(result);
      const req = mockReq({ query: { year: '2025', month: '1' } });
      const res = mockRes();

      await transactionController.getMonthlyReport(req, res, mockNext);

      expect(transactionService.getMonthlyReport).toHaveBeenCalledWith(1, '2025', '1');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should return 400 when YEAR_MONTH_REQUIRED', async () => {
      transactionService.getMonthlyReport.mockRejectedValue(new Error('YEAR_MONTH_REQUIRED'));
      const req = mockReq({ query: {} });
      const res = mockRes();

      await transactionController.getMonthlyReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      transactionService.getMonthlyReport.mockRejectedValue(err);
      const req = mockReq({ query: { year: '2025', month: '1' } });
      const res = mockRes();

      await transactionController.getMonthlyReport(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
