const { Transaction, Rabbit, User } = require('../models');
const { Op, fn, col } = require('sequelize');
const logger = require('../utils/logger');

const TRANSACTION_INCLUDE = [
  { model: Rabbit, as: 'rabbit', attributes: ['id', 'name', 'tag_id'] },
  { model: User, as: 'creator', attributes: ['id', 'full_name', 'email'] }
];

/**
 * Transaction service
 * Business logic for financial transaction management
 */
class TransactionService {
  async createTransaction(data) {
    const t = await Transaction.sequelize.transaction();
    try {
      const { rabbit_id, type, category, user_id } = data;

      let rabbit = null;
      if (rabbit_id) {
        rabbit = await Rabbit.findOne({ where: { id: rabbit_id, user_id }, transaction: t });
        if (!rabbit) {
          await t.rollback();
          throw new Error('RABBIT_NOT_FOUND');
        }
      }

      const transaction = await Transaction.create({
        type,
        category,
        amount: data.amount,
        transaction_date: data.transaction_date,
        rabbit_id,
        description: data.description,
        receipt_url: data.receipt_url,
        created_by: user_id
      }, { transaction: t });

      // If selling a rabbit, mark it as sold
      if (rabbit && type === 'income' &&
        (category?.toLowerCase() === 'sale' || category?.toLowerCase() === 'продажа')) {
        await rabbit.update({ status: 'sold', cage_id: null }, { transaction: t });
      }

      await t.commit();

      const created = await Transaction.findByPk(transaction.id, {
        include: [
          { ...TRANSACTION_INCLUDE[0], where: { user_id }, required: false },
          TRANSACTION_INCLUDE[1]
        ]
      });

      logger.info('Transaction created', { transactionId: transaction.id });
      return created;
    } catch (error) {
      if (t && !t.finished) await t.rollback();
      logger.error('Create transaction error', { error: error.message });
      throw error;
    }
  }

  async getTransactionById(id, userId) {
    const transaction = await Transaction.findOne({
      where: { id, created_by: userId },
      include: TRANSACTION_INCLUDE
    });
    if (!transaction) throw new Error('TRANSACTION_NOT_FOUND');
    return transaction;
  }

