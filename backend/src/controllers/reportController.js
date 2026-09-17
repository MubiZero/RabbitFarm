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
} = require('../models');
const { Op, Sequelize } = require('sequelize');
const ApiResponse = require('../utils/apiResponse');
const {
  startOfDayInZone,
  nextDayInZone,
  daysAgoInZone
} = require('../utils/dateRange');
const planService = require('../services/planService');

/**
 * Видны ли этому человеку деньги фермы.
 *
 * Книга доходов и расходов работнику закрыта намеренно, но те же выручка,
 * прибыль и себестоимость лежали в сводках — и отдавались всем подряд.
 * Закрыть отчёты целиком нельзя: сводка нужна работнику ради задач,
 * поголовья и прививок. Поэтому денежный блок не прячется за отказом, а
 * просто не попадает в ответ: `null` честно говорит «не для вас», в отличие
 * от нулей, которые читались бы как «на ферме пусто».
 */
const canSeeLedger = (req) =>
  req.user.role === 'owner' || req.user.role === 'manager';


// Живым считается всё, кроме проданных и павших. Перечислять живые
// статусы поимённо опасно: список уже расходился с моделью.
const { overdueRabbits, upcomingRabbits } = require('../utils/vaccinationDue');

const ALIVE_STATUS = { [Op.notIn]: ['dead', 'sold'] };

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
    const farmId = req.farmId;

    // Деньги, задачи и поголовье отбираются по одной и той же колонке фермы.
    // Раньше сводка опознавала операции и задачи по тому, кто их внёс: расход
    // управляющего в «доходы и расходы за 30 дней» не попадал, хотя финансовый
    // отчёт те же операции показывал — два экрана называли разные суммы про
    // одни и те же деньги.

    // Границы считаются в поясе хозяйства, а не процесса. Колонки здесь —
    // DATEONLY (календарный день), поэтому и границы календарные: сравнивать
    // день с моментом значит терять или прихватывать сутки на краю.
    const timeZone = req.farmTimezone;
    const thirtyDaysAgo = daysAgoInZone(30, timeZone);
    const sevenDaysAgo = daysAgoInZone(6, timeZone);

    // Run all independent queries in parallel
    const [
      totalRabbits,
      maleRabbits,
      femaleRabbits,
      totalCages,
      occupiedCages,
      upcomingVaccinations,
      overdueVaccinations,
      recentIncomeRaw,
      recentExpensesRaw,
      pendingTasks,
      overdueTasks,
      urgentTasks,
      lowStockFeeds,
      recentBirths,
      allRabbits,
      recentBirthsList,
      planUsage
    ] = await Promise.all([
      // Поголовье считается без проданных и павших: иначе ферма, продавшая
      // за год три сотни кроликов, видела их в заголовке «кроликов на ферме».
      Rabbit.count({ where: { farm_id: farmId, status: ALIVE_STATUS } }),
      Rabbit.count({ where: { sex: 'male', farm_id: farmId, status: ALIVE_STATUS } }),
      Rabbit.count({ where: { sex: 'female', farm_id: farmId, status: ALIVE_STATUS } }),

      // Cages statistics
      Cage.count({ where: { farm_id: farmId } }),
      // Count cages that have rabbits assigned to them
      Rabbit.count({
        where: {
          farm_id: farmId,
          cage_id: {
            [Op.ne]: null
          }
        },
        distinct: true,
        col: 'cage_id'
      }),

      // Здоровье — в кроликах, а не в строках истории. Кролик, привитый
      // пять раз, давал пять «просрочек», а павшие и проданные считались
      // наравне с живыми: число не уменьшалось никогда и решения по нему
      // принять было нельзя (см. utils/vaccinationDue).
      upcomingRabbits(farmId),
      overdueRabbits(farmId),

      // Financial summary (last 30 days)
      Transaction.sum('amount', {
        where: {
          farm_id: farmId,
          type: 'income',
          transaction_date: {
            [Op.gte]: thirtyDaysAgo
          }
        }
      }),

      Transaction.sum('amount', {
        where: {
          farm_id: farmId,
          type: 'expense',
          transaction_date: {
            [Op.gte]: thirtyDaysAgo
          }
        }
      }),

      // Tasks statistics
      Task.count({
        where: {
          farm_id: farmId,
          status: 'pending'
        }
      }),

      Task.count({
        where: {
          farm_id: farmId,
          due_date: {
            [Op.lt]: new Date()
          },
          status: {
            [Op.in]: ['pending', 'in_progress']
          }
        }
      }),

      Task.count({
        where: {
          farm_id: farmId,
          priority: 'urgent',
          status: {
            [Op.in]: ['pending', 'in_progress']
          }
        }
      }),

      // Feed inventory
      Feed.count({
        where: {
          farm_id: farmId,
          [Op.and]: [
            Sequelize.where(
              Sequelize.col('current_stock'),
              '<=',
              Sequelize.col('min_stock')
            )
          ]
        }
      }),

      // Recent births (last 30 days)
      Birth.count({
        where: {
          farm_id: farmId,
          birth_date: {
            [Op.gte]: thirtyDaysAgo
          }
        }
      }),

      // Rabbits History data (Last 7 days)
      Rabbit.findAll({
        where: { farm_id: farmId },
        attributes: ['created_at', 'death_date', 'sold_date']
      }),

      // Births History data (Last 7 days)
      Birth.findAll({
        where: {
          farm_id: farmId,
          birth_date: {
            [Op.gte]: sevenDaysAgo
          }
        },
        attributes: ['birth_date', 'kits_born_alive']
      }),

      // Потребление фермы против пределов тарифа — для полосы «26 из 30
      // кроликов» на «Сегодня», до того как сервер откажет запросом.
      planService.getUsage(farmId)
    ]);

    const recentIncome = recentIncomeRaw || 0;
    const recentExpenses = recentExpensesRaw || 0;

    // --- History Calculations for Charts (in-memory, uses query results) ---

    // 1. Rabbits History (Last 7 days)
    //
    // Конец дня — начало следующего дня хозяйства: у фермы за пределами
    // пояса сервера столбики графика съезжали на сутки.
    const rabbitsHistory = [];
    for (let i = 6; i >= 0; i--) {
      const day = daysAgoInZone(i, timeZone);
      const endOfDay = nextDayInZone(day, timeZone);

      const count = allRabbits.filter(r => {
        const created = new Date(r.created_at);
        const dead = r.death_date ? new Date(r.death_date) : null;
        const sold = r.sold_date ? new Date(r.sold_date) : null;

        if (created >= endOfDay) return false;
        if (dead && dead < endOfDay) return false;
        if (sold && sold < endOfDay) return false;
        return true;
      }).length;
      rabbitsHistory.push(count);
    }

    // 2. Births History (Last 7 days)
    const birthsHistory = [];
    for (let i = 6; i >= 0; i--) {
      // toISOString() давал день по Гринвичу: до рассвета столбик за сегодня
      // оказывался вчерашним и всегда пустым.
      const dateString = daysAgoInZone(i, timeZone);

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
      finance: canSeeLedger(req)
        ? {
          income30days: parseFloat(recentIncome).toFixed(2),
          expenses30days: parseFloat(recentExpenses).toFixed(2),
          profit30days: parseFloat(recentIncome - recentExpenses).toFixed(2)
        }
        : null,
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
      },
      plan_usage: planUsage
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

    // Период берём ровно таким, каким его прислал клиент, без умолчаний.
    // Раньше здесь подставлялись «последние 30 дней», и при выборе «всё
    // время» — когда клиент не шлёт границ вовсе — эта вкладка показывала
    // месяц, пока соседние «Деньги» и «Здоровье» считали за всё время. Три
    // вкладки под одним переключателем срока называли разные числа, хотя
    // экран обещает им общий период.
    //
    // Умолчание вдобавок считалось через toISOString(), то есть по Гринвичу,
    // а сервер живёт в Душанбе (TZ=Asia/Dushanbe): с полуночи до 5 утра
    // «сегодня» отставало на календарный день, и сегодняшние записи выпадали
    // из отчёта.
    const effectiveFromDate = from_date || null;
    const effectiveToDate = to_date || null;

    const farmId = req.farmId;

    const period = {};
    if (effectiveFromDate) period[Op.gte] = effectiveFromDate;
    if (effectiveToDate) period[Op.lte] = effectiveToDate;

    // Пустой период означает «за всё время»: столбец в условие не добавляем
    // вовсе, иначе Sequelize получит пустой объект вместо сравнения.
    const hasPeriod = Boolean(effectiveFromDate || effectiveToDate);
    const byPeriod = (column) => (hasPeriod ? { [column]: period } : {});

    // Отдельная граница для колонок со временем. Остальные даты в отчёте —
    // DATEONLY, там сравнение идёт день с днём. А fed_at хранит момент, и
    // `<= '2026-08-24'` означало «не позже полуночи», то есть отсекало весь
    // последний день периода. Период по умолчанию заканчивается сегодняшним
    // днём — сегодняшние кормления не попадали в отчёт никогда.
    const feedingPeriod = {};
    if (effectiveFromDate) {
      feedingPeriod[Op.gte] = startOfDayInZone(effectiveFromDate, req.farmTimezone);
    }
    if (effectiveToDate) {
      feedingPeriod[Op.lt] = nextDayInZone(effectiveToDate, req.farmTimezone);
    }

    const byFeedingPeriod = () => (hasPeriod ? { fed_at: feedingPeriod } : {});

    // Rabbit population dynamics
    // Разбивка по породам стоит на экране прямо под общим поголовьем, а оно
    // считает только живых. Без того же отбора числа расходились: проданные и
    // павшие за годы кролики оставались в породах, но не в поголовье.
    const rabbitsByBreed = await Rabbit.findAll({
      where: { farm_id: farmId, status: ALIVE_STATUS },
      attributes: [
        'breed_id',
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['breed_id'],
      raw: true
    });

    // Разбивка по назначению — тем же отбором живых, что и породы рядом:
    // назначение отвечает на вопрос «сколько у меня племенных, а сколько на
    // откорме», и проданные с павшими в этом счёте были бы враньём. До сих
    // пор поле жило только фильтром списка — заполняли его на каждом кролике,
    // а сводки по нему не было нигде.
    const rabbitsByPurpose = await Rabbit.findAll({
      where: { farm_id: farmId, status: ALIVE_STATUS },
      attributes: [
        'purpose',
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['purpose'],
      raw: true
    });

    // Financial summary
    const transactions = await Transaction.findAll({
      where: {
        farm_id: farmId,
        ...byPeriod('transaction_date')
      },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total'],
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['type'],
      raw: true
    });

    // Отчёт заявляет период, поэтому и считать нужно за период: раньше рядом
    // с финансами за март стояло число прививок за всё время фермы.
    const vaccinationsCount = await Vaccination.count({
      where: { farm_id: farmId, ...byPeriod('vaccination_date') }
    });
    const medicalRecordsCount = await MedicalRecord.count({
      where: { farm_id: farmId, ...byPeriod('started_at') }
    });

    // Breeding overview
    const breedingsCount = await Breeding.count({
      where: {
        farm_id: farmId,
        ...byPeriod('breeding_date')
      }
    });

    const birthsCount = await Birth.count({
      where: { farm_id: farmId, ...byPeriod('birth_date') }
    });

    const feedingRecordsCount = await FeedingRecord.count({
      where: { farm_id: farmId, ...byFeedingPeriod() }
    });

    // Расход разбит по единицам измерения. Общая сумма складывала килограммы
    // комбикорма со штуками моркови — получалось число, которое невозможно
    // истолковать.
    const consumptionByUnit = await FeedingRecord.findAll({
      where: { farm_id: farmId, ...byFeedingPeriod() },
      attributes: [
        [Sequelize.col('feed.unit'), 'unit'],
        [Sequelize.fn('SUM', Sequelize.col('FeedingRecord.quantity')), 'total']
      ],
      include: [{ model: Feed, as: 'feed', attributes: [] }],
      group: [Sequelize.col('feed.unit')],
      raw: true
    });

    return ApiResponse.success(res, {
      period: {
        from: effectiveFromDate,
        to: effectiveToDate
      },
      population: {
        total_rabbits: await Rabbit.count({ where: { farm_id: farmId, status: ALIVE_STATUS } }),
        by_breed: rabbitsByBreed,
        by_purpose: rabbitsByPurpose
      },
      financial: canSeeLedger(req)
        ? {
          transactions: transactions,
          summary: transactions.reduce((acc, t) => {
            if (t.type === 'income') {
              acc.total_income = parseFloat(t.total);
            } else {
              acc.total_expenses = parseFloat(t.total);
            }
            return acc;
          }, { total_income: 0, total_expenses: 0 })
        }
        : null,
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
        consumption_by_unit: consumptionByUnit.map((row) => ({
          unit: row.unit,
          total: parseFloat(row.total).toFixed(2)
        }))
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
    const farmId = req.farmId;

    const dateFilter = { farm_id: farmId };
    // Прививки и лечения стоят на экране рядом под одним переключателем срока,
    // поэтому и считаются за один срок. Раньше лечения отбирались только по
    // ферме: «за месяц» рядом с прививками стояло число за всё время фермы.
    const medicalFilter = { farm_id: farmId };
    if (from_date || to_date) {
      dateFilter.vaccination_date = {};
      medicalFilter.started_at = {};
      if (from_date) {
        dateFilter.vaccination_date[Op.gte] = from_date;
        medicalFilter.started_at[Op.gte] = from_date;
      }
      if (to_date) {
        dateFilter.vaccination_date[Op.lte] = to_date;
        medicalFilter.started_at[Op.lte] = to_date;
      }
    }

    // Vaccinations by type
    const vaccinationsByType = await Vaccination.findAll({
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
      where: medicalFilter,
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
        farm_id: farmId,
        vaccination_date: {
          [Op.between]: [new Date(), new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)]
        }
      },
      // Кролик — только ради подписи в списке: отбор идёт по колонке фермы.
      include: [{
        model: Rabbit,
        as: 'rabbit',
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
    const { from_date, to_date, groupBy } = req.query;

    // Тот же признак, что и в сводке: иначе «прибыль за 30 дней» на главной и
    // «чистая прибыль» в финансовом отчёте снова разъедутся.
    const where = { farm_id: req.farmId };
    if (from_date || to_date) {
      where.transaction_date = {};
      if (from_date) {
        where.transaction_date[Op.gte] = from_date;
      }
      if (to_date) {
        where.transaction_date[Op.lte] = to_date;
      }
    }

    // Total by type (always computed for the overall summary)
    const totalByType = await Transaction.findAll({
      where,
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total']
      ],
      group: ['type'],
      raw: true
    });

    const totalIncome = totalByType.find(t => t.type === 'income')?.total || 0;
    const totalExpenses = totalByType.find(t => t.type === 'expense')?.total || 0;

    const summary = {
      total_income: parseFloat(totalIncome).toFixed(2),
      total_expenses: parseFloat(totalExpenses).toFixed(2),
      net_profit: parseFloat(totalIncome - totalExpenses).toFixed(2)
    };

    // Handle groupBy parameter
    if (groupBy === 'by_category') {
      const byCategory = await Transaction.findAll({
        where,
        attributes: [
          'category',
          [Sequelize.fn('SUM', Sequelize.literal("CASE WHEN type = 'income' THEN amount ELSE 0 END")), 'total_income'],
          [Sequelize.fn('SUM', Sequelize.literal("CASE WHEN type = 'expense' THEN amount ELSE 0 END")), 'total_expense']
        ],
        group: ['category'],
        raw: true
      });

      const grouped = byCategory.map(item => ({
        category: item.category,
        total_income: parseFloat(item.total_income || 0).toFixed(2),
        total_expense: parseFloat(item.total_expense || 0).toFixed(2),
        net: parseFloat((item.total_income || 0) - (item.total_expense || 0)).toFixed(2)
      }));

      return ApiResponse.success(res, { summary, grouped }, 'Финансовый отчет получен');
    }

    if (groupBy === 'by_month') {
      const byMonth = await Transaction.findAll({
        where,
        attributes: [
          [Sequelize.fn('DATE_FORMAT', Sequelize.col('transaction_date'), '%Y-%m'), 'month'],
          [Sequelize.fn('SUM', Sequelize.literal("CASE WHEN type = 'income' THEN amount ELSE 0 END")), 'total_income'],
          [Sequelize.fn('SUM', Sequelize.literal("CASE WHEN type = 'expense' THEN amount ELSE 0 END")), 'total_expense']
        ],
        group: [Sequelize.fn('DATE_FORMAT', Sequelize.col('transaction_date'), '%Y-%m')],
        order: [[Sequelize.fn('DATE_FORMAT', Sequelize.col('transaction_date'), '%Y-%m'), 'ASC']],
        raw: true
      });

      const grouped = byMonth.map(item => ({
        month: item.month,
        total_income: parseFloat(item.total_income || 0).toFixed(2),
        total_expense: parseFloat(item.total_expense || 0).toFixed(2),
        net: parseFloat((item.total_income || 0) - (item.total_expense || 0)).toFixed(2)
      }));

      return ApiResponse.success(res, { summary, grouped }, 'Финансовый отчет получен');
    }

    if (groupBy === 'by_type') {
      const byType = await Transaction.findAll({
        where,
        attributes: [
          'type',
          [Sequelize.fn('SUM', Sequelize.col('amount')), 'total'],
          [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
        ],
        group: ['type'],
        raw: true
      });

      const grouped = byType.map(item => ({
        type: item.type,
        total: parseFloat(item.total || 0).toFixed(2),
        count: parseInt(item.count)
      }));

      return ApiResponse.success(res, { summary, grouped }, 'Финансовый отчет получен');
    }

    // Default: no groupBy or unknown value — return existing ungrouped summary with by_category breakdown
    const byCategory = await Transaction.findAll({
      where,
      attributes: [
        'type',
        'category',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total'],
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['type', 'category'],
      raw: true
    });

    return ApiResponse.success(res, {
      summary,
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
