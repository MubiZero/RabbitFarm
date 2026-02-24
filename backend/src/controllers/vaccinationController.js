const { Vaccination, Rabbit, Breed, Transaction, sequelize } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');
const { Op } = require('sequelize');

/**
 * Vaccination controller
 * Handles HTTP requests for vaccination management
 */
class VaccinationController {
  /**
   * Create new vaccination record
   * POST /api/v1/vaccinations
   */
  async create(req, res, next) {
    const t = await sequelize.transaction();
    try {
      const { rabbit_id, cost, vaccination_date, vaccine_name } = req.body;

      // Check if rabbit exists and belongs to user
      const rabbit = await Rabbit.findOne({
        where: { id: rabbit_id, user_id: req.user.id },
        transaction: t
      });
      if (!rabbit) {
        await t.rollback();
        return ApiResponse.notFound(res, 'Кролик не найден');
      }

      // Vitality check
      if (rabbit.status === 'dead' || rabbit.status === 'sold') {
        await t.rollback();
        return ApiResponse.badRequest(res, 'Нельзя вакцинировать мертвого или проданного кролика');
      }

      const vaccination = await Vaccination.create(req.body, { transaction: t });

      // Automation: Financial Transaction
      if (cost && parseFloat(cost) > 0) {
        await Transaction.create({
          type: 'expense',
          category: 'Health', // or 'Vaccination'
          amount: cost,
          transaction_date: vaccination_date || new Date(),
          rabbit_id: rabbit_id,
          description: `Vaccination: ${vaccine_name}`,
          created_by: req.user.id
        }, { transaction: t });
      }

      await t.commit();

      // Fetch created vaccination with rabbit info
      const result = await Vaccination.findByPk(vaccination.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date'],
            include: [{ model: Breed, as: 'breed', attributes: ['id', 'name'] }]
          }
        ]
      });

      return ApiResponse.created(res, result, 'Запись о вакцинации успешно создана');
    } catch (error) {
      await t.rollback();
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  /**
   * Get vaccination by ID
   * GET /api/v1/vaccinations/:id
   */
  async getById(req, res, next) {
    try {
      const vaccination = await Vaccination.findByPk(req.params.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date', 'photo_url'],
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ]
      });

      if (!vaccination) {
        return ApiResponse.notFound(res, 'Запись о вакцинации не найдена');
      }

      return ApiResponse.success(res, vaccination);
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get list of vaccinations
   * GET /api/v1/vaccinations
   */
  async list(req, res, next) {
    try {
      const {
        page = 1,
        limit = 50,
        sort_by = 'vaccination_date',
        sort_order = 'DESC',
        rabbit_id,
        vaccine_type,
        from_date,
        to_date,
        upcoming // Show upcoming vaccinations (next_vaccination_date)
      } = req.query;

      const offset = (parseInt(page) - 1) * parseInt(limit);
      const where = {};

      // Filters
      if (rabbit_id) where.rabbit_id = rabbit_id;
      if (vaccine_type) where.vaccine_type = vaccine_type;
      if (from_date) {
        where.vaccination_date = {
          ...where.vaccination_date,
          [Op.gte]: from_date
        };
      }
      if (to_date) {
        where.vaccination_date = {
          ...where.vaccination_date,
          [Op.lte]: to_date
        };
      }

      // Filter for upcoming vaccinations
      if (upcoming === 'true') {
        where.next_vaccination_date = {
          [Op.gte]: new Date(),
          [Op.lte]: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000) // Next 90 days
        };
      }

      const vaccinations = await Vaccination.findAndCountAll({
        where,
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date', 'photo_url', 'status'],
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ],
        limit: parseInt(limit),
        offset,
        order: [[sort_by, sort_order.toUpperCase()]],
        distinct: true
      });

      return ApiResponse.paginated(
        res,
        vaccinations.rows,
        parseInt(page),
        parseInt(limit),
        vaccinations.count,
        'Список вакцинаций получен успешно'
      );
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get vaccinations for specific rabbit
   * GET /api/v1/rabbits/:rabbitId/vaccinations
   */
  async getByRabbit(req, res, next) {
    try {
      const { rabbitId } = req.params;

      // Check if rabbit exists and belongs to user
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: req.user.id
        }
      });
      if (!rabbit) {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }

      const vaccinations = await Vaccination.findAll({
        where: { rabbit_id: rabbitId },
        order: [['vaccination_date', 'DESC']],
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id']
          }
        ]
      });

      return ApiResponse.success(res, vaccinations, 'История вакцинаций получена успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update vaccination record
   * PUT /api/v1/vaccinations/:id
   */
  async update(req, res, next) {
    try {
      const vaccination = await Vaccination.findByPk(req.params.id);

      if (!vaccination) {
        return ApiResponse.notFound(res, 'Запись о вакцинации не найдена');
      }

      // If rabbit_id is being updated, check if new rabbit exists and belongs to user
      if (req.body.rabbit_id && req.body.rabbit_id !== vaccination.rabbit_id) {
        const rabbit = await Rabbit.findOne({
          where: {
            id: req.body.rabbit_id,
            user_id: req.user.id
          }
        });
        if (!rabbit) {
          return ApiResponse.notFound(res, 'Кролик не найден');
        }
      }

      await vaccination.update(req.body);

      // Fetch updated vaccination with rabbit info
      const result = await Vaccination.findByPk(vaccination.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex'],
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ]
      });

      return ApiResponse.success(res, result, 'Запись о вакцинации успешно обновлена');
    } catch (error) {
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  /**
   * Delete vaccination record
   * DELETE /api/v1/vaccinations/:id
   */
  async delete(req, res, next) {
    try {
      const vaccination = await Vaccination.findOne({
        where: { id: req.params.id },
        include: [{
          model: Rabbit,
          as: 'rabbit',
          where: { user_id: req.user.id },
          attributes: ['id']
        }]
      });

      if (!vaccination) {
        return ApiResponse.notFound(res, 'Запись о вакцинации не найдена');
      }

      await vaccination.destroy();

      return ApiResponse.success(res, null, 'Запись о вакцинации успешно удалена');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get vaccination statistics
   * GET /api/v1/vaccinations/statistics
   */
  async getStatistics(req, res, next) {
    try {
      const user_id = req.user.id;
      const now = new Date();
      const thirtyDaysFromNow = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
      const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
      const yearStart = new Date(now.getFullYear(), 0, 1);

      const rabbitInclude = {
        model: Rabbit,
        as: 'rabbit',
        where: { user_id },
        attributes: []
      };

      // Run all aggregate queries in parallel
      const [
        totalVaccinations,
        byVaccineType,
        thisYear,
        last30Days,
        upcomingTotal,
        upcomingNext30Days,
        overdueCount,
        upcomingList
      ] = await Promise.all([
        // Total count
        Vaccination.count({
          include: [rabbitInclude]
        }),

        // Count by vaccine_type
        Vaccination.findAll({
          attributes: [
            'vaccine_type',
            [sequelize.fn('COUNT', sequelize.col('Vaccination.id')), 'count']
          ],
          include: [rabbitInclude],
          group: ['vaccine_type'],
          raw: true
        }),

        // This year count
        Vaccination.count({
          where: { vaccination_date: { [Op.gte]: yearStart } },
          include: [rabbitInclude]
        }),

        // Last 30 days count
        Vaccination.count({
          where: { vaccination_date: { [Op.gte]: thirtyDaysAgo } },
          include: [rabbitInclude]
        }),

        // Upcoming total (next_vaccination_date >= now)
        Vaccination.count({
          where: { next_vaccination_date: { [Op.gte]: now } },
          include: [rabbitInclude]
        }),

        // Upcoming next 30 days
        Vaccination.count({
          where: {
            next_vaccination_date: { [Op.gte]: now, [Op.lte]: thirtyDaysFromNow }
          },
          include: [rabbitInclude]
        }),

        // Overdue (next_vaccination_date < now)
        Vaccination.count({
          where: {
            next_vaccination_date: { [Op.lt]: now, [Op.not]: null }
          },
          include: [rabbitInclude]
        }),

        // Upcoming + overdue list (only records with next_vaccination_date)
        Vaccination.findAll({
          where: {
            next_vaccination_date: { [Op.not]: null }
          },
          include: [{
            model: Rabbit,
            as: 'rabbit',
            where: { user_id },
            attributes: ['id', 'name']
          }],
          attributes: ['id', 'rabbit_id', 'vaccine_name', 'vaccine_type', 'next_vaccination_date'],
          order: [['next_vaccination_date', 'ASC']]
        })
      ]);

      // Build by_vaccine_type map from SQL results
      const byTypeMap = { vhd: 0, myxomatosis: 0, pasteurellosis: 0, other: 0 };
      byVaccineType.forEach(row => {
        const type = row.vaccine_type;
        if (type in byTypeMap) {
          byTypeMap[type] = parseInt(row.count, 10);
        }
      });

      // Build upcoming list from fetched records
      const list = upcomingList.map(v => {
        const nextDate = new Date(v.next_vaccination_date);
        const daysUntil = Math.ceil((nextDate - now) / (1000 * 60 * 60 * 24));
        const entry = {
          id: v.id,
          rabbit_id: v.rabbit_id,
          rabbit_name: v.rabbit?.name,
          vaccine_name: v.vaccine_name,
          vaccine_type: v.vaccine_type,
          next_vaccination_date: v.next_vaccination_date,
          days_until: daysUntil
        };
        if (nextDate < now) {
          entry.is_overdue = true;
        }
        return entry;
      });

      // Sort by days_until
      list.sort((a, b) => a.days_until - b.days_until);

      const stats = {
        total_vaccinations: totalVaccinations,
        by_vaccine_type: byTypeMap,
        upcoming: {
          total: upcomingTotal,
          next_30_days: upcomingNext30Days,
          overdue: overdueCount,
          list
        },
        this_year: thisYear,
        last_30_days: last30Days
      };

      return ApiResponse.success(res, stats, 'Статистика вакцинаций получена успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get upcoming vaccinations (calendar view)
   * GET /api/v1/vaccinations/upcoming
   */
  async getUpcoming(req, res, next) {
    try {
      const { days = 30 } = req.query;
      const now = new Date();
      const futureDate = new Date(Date.now() + parseInt(days) * 24 * 60 * 60 * 1000);

      const vaccinations = await Vaccination.findAll({
        where: {
          next_vaccination_date: {
            [Op.between]: [now, futureDate]
          }
        },
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'name', 'tag_id', 'sex', 'status', 'photo_url'],
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ],
        order: [['next_vaccination_date', 'ASC']]
      });

      // Calculate days until for each
      const result = vaccinations.map(v => {
        const vac = v.toJSON();
        vac.days_until = Math.ceil(
          (new Date(v.next_vaccination_date) - now) / (1000 * 60 * 60 * 24)
        );
        return vac;
      });

      return ApiResponse.success(
        res,
        result,
        `Предстоящие вакцинации (следующие ${days} дней)`
      );
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get overdue vaccinations
   * GET /api/v1/vaccinations/overdue
   */
  async getOverdue(req, res, next) {
    try {
      const vaccinations = await Vaccination.findAll({
        where: {
          next_vaccination_date: {
            [Op.lt]: new Date()
          }
        },
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex', 'status', 'photo_url'],
            where: {
              user_id: req.user.id, // Filter by user
              status: {
                [Op.in]: ['healthy', 'pregnant', 'sick'] // Exclude dead/sold
              }
            },
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ],
        order: [['next_vaccination_date', 'ASC']]
      });

      const now = new Date();
      const result = vaccinations.map(v => {
        const vac = v.toJSON();
        vac.days_overdue = Math.ceil(
          (now - new Date(v.next_vaccination_date)) / (1000 * 60 * 60 * 24)
        );
        return vac;
      });

      return ApiResponse.success(res, result, 'Просроченные вакцинации');
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new VaccinationController();