  async listTransactions(userId, filters = {}) {
    const {
      page = 1,
      limit = 10,
      sort_by = 'transaction_date',
      sort_order = 'DESC',
      type,
      category,
      rabbit_id,
      from_date,
      to_date,
      min_amount,
      max_amount
    } = filters;

    const offset = (page - 1) * limit;
    const where = { created_by: userId };

    if (type) where.type = type;
    if (category) where.category = category;
    if (rabbit_id) where.rabbit_id = rabbit_id;

    if (from_date || to_date) {
      where.transaction_date = {};
      if (from_date) where.transaction_date[Op.gte] = from_date;
      if (to_date) where.transaction_date[Op.lte] = to_date;
    }

    if (min_amount || max_amount) {
      where.amount = {};
      if (min_amount) where.amount[Op.gte] = min_amount;
      if (max_amount) where.amount[Op.lte] = max_amount;
    }

    const { count, rows } = await Transaction.findAndCountAll({
      where,
      include: TRANSACTION_INCLUDE,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    return {
      transactions: rows,
      pagination: {
        total: count,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(count / limit)
      }
    };
  }

  async updateTransaction(id, userId, data) {
    const transaction = await Transaction.findOne({ where: { id, created_by: userId } });
    if (!transaction) throw new Error('TRANSACTION_NOT_FOUND');

    if (data.rabbit_id && data.rabbit_id !== transaction.rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: data.rabbit_id, user_id: userId } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    await transaction.update(data);

    const updated = await Transaction.findByPk(id, { include: TRANSACTION_INCLUDE });
    logger.info('Transaction updated', { transactionId: id });
    return updated;
  }

  async deleteTransaction(id, userId) {
    const transaction = await Transaction.findOne({ where: { id, created_by: userId } });
    if (!transaction) throw new Error('TRANSACTION_NOT_FOUND');
    await transaction.destroy();
    logger.info('Transaction deleted', { transactionId: id });
    return { success: true };
  }

  async getStatistics(userId, filters = {}) {
    const { from_date, to_date } = filters;
    const where = { created_by: userId };

    if (from_date || to_date) {
      where.transaction_date = {};
      if (from_date) where.transaction_date[Op.gte] = from_date;
      if (to_date) where.transaction_date[Op.lte] = to_date;
    }

    const [totalIncome, totalExpenses, incomeByCategory, expensesByCategory, totalTransactions, recentTransactions] =
      await Promise.all([
        Transaction.sum('amount', { where: { ...where, type: 'income' } }).then(v => v || 0),
        Transaction.sum('amount', { where: { ...where, type: 'expense' } }).then(v => v || 0),
        Transaction.findAll({
          where: { ...where, type: 'income' },
          attributes: ['category', [fn('SUM', col('amount')), 'total'], [fn('COUNT', col('id')), 'count']],
          group: ['category']
        }),
        Transaction.findAll({
          where: { ...where, type: 'expense' },
          attributes: ['category', [fn('SUM', col('amount')), 'total'], [fn('COUNT', col('id')), 'count']],
          group: ['category']
        }),
        Transaction.count({ where }),
        Transaction.findAll({
          where,
          include: [{ model: Rabbit, as: 'rabbit', attributes: ['id', 'name', 'tag_id'] }],
          limit: 5,
          order: [['transaction_date', 'DESC'], ['created_at', 'DESC']]
        })
      ]);

    return {
      total_income: parseFloat(totalIncome).toFixed(2),
      total_expenses: parseFloat(totalExpenses).toFixed(2),
      net_profit: (parseFloat(totalIncome) - parseFloat(totalExpenses)).toFixed(2),
      total_transactions: totalTransactions,
      income_by_category: incomeByCategory.map(item => ({
        category: item.category,
        total: parseFloat(item.dataValues.total).toFixed(2),
        count: parseInt(item.dataValues.count)
      })),
      expenses_by_category: expensesByCategory.map(item => ({
        category: item.category,
        total: parseFloat(item.dataValues.total).toFixed(2),
        count: parseInt(item.dataValues.count)
      })),
      recent_transactions: recentTransactions
    };
  }

  async getRabbitTransactions(rabbitId, userId) {
    const rabbit = await Rabbit.findOne({ where: { id: rabbitId, user_id: userId } });
    if (!rabbit) throw new Error('RABBIT_NOT_FOUND');

    const transactions = await Transaction.findAll({
      where: { rabbit_id: rabbitId },
      include: [{ model: User, as: 'creator', attributes: ['id', 'full_name', 'email'] }],
      order: [['transaction_date', 'DESC'], ['created_at', 'DESC']]
    });

    const totalIncome = transactions.filter(t => t.type === 'income').reduce((s, t) => s + parseFloat(t.amount), 0);
    const totalExpenses = transactions.filter(t => t.type === 'expense').reduce((s, t) => s + parseFloat(t.amount), 0);

    return {
      transactions,
      summary: {
        total_income: totalIncome.toFixed(2),
        total_expenses: totalExpenses.toFixed(2),
        net_profit: (totalIncome - totalExpenses).toFixed(2)
      }
    };
  }

  async getMonthlyReport(userId, year, month) {
    if (!year || !month) throw new Error('YEAR_MONTH_REQUIRED');

    const startDate = `${year}-${month.toString().padStart(2, '0')}-01`;
    const endDate = new Date(year, month, 0).toISOString().split('T')[0];

    const transactions = await Transaction.findAll({
      where: {
        created_by: userId,
        transaction_date: { [Op.gte]: startDate, [Op.lte]: endDate }
      },
      include: [{ model: Rabbit, as: 'rabbit', attributes: ['id', 'name', 'tag_id'] }],
      order: [['transaction_date', 'ASC']]
    });

    const totalIncome = transactions.filter(t => t.type === 'income').reduce((s, t) => s + parseFloat(t.amount), 0);
    const totalExpenses = transactions.filter(t => t.type === 'expense').reduce((s, t) => s + parseFloat(t.amount), 0);

    return {
      period: { year: parseInt(year), month: parseInt(month), start_date: startDate, end_date: endDate },
      summary: {
        total_income: totalIncome.toFixed(2),
        total_expenses: totalExpenses.toFixed(2),
        net_profit: (totalIncome - totalExpenses).toFixed(2),
        transaction_count: transactions.length
      },
      transactions
    };
  }
}

module.exports = new TransactionService();
