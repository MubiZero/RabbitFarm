jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    Transaction: {
      findOne: jest.fn(),
      findByPk: jest.fn(),
      create: jest.fn(),
      count: jest.fn(),
      findAll: jest.fn(),
      findAndCountAll: jest.fn(),
      sum: jest.fn(),
      sequelize: {
        transaction: jest.fn()
      }
    },
    Rabbit: { findOne: jest.fn(), findByPk: jest.fn() },
    User: { findByPk: jest.fn() },
    sequelize: mockSequelize
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const { Transaction, Rabbit, User } = require('../../../src/models');
const transactionService = require('../../../src/services/transactionService');

const createMockTransaction = (overrides = {}) => ({
  id: 1,
  type: 'expense',
  category: 'feed',
  amount: '150.00',
  transaction_date: '2026-02-20',
  rabbit_id: null,
  description: 'Bought hay',
  receipt_url: null,
  created_by: 1,
  toJSON: function () { return { ...this }; },
  update: jest.fn().mockResolvedValue(true),
  destroy: jest.fn().mockResolvedValue(true),
  ...overrides
});

describe('TransactionService', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── createTransaction ────────────────────────────────────────────────────

  describe('createTransaction', () => {
    const mockDbTransaction = { commit: jest.fn(), rollback: jest.fn(), finished: false };

    beforeEach(() => {
      Transaction.sequelize.transaction.mockResolvedValue(mockDbTransaction);
    });

    it('should create a simple expense transaction successfully', async () => {
      const mockTx = createMockTransaction();
      Transaction.create.mockResolvedValue(mockTx);
      Transaction.findByPk.mockResolvedValue(mockTx);

      const result = await transactionService.createTransaction({
        type: 'expense',
        category: 'feed',
        amount: 150,
        transaction_date: '2026-02-20',
        user_id: 1
      });

      expect(Transaction.create).toHaveBeenCalled();
      expect(mockDbTransaction.commit).toHaveBeenCalled();
      expect(result).toBe(mockTx);
    });

    it('should throw RABBIT_NOT_FOUND when rabbit_id does not belong to user', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(
        transactionService.createTransaction({ type: 'expense', category: 'vet', amount: 100, rabbit_id: 99, user_id: 1 })
      ).rejects.toThrow('RABBIT_NOT_FOUND');

      expect(Transaction.create).not.toHaveBeenCalled();
      expect(mockDbTransaction.rollback).toHaveBeenCalled();
    });

    it('should mark rabbit as sold on income/sale transaction', async () => {
      const mockRabbit = { id: 1, update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(mockRabbit);

      const mockTx = createMockTransaction({ type: 'income', category: 'sale', rabbit_id: 1 });
      Transaction.create.mockResolvedValue(mockTx);
      Transaction.findByPk.mockResolvedValue(mockTx);

      await transactionService.createTransaction({
        type: 'income',
        category: 'sale',
        amount: 500,
        rabbit_id: 1,
        user_id: 1
      });

      expect(mockRabbit.update).toHaveBeenCalledWith(
        { status: 'sold', cage_id: null },
        expect.objectContaining({ transaction: mockDbTransaction })
      );
      expect(mockDbTransaction.commit).toHaveBeenCalled();
    });

    it('should mark rabbit as sold on income/продажа (Russian category) transaction', async () => {
      const mockRabbit = { id: 1, update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(mockRabbit);

      const mockTx = createMockTransaction({ type: 'income', category: 'Продажа', rabbit_id: 1 });
      Transaction.create.mockResolvedValue(mockTx);
      Transaction.findByPk.mockResolvedValue(mockTx);

      await transactionService.createTransaction({
        type: 'income',
        category: 'Продажа',
        amount: 500,
        rabbit_id: 1,
        user_id: 1
      });

      expect(mockRabbit.update).toHaveBeenCalledWith(
        { status: 'sold', cage_id: null },
        expect.any(Object)
      );
    });

    it('should NOT mark rabbit as sold on non-sale income', async () => {
      const mockRabbit = { id: 1, update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(mockRabbit);

      const mockTx = createMockTransaction({ type: 'income', category: 'other', rabbit_id: 1 });
      Transaction.create.mockResolvedValue(mockTx);
      Transaction.findByPk.mockResolvedValue(mockTx);

      await transactionService.createTransaction({
        type: 'income',
        category: 'other',
        amount: 100,
        rabbit_id: 1,
        user_id: 1
      });

      expect(mockRabbit.update).not.toHaveBeenCalled();
    });
  });

  // ─── getTransactionById ───────────────────────────────────────────────────

  describe('getTransactionById', () => {
    it('should return transaction when found', async () => {
      const mockTx = createMockTransaction();
      Transaction.findOne.mockResolvedValue(mockTx);

      const result = await transactionService.getTransactionById(1, 1);

      expect(result).toBe(mockTx);
    });

    it('should throw TRANSACTION_NOT_FOUND when not found', async () => {
      Transaction.findOne.mockResolvedValue(null);

      await expect(transactionService.getTransactionById(999, 1)).rejects.toThrow('TRANSACTION_NOT_FOUND');
    });
  });

  // ─── listTransactions ─────────────────────────────────────────────────────

  describe('listTransactions', () => {
    it('should return paginated transactions with defaults', async () => {
      Transaction.findAndCountAll.mockResolvedValue({
        count: 3,
        rows: [createMockTransaction(), createMockTransaction({ id: 2 }), createMockTransaction({ id: 3 })]
      });

      const result = await transactionService.listTransactions(1);

      expect(result.transactions).toHaveLength(3);
      expect(result.pagination.total).toBe(3);
      expect(result.pagination.page).toBe(1);
    });

    it('should apply type, category, rabbit_id filters', async () => {
      Transaction.findAndCountAll.mockResolvedValue({ count: 1, rows: [createMockTransaction()] });

      await transactionService.listTransactions(1, { type: 'income', category: 'sale', rabbit_id: 5 });

      const callArg = Transaction.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.type).toBe('income');
      expect(callArg.where.category).toBe('sale');
      expect(callArg.where.rabbit_id).toBe(5);
    });

    it('should apply date range filters', async () => {
      Transaction.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await transactionService.listTransactions(1, { from_date: '2026-01-01', to_date: '2026-12-31' });

      const callArg = Transaction.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.transaction_date).toBeDefined();
    });

    it('should apply amount range filters', async () => {
      Transaction.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await transactionService.listTransactions(1, { min_amount: 50, max_amount: 200 });

      const callArg = Transaction.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.amount).toBeDefined();
    });
  });

  // ─── updateTransaction ────────────────────────────────────────────────────

  describe('updateTransaction', () => {
    it('should throw TRANSACTION_NOT_FOUND when transaction does not exist', async () => {
      Transaction.findOne.mockResolvedValue(null);

      await expect(transactionService.updateTransaction(999, 1, {})).rejects.toThrow('TRANSACTION_NOT_FOUND');
    });

    it('should update transaction successfully', async () => {
      const mockTx = createMockTransaction();
      Transaction.findOne.mockResolvedValue(mockTx);
      Transaction.findByPk.mockResolvedValue(mockTx);

      const result = await transactionService.updateTransaction(1, 1, { description: 'Updated' });

      expect(mockTx.update).toHaveBeenCalledWith({ description: 'Updated' });
      expect(result).toBe(mockTx);
    });

    it('should throw RABBIT_NOT_FOUND when changing to non-existent rabbit', async () => {
      const mockTx = createMockTransaction({ rabbit_id: 1 });
      Transaction.findOne.mockResolvedValue(mockTx);
      Rabbit.findOne.mockResolvedValue(null);

      await expect(transactionService.updateTransaction(1, 1, { rabbit_id: 99 })).rejects.toThrow('RABBIT_NOT_FOUND');
    });
  });

  // ─── deleteTransaction ────────────────────────────────────────────────────

  describe('deleteTransaction', () => {
    it('should delete transaction successfully', async () => {
      const mockTx = createMockTransaction();
      Transaction.findOne.mockResolvedValue(mockTx);

      const result = await transactionService.deleteTransaction(1, 1);

      expect(mockTx.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('should throw TRANSACTION_NOT_FOUND when transaction does not exist', async () => {
      Transaction.findOne.mockResolvedValue(null);

      await expect(transactionService.deleteTransaction(999, 1)).rejects.toThrow('TRANSACTION_NOT_FOUND');
    });
  });

  // ─── getStatistics ────────────────────────────────────────────────────────

  describe('getStatistics', () => {
    it('should return full statistics with net_profit calculation', async () => {
      Transaction.sum
        .mockResolvedValueOnce(1000)  // total income
        .mockResolvedValueOnce(400);  // total expenses

      Transaction.findAll
        .mockResolvedValueOnce([
          { category: 'sale', dataValues: { total: '1000.00', count: '2' } }
        ])
        .mockResolvedValueOnce([
          { category: 'feed', dataValues: { total: '400.00', count: '3' } }
        ])
        .mockResolvedValueOnce([]); // recent transactions

      Transaction.count.mockResolvedValue(5);

      const result = await transactionService.getStatistics(1);

      expect(result.total_income).toBe('1000.00');
      expect(result.total_expenses).toBe('400.00');
      expect(result.net_profit).toBe('600.00');
      expect(result.total_transactions).toBe(5);
      expect(result.income_by_category).toEqual([{ category: 'sale', total: '1000.00', count: 2 }]);
      expect(result.expenses_by_category).toEqual([{ category: 'feed', total: '400.00', count: 3 }]);
    });

    it('should default to 0 when sum returns null', async () => {
      Transaction.sum
        .mockResolvedValueOnce(null) // income null -> should become 0
        .mockResolvedValueOnce(null); // expenses null -> should become 0

      Transaction.findAll.mockResolvedValue([]);
      Transaction.count.mockResolvedValue(0);

      const result = await transactionService.getStatistics(1);

      expect(result.total_income).toBe('0.00');
      expect(result.total_expenses).toBe('0.00');
      expect(result.net_profit).toBe('0.00');
    });

    it('should apply date range filters to statistics', async () => {
      Transaction.sum.mockResolvedValue(0);
      Transaction.findAll.mockResolvedValue([]);
      Transaction.count.mockResolvedValue(0);

      await transactionService.getStatistics(1, { from_date: '2026-01-01', to_date: '2026-01-31' });

      // Verify that sum was called with date filters
      const callArg = Transaction.sum.mock.calls[0][1];
      expect(callArg.where.transaction_date).toBeDefined();
    });
  });

  // ─── getRabbitTransactions ────────────────────────────────────────────────

  describe('getRabbitTransactions', () => {
    it('should throw RABBIT_NOT_FOUND when rabbit does not belong to user', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(transactionService.getRabbitTransactions(99, 1)).rejects.toThrow('RABBIT_NOT_FOUND');
    });

    it('should return transactions and summary for a rabbit', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });

      const rows = [
        { type: 'income', amount: '500.00' },
        { type: 'expense', amount: '50.00' }
      ];
      Transaction.findAll.mockResolvedValue(rows);

      const result = await transactionService.getRabbitTransactions(1, 1);

      expect(result.transactions).toBe(rows);
      expect(result.summary.total_income).toBe('500.00');
      expect(result.summary.total_expenses).toBe('50.00');
      expect(result.summary.net_profit).toBe('450.00');
    });

    it('should return zero summary when rabbit has no transactions', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Transaction.findAll.mockResolvedValue([]);

      const result = await transactionService.getRabbitTransactions(1, 1);

      expect(result.summary.total_income).toBe('0.00');
      expect(result.summary.total_expenses).toBe('0.00');
      expect(result.summary.net_profit).toBe('0.00');
    });
  });

  // ─── getMonthlyReport ─────────────────────────────────────────────────────

  describe('getMonthlyReport', () => {
    it('should throw YEAR_MONTH_REQUIRED when year or month is missing', async () => {
      await expect(transactionService.getMonthlyReport(1, null, null)).rejects.toThrow('YEAR_MONTH_REQUIRED');
      await expect(transactionService.getMonthlyReport(1, 2026, null)).rejects.toThrow('YEAR_MONTH_REQUIRED');
    });

    it('should return monthly report with correct period and summary', async () => {
      const rows = [
        { type: 'income', amount: '200.00' },
        { type: 'expense', amount: '80.00' }
      ];
      Transaction.findAll.mockResolvedValue(rows);

      const result = await transactionService.getMonthlyReport(1, 2026, 2);

      expect(result.period.year).toBe(2026);
      expect(result.period.month).toBe(2);
      expect(result.period.start_date).toBe('2026-02-01');
      expect(result.summary.total_income).toBe('200.00');
      expect(result.summary.total_expenses).toBe('80.00');
      expect(result.summary.net_profit).toBe('120.00');
      expect(result.summary.transaction_count).toBe(2);
    });

    it('should return zero summary for a month with no transactions', async () => {
      Transaction.findAll.mockResolvedValue([]);

      const result = await transactionService.getMonthlyReport(1, 2025, 1);

      expect(result.summary.total_income).toBe('0.00');
      expect(result.summary.total_expenses).toBe('0.00');
      expect(result.summary.transaction_count).toBe(0);
    });
  });
});
