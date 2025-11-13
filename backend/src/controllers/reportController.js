const {
  Rabbit,
  Cage,
  Vaccination,
  MedicalRecord,
  Feed,
  FeedingRecord,
  Transaction,
  Task,
  Breeding,
  Birth
} = require('../models');
const { Op } = require('sequelize');
const ApiResponse = require('../utils/apiResponse');

/**
 * Report Controller
 * Handles all reporting and analytics operations
 */

/**
 * Get dashboard overview
 * GET /api/v1/reports/dashboard
 */
exports.getDashboard = async (req, res, next) => {
  try {
    // Rabbits statistics
    const totalRabbits = await Rabbit.count();
    const maleRabbits = await Rabbit.count({ where: { sex: 'male' } });
    const femaleRabbits = await Rabbit.count({ where: { sex: 'female' } });

    // Cages statistics
    const totalCages = await Cage.count();
    // Count cages that have rabbits assigned to them
    const occupiedCages = await Rabbit.count({
      where: {
        cage_id: {
          [Op.ne]: null
        }
      },
      distinct: true,
      col: 'cage_id'
    });

    // Health statistics
    // Count upcoming vaccinations (next_vaccination_date within next 30 days)
    const upcomingVaccinations = await Vaccination.count({
      where: {
        next_vaccination_date: {
          [Op.between]: [new Date(), new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)]
        }
      }
    });

    // Count overdue vaccinations (next_vaccination_date in the past)
    const overdueVaccinations = await Vaccination.count({
      where: {
        next_vaccination_date: {
          [Op.lt]: new Date()
        }
      }
    });

    // Financial summary (last 30 days)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const recentIncome = await Transaction.sum('amount', {
      where: {
        type: 'income',
        transaction_date: {
          [Op.gte]: thirtyDaysAgo
        }
      }
    }) || 0;

    const recentExpenses = await Transaction.sum('amount', {
      where: {
        type: 'expense',
        transaction_date: {
          [Op.gte]: thirtyDaysAgo
        }
      }
    }) || 0;

    // Tasks statistics
    const pendingTasks = await Task.count({
      where: { status: 'pending' }
    });

    const overdueTasks = await Task.count({
      where: {
        due_date: {
          [Op.lt]: new Date()
        },
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      }
    });

    // Feed inventory
    const lowStockFeeds = await Feed.count({
      where: {
        current_stock: {
          [Op.lte]: require('sequelize').col('min_stock')
        }
      }
    });

    // Recent births (last 30 days)
    const recentBirths = await Birth.count({
      where: {
        birth_date: {
          [Op.gte]: thirtyDaysAgo
        }
      }
    });

    return ApiResponse.success(res, {
      rabbits: {
        total: totalRabbits,
        male: maleRabbits,
        female: femaleRabbits
      },
      cages: {
        total: totalCages,
        occupied: occupiedCages,
        available: totalCages - occupiedCages
      },
      health: {
        upcomingVaccinations: upcomingVaccinations,
        overdueVaccinations: overdueVaccinations
      },
      finance: {
        income30days: parseFloat(recentIncome).toFixed(2),
        expenses30days: parseFloat(recentExpenses).toFixed(2),
        profit30days: parseFloat(recentIncome - recentExpenses).toFixed(2)
      },
      tasks: {
        pending: pendingTasks,
        overdue: overdueTasks
      },
      inventory: {
        lowStockFeeds: lowStockFeeds
      },
      breeding: {
        recentBirths: recentBirths
      }
    }, 'Сводка получена');
  } catch (error) {
    next(error);
  }
};

/**
 * Get comprehensive farm report
 * GET /api/v1/reports/farm
 */
