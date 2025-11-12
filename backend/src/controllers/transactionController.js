const { Transaction, Rabbit, User } = require('../models');
const { Op } = require('sequelize');
const ApiResponse = require('../utils/apiResponse');

/**
 * Transaction Controller
 * Handles all financial transaction operations (income and expenses)
 */

/**
 * Create a new transaction
 * POST /api/v1/transactions
 */
exports.create = async (req, res, next) => {
  try {
    const { type, category, amount, transaction_date, rabbit_id, description, receipt_url } = req.body;

    // Validate rabbit_id if provided
    if (rabbit_id) {
      const rabbit = await Rabbit.findByPk(rabbit_id);
      if (!rabbit) {
        return res.status(404).json(
          ApiResponse.error('Кролик не найден', 404)
        );
      }
    }

    const transaction = await Transaction.create({
      type,
      category,
      amount,
      transaction_date,
      rabbit_id,
      description,
      receipt_url,
      created_by: req.user.id
    });

    // Fetch created transaction with associations
    const createdTransaction = await Transaction.findByPk(transaction.id, {
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'ear_tag']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'username', 'email']
        }
      ]
    });

    res.status(201).json(
      ApiResponse.success('Транзакция успешно создана', createdTransaction)
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get transaction by ID
 * GET /api/v1/transactions/:id
 */
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const transaction = await Transaction.findByPk(id, {
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'ear_tag']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'username', 'email']
        }
      ]
    });

    if (!transaction) {
      return res.status(404).json(
        ApiResponse.error('Транзакция не найдена', 404)
      );
    }

    res.json(ApiResponse.success('Транзакция получена', transaction));
  } catch (error) {
    next(error);
  }
};

/**
 * Get list of transactions with filters
 * GET /api/v1/transactions
 */
exports.list = async (req, res, next) => {
  try {
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
    } = req.query;

    const offset = (page - 1) * limit;
    const where = {};

    // Filters
    if (type) {
      where.type = type;
    }

    if (category) {
      where.category = category;
    }

    if (rabbit_id) {
      where.rabbit_id = rabbit_id;
    }

    if (from_date || to_date) {
      where.transaction_date = {};
      if (from_date) {
        where.transaction_date[Op.gte] = from_date;
      }
      if (to_date) {
        where.transaction_date[Op.lte] = to_date;
      }
    }

    if (min_amount || max_amount) {
      where.amount = {};
      if (min_amount) {
        where.amount[Op.gte] = min_amount;
      }
      if (max_amount) {
        where.amount[Op.lte] = max_amount;
      }
    }

    const { count, rows } = await Transaction.findAndCountAll({
      where,
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'ear_tag']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'username', 'email']
        }
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    res.json(
      ApiResponse.success('Список транзакций получен', {
        transactions: rows,
        pagination: {
          total: count,
          page: parseInt(page),
          limit: parseInt(limit),
          pages: Math.ceil(count / limit)
        }
      })
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Update transaction
 * PUT /api/v1/transactions/:id
 */
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { type, category, amount, transaction_date, rabbit_id, description, receipt_url } = req.body;

    const transaction = await Transaction.findByPk(id);

    if (!transaction) {
      return res.status(404).json(
        ApiResponse.error('Транзакция не найдена', 404)
      );
    }

    // Validate rabbit_id if provided
    if (rabbit_id) {
      const rabbit = await Rabbit.findByPk(rabbit_id);
      if (!rabbit) {
        return res.status(404).json(
          ApiResponse.error('Кролик не найден', 404)
        );
      }
    }

    await transaction.update({
      type,
      category,
      amount,
      transaction_date,
      rabbit_id,
      description,
      receipt_url
    });

    // Fetch updated transaction with associations
    const updatedTransaction = await Transaction.findByPk(id, {
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'ear_tag']
        },
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'username', 'email']
        }
      ]
    });

    res.json(
      ApiResponse.success('Транзакция успешно обновлена', updatedTransaction)
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Delete transaction
 * DELETE /api/v1/transactions/:id
 */
exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;

    const transaction = await Transaction.findByPk(id);

    if (!transaction) {
      return res.status(404).json(
        ApiResponse.error('Транзакция не найдена', 404)
      );
    }

    await transaction.destroy();

    res.json(ApiResponse.success('Транзакция успешно удалена'));
  } catch (error) {
    next(error);
  }
};

/**
 * Get financial statistics
 * GET /api/v1/transactions/statistics
 */
