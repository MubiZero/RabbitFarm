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
  Birth,
  sequelize
} = require('../models');
const { Op, Sequelize } = require('sequelize');
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
    const userId = req.user.id;

    // Rabbits statistics
    const totalRabbits = await Rabbit.count({ where: { user_id: userId } });
    const maleRabbits = await Rabbit.count({ where: { sex: 'male', user_id: userId } });
    const femaleRabbits = await Rabbit.count({ where: { sex: 'female', user_id: userId } });

    // Cages statistics
    const totalCages = await Cage.count({ where: { user_id: userId } });
    // Count cages that have rabbits assigned to them
    const occupiedCages = await Rabbit.count({
      where: {
        user_id: userId,
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
      },
      include: [{
        model: Rabbit,
        as: 'rabbit',
        where: { user_id: userId },
        attributes: []
      }]
    });

    // Count overdue vaccinations (next_vaccination_date in the past)
    const overdueVaccinations = await Vaccination.count({
      where: {
        next_vaccination_date: {
          [Op.lt]: new Date()
        }
      },
      include: [{
        model: Rabbit,
        as: 'rabbit',
        where: { user_id: userId },
        attributes: []
      }]
    });

    // Financial summary (last 30 days)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const recentIncome = await Transaction.sum('amount', {
      where: {
        created_by: userId,
        type: 'income',
        transaction_date: {
          [Op.gte]: thirtyDaysAgo
        }
      }
    }) || 0;

    const recentExpenses = await Transaction.sum('amount', {
      where: {
        created_by: userId,
        type: 'expense',
        transaction_date: {
          [Op.gte]: thirtyDaysAgo
        }
      }
    }) || 0;

    // Tasks statistics
    const pendingTasks = await Task.count({
      where: {
        status: 'pending',
        created_by: userId
      }
    });

    const overdueTasks = await Task.count({
      where: {
        created_by: userId,
        due_date: {
          [Op.lt]: new Date()
        },
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      }
    });

    const urgentTasks = await Task.count({
      where: {
        created_by: userId,
        priority: 'urgent',
        status: {
          [Op.in]: ['pending', 'in_progress']
        }
      }
    });



    // Feed inventory
    const lowStockFeeds = await Feed.count({
      where: {
        user_id: userId,
        [Op.and]: [
          Sequelize.where(
            Sequelize.col('current_stock'),
            '<=',
            Sequelize.col('min_stock')
          )
        ]
      }
    });

    // Recent births (last 30 days) - Existing logic
    const recentBirths = await Birth.count({
      where: {
        birth_date: {
          [Op.gte]: thirtyDaysAgo
        }
      },
      include: [{
        model: Rabbit,
        as: 'mother',
        where: { user_id: userId },
        attributes: []
      }]
    });

    // --- History Calculations for Charts ---

    // 1. Rabbits History (Last 7 days)
    const allRabbits = await Rabbit.findAll({
      where: { user_id: userId },
      attributes: ['created_at', 'death_date', 'sold_date']
    });

    const rabbitsHistory = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const endOfDay = new Date(d.setHours(23, 59, 59, 999));

      const count = allRabbits.filter(r => {
        const created = new Date(r.created_at);
        const dead = r.death_date ? new Date(r.death_date) : null;
        const sold = r.sold_date ? new Date(r.sold_date) : null;

        if (created > endOfDay) return false;
        if (dead && dead <= endOfDay) return false;
        if (sold && sold <= endOfDay) return false;
        return true;
      }).length;
      rabbitsHistory.push(count);
    }

    // 2. Births History (Last 7 days)
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 6);
    sevenDaysAgo.setHours(0, 0, 0, 0);

    const recentBirthsList = await Birth.findAll({
      where: {
        birth_date: {
          [Op.gte]: sevenDaysAgo
        }
      },
      include: [{
        model: Rabbit,
        as: 'mother',
        where: { user_id: userId },
        attributes: []
      }],
      attributes: ['birth_date', 'kits_born_alive']
    });

    const birthsHistory = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const dateString = d.toISOString().split('T')[0];

      const birthsOnDay = recentBirthsList.filter(b => b.birth_date === dateString);
      const totalKits = birthsOnDay.reduce((sum, b) => sum + (b.kits_born_alive || 0), 0);
      birthsHistory.push(totalKits);
    }


    return ApiResponse.success(res, {
      rabbits: {
        total: totalRabbits,
        male: maleRabbits,
        female: femaleRabbits,
        history: rabbitsHistory
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
        overdue: overdueTasks,
        urgent: urgentTasks
      },
      inventory: {
        lowStockFeeds: lowStockFeeds
      },
      breeding: {
        recentBirths: recentBirths,
        history: birthsHistory
      }
    }, 'Сводка получена');
  } catch (error) {
    console.error('Dashboard Error:', error);
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
      where: { user_id: req.user.id },
      attributes: [
        'breed_id',
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['breed_id'],
      raw: true
    });

    // Financial summary
    const transactions = await Transaction.findAll({
      where: {
        created_by: req.user.id,
        transaction_date: from_date || to_date ? {
          [Op.gte]: from_date || new Date('2020-01-01'),
          [Op.lte]: to_date || new Date()
        } : { [Op.ne]: null }
      },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total'],
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['type'],
      raw: true
    });

    // Health overview
    const vaccinationsCount = await Vaccination.count({
      include: [{ model: Rabbit, as: 'rabbit', where: { user_id: req.user.id }, attributes: [] }]
    });
    const medicalRecordsCount = await MedicalRecord.count({
      include: [{ model: Rabbit, as: 'rabbit', where: { user_id: req.user.id }, attributes: [] }]
    });

    // Breeding overview
    const breedingsCount = await Breeding.count({
      where: {
        user_id: req.user.id,
        ...(from_date || to_date ? {
          breeding_date: {
            [Op.gte]: from_date || new Date('2020-01-01'),
            [Op.lte]: to_date || new Date()
          }
        } : {})
      }
    });

    const birthsCount = await Birth.count({
      include: [{ model: Rabbit, as: 'mother', where: { user_id: req.user.id }, attributes: [] }],
      where: from_date || to_date ? {
        birth_date: {
          [Op.gte]: from_date || new Date('2020-01-01'),
          [Op.lte]: to_date || new Date()
        }
      } : {}
    });

    // Feeding statistics
    const feedingRecordsCount = await FeedingRecord.count({ where: { fed_by: req.user.id } });
    const totalFeedConsumption = await FeedingRecord.sum('quantity', { where: { fed_by: req.user.id } }) || 0;

    return ApiResponse.success(res, {
      period: {
        from: from_date || 'начало',
        to: to_date || 'текущая дата'
      },
      population: {
        total_rabbits: await Rabbit.count({ where: { user_id: req.user.id } }),
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
    }, 'Отчет по ферме получен');
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
      include: [{ model: Rabbit, as: 'rabbit', where: { user_id: req.user.id }, attributes: [] }],
      where: dateFilter,
      attributes: [
        'vaccine_name',
        [Sequelize.fn('COUNT', Sequelize.col('Vaccination.id')), 'count']
      ],
      group: ['vaccine_name'],
      raw: true
    });

    // Medical records by outcome
    const medicalRecordsByOutcome = await MedicalRecord.findAll({
      include: [{ model: Rabbit, as: 'rabbit', where: { user_id: req.user.id }, attributes: [] }],
      attributes: [
        'outcome',
        [Sequelize.fn('COUNT', Sequelize.col('MedicalRecord.id')), 'count']
      ],
      group: ['outcome'],
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
        where: { user_id: req.user.id },
        attributes: ['id', 'name', 'tag_id']
      }],
      limit: 10,
      order: [['vaccination_date', 'ASC']]
    });

    return ApiResponse.success(res, {
      vaccinations: {
        by_type: vaccinationsByType,
        upcoming: upcomingVaccinations
      },
      medical_records: {
        by_outcome: medicalRecordsByOutcome
      }
    }, 'Отчет по здоровью получен');
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
      where: { ...where, created_by: req.user.id },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total']
      ],
      group: ['type'],
      raw: true
    });

    // By category
    const byCategory = await Transaction.findAll({
      where: { ...where, created_by: req.user.id },
      attributes: [
        'type',
        'category',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total'],
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['type', 'category'],
      raw: true
    });

    const totalIncome = totalByType.find(t => t.type === 'income')?.total || 0;
    const totalExpenses = totalByType.find(t => t.type === 'expense')?.total || 0;

    return ApiResponse.success(res, {
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
    }, 'Финансовый отчет получен');
  } catch (error) {
    next(error);
  }
};

module.exports = exports;