exports.getFarmReport = async (req, res, next) => {
  try {
    const { from_date, to_date } = req.query;

    const where = {};
    if (from_date || to_date) {
      where.created_at = {};
      if (from_date) {
        where.created_at[Op.gte] = from_date;
      }
      if (to_date) {
        where.created_at[Op.lte] = to_date;
      }
    }

    // Rabbit population dynamics
    const rabbitsByBreed = await Rabbit.findAll({
      attributes: [
        'breed_id',
        [require('sequelize').fn('COUNT', require('sequelize').col('Rabbit.id')), 'count']
      ],
      group: ['breed_id'],
      raw: true
    });

    // Financial summary
    const transactions = await Transaction.findAll({
      where: {
        transaction_date: from_date || to_date ? {
          [Op.gte]: from_date || new Date('2020-01-01'),
          [Op.lte]: to_date || new Date()
        } : {}
      },
      attributes: [
        'type',
        [require('sequelize').fn('SUM', require('sequelize').col('amount')), 'total'],
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      group: ['type'],
      raw: true
    });

    // Health overview
    const vaccinationsCount = await Vaccination.count({ where });
    const medicalRecordsCount = await MedicalRecord.count({ where });

    // Breeding overview
    const breedingsCount = await Breeding.count({
      where: from_date || to_date ? {
        breeding_date: {
          [Op.gte]: from_date || new Date('2020-01-01'),
          [Op.lte]: to_date || new Date()
        }
      } : {}
    });

    const birthsCount = await Birth.count({
      where: from_date || to_date ? {
        birth_date: {
          [Op.gte]: from_date || new Date('2020-01-01'),
          [Op.lte]: to_date || new Date()
        }
      } : {}
    });

    // Feeding statistics
    const feedingRecordsCount = await FeedingRecord.count({ where });
    const totalFeedConsumption = await FeedingRecord.sum('quantity', { where }) || 0;

    res.json(
      ApiResponse.success('Отчет по ферме получен', {
        period: {
          from: from_date || 'начало',
          to: to_date || 'текущая дата'
        },
        population: {
          total_rabbits: await Rabbit.count(),
          by_breed: rabbitsByBreed
        },
        financial: {
          transactions: transactions,
          summary: transactions.reduce((acc, t) => {
            if (t.type === 'income') {
              acc.total_income = parseFloat(t.total);
            } else {
              acc.total_expenses = parseFloat(t.total);
            }
            return acc;
          }, { total_income: 0, total_expenses: 0 })
        },
        health: {
          vaccinations: vaccinationsCount,
          medical_records: medicalRecordsCount
        },
        breeding: {
          breedings: breedingsCount,
          births: birthsCount
        },
        feeding: {
          total_feeding_records: feedingRecordsCount,
          total_feed_consumption: parseFloat(totalFeedConsumption).toFixed(2)
        }
      })
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get health report
 * GET /api/v1/reports/health
 */
exports.getHealthReport = async (req, res, next) => {
  try {
    const { from_date, to_date } = req.query;

    const dateFilter = {};
    if (from_date || to_date) {
      dateFilter.vaccination_date = {};
      if (from_date) {
        dateFilter.vaccination_date[Op.gte] = from_date;
      }
      if (to_date) {
        dateFilter.vaccination_date[Op.lte] = to_date;
      }
    }

    // Vaccinations by type
    const vaccinationsByType = await Vaccination.findAll({
      where: dateFilter,
      attributes: [
        'vaccine_name',
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      group: ['vaccine_name'],
      raw: true
    });

    // Medical records by type
    const medicalRecordsByType = await MedicalRecord.findAll({
      attributes: [
        'record_type',
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      group: ['record_type'],
      raw: true
    });

    // Upcoming vaccinations
    const upcomingVaccinations = await Vaccination.findAll({
      where: {
        vaccination_date: {
          [Op.between]: [new Date(), new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)]
        }
      },
      include: [{
        model: Rabbit,
        as: 'rabbit',
        attributes: ['id', 'name', 'ear_tag']
      }],
      limit: 10,
      order: [['vaccination_date', 'ASC']]
    });

    res.json(
      ApiResponse.success('Отчет по здоровью получен', {
        vaccinations: {
          by_type: vaccinationsByType,
          upcoming: upcomingVaccinations
        },
        medical_records: {
          by_type: medicalRecordsByType
        }
      })
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get financial report
 * GET /api/v1/reports/financial
 */
exports.getFinancialReport = async (req, res, next) => {
  try {
    const { from_date, to_date, groupBy = 'month' } = req.query;

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

    // Total by type
    const totalByType = await Transaction.findAll({
      where,
      attributes: [
        'type',
        [require('sequelize').fn('SUM', require('sequelize').col('amount')), 'total']
      ],
      group: ['type'],
      raw: true
    });

    // By category
    const byCategory = await Transaction.findAll({
      where,
      attributes: [
        'type',
        'category',
        [require('sequelize').fn('SUM', require('sequelize').col('amount')), 'total'],
        [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
      ],
      group: ['type', 'category'],
      raw: true
    });

    const totalIncome = totalByType.find(t => t.type === 'income')?.total || 0;
    const totalExpenses = totalByType.find(t => t.type === 'expense')?.total || 0;

    res.json(
      ApiResponse.success('Финансовый отчет получен', {
        summary: {
          total_income: parseFloat(totalIncome).toFixed(2),
          total_expenses: parseFloat(totalExpenses).toFixed(2),
          net_profit: parseFloat(totalIncome - totalExpenses).toFixed(2)
        },
        by_category: byCategory.map(item => ({
          type: item.type,
          category: item.category,
          total: parseFloat(item.total).toFixed(2),
          count: parseInt(item.count)
        }))
      })
    );
  } catch (error) {
    next(error);
  }
};

module.exports = exports;