exports.getStatistics = async (req, res, next) => {
  try {
    const { from_date, to_date } = req.query;

    const where = {};
    if (from_date || to_date) {
      where.transaction_date = {};
      if (from_date) {
        where.transaction_date[Op.gte] = from_date;
      }
      if (to_date) {
        where.transaction_date[Op.lte] = to_date;
      }
    }

    // Total income
    const totalIncome = await Transaction.sum('amount', {
      where: { ...where, type: 'income' }
    }) || 0;

    // Total expenses
    const totalExpenses = await Transaction.sum('amount', {
      where: { ...where, type: 'expense' }
    }) || 0;

    // Net profit
    const netProfit = totalIncome - totalExpenses;

    // Income by category
    const incomeByCategory = await Transaction.findAll({
      where: { ...where, type: 'income' },
      attributes: [
        'category',
        [require('sequelize').fn('SUM', require('sequelize').col('amount')), 'total'],
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      group: ['category']
    });

    // Expenses by category
    const expensesByCategory = await Transaction.findAll({
      where: { ...where, type: 'expense' },
      attributes: [
        'category',
        [require('sequelize').fn('SUM', require('sequelize').col('amount')), 'total'],
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      group: ['category']
    });

    // Transaction count
    const totalTransactions = await Transaction.count({ where });

    // Recent transactions
    const recentTransactions = await Transaction.findAll({
      where,
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'ear_tag']
        }
      ],
      limit: 5,
      order: [['transaction_date', 'DESC'], ['created_at', 'DESC']]
    });

    res.json(
      ApiResponse.success('Статистика получена', {
        total_income: parseFloat(totalIncome).toFixed(2),
        total_expenses: parseFloat(totalExpenses).toFixed(2),
        net_profit: parseFloat(netProfit).toFixed(2),
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
      })
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get transactions by rabbit
 * GET /api/v1/rabbits/:rabbitId/transactions
 */
exports.getRabbitTransactions = async (req, res, next) => {
  try {
    const { rabbitId } = req.params;

    // Check if rabbit exists
    const rabbit = await Rabbit.findByPk(rabbitId);
    if (!rabbit) {
      return res.status(404).json(
        ApiResponse.error('Кролик не найден', 404)
      );
    }

    const transactions = await Transaction.findAll({
      where: { rabbit_id: rabbitId },
      include: [
        {
          model: User,
          as: 'creator',
          attributes: ['id', 'username', 'email']
        }
      ],
      order: [['transaction_date', 'DESC'], ['created_at', 'DESC']]
    });

    // Calculate totals for this rabbit
    const totalIncome = transactions
      .filter(t => t.type === 'income')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);

    const totalExpenses = transactions
      .filter(t => t.type === 'expense')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);

    res.json(
      ApiResponse.success('Транзакции кролика получены', {
        transactions,
        summary: {
          total_income: totalIncome.toFixed(2),
          total_expenses: totalExpenses.toFixed(2),
          net_profit: (totalIncome - totalExpenses).toFixed(2)
        }
      })
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get monthly report
 * GET /api/v1/transactions/monthly-report
 */
exports.getMonthlyReport = async (req, res, next) => {
  try {
    const { year, month } = req.query;

    if (!year || !month) {
      return res.status(400).json(
        ApiResponse.error('Необходимо указать год и месяц', 400)
      );
    }

    const startDate = `${year}-${month.toString().padStart(2, '0')}-01`;
    const endDate = new Date(year, month, 0).toISOString().split('T')[0];

    const where = {
      transaction_date: {
        [Op.gte]: startDate,
        [Op.lte]: endDate
      }
    };

    const transactions = await Transaction.findAll({
      where,
      include: [
        {
          model: Rabbit,
          as: 'rabbit',
          attributes: ['id', 'name', 'ear_tag']
        }
      ],
      order: [['transaction_date', 'ASC']]
    });

    const totalIncome = transactions
      .filter(t => t.type === 'income')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);

    const totalExpenses = transactions
      .filter(t => t.type === 'expense')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);

    res.json(
      ApiResponse.success('Месячный отчет получен', {
        period: {
          year: parseInt(year),
          month: parseInt(month),
          start_date: startDate,
          end_date: endDate
        },
        summary: {
          total_income: totalIncome.toFixed(2),
          total_expenses: totalExpenses.toFixed(2),
          net_profit: (totalIncome - totalExpenses).toFixed(2),
          transaction_count: transactions.length
        },
        transactions
      })
    );
  } catch (error) {
    next(error);
  }
};

module.exports = exports;
