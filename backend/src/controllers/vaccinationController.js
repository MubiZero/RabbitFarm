const { Vaccination, Rabbit, Breed } = require('../models');
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
    try {
      const { rabbit_id } = req.body;

      // Check if rabbit exists
      const rabbit = await Rabbit.findByPk(rabbit_id);
      if (!rabbit) {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }

      const vaccination = await Vaccination.create(req.body);

      // Fetch created vaccination with rabbit info
      const result = await Vaccination.findByPk(vaccination.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date'],
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

      return ApiResponse.created(res, result, 'Запись о вакцинации успешно создана');
    } catch (error) {
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
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date', 'photo_url', 'status'],
            include: [
              {
                model: Breed,
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

      // Check if rabbit exists
      const rabbit = await Rabbit.findByPk(rabbitId);
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

      // If rabbit_id is being updated, check if new rabbit exists
      if (req.body.rabbit_id && req.body.rabbit_id !== vaccination.rabbit_id) {
        const rabbit = await Rabbit.findByPk(req.body.rabbit_id);
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
      const vaccination = await Vaccination.findByPk(req.params.id);

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
      const vaccinations = await Vaccination.findAll({
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'status']
          }
        ]
      });

      const now = new Date();
      const thirtyDaysFromNow = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

      const stats = {
        total_vaccinations: vaccinations.length,
        by_vaccine_type: {
          vhd: 0,
          myxomatosis: 0,
          pasteurellosis: 0,
          other: 0
        },
        upcoming: {
          total: 0,
          next_30_days: 0,
          overdue: 0,
          list: []
        },
        this_year: 0,
        last_30_days: 0
      };

      const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
      const yearStart = new Date(now.getFullYear(), 0, 1);

      vaccinations.forEach(vaccination => {
        // Count by type
        stats.by_vaccine_type[vaccination.vaccine_type]++;

        // Count this year
        if (new Date(vaccination.vaccination_date) >= yearStart) {
          stats.this_year++;
        }

        // Count last 30 days
        if (new Date(vaccination.vaccination_date) >= thirtyDaysAgo) {
          stats.last_30_days++;
        }

        // Check upcoming vaccinations
        if (vaccination.next_vaccination_date) {
          const nextDate = new Date(vaccination.next_vaccination_date);

          if (nextDate >= now) {
            stats.upcoming.total++;

            if (nextDate <= thirtyDaysFromNow) {
              stats.upcoming.next_30_days++;
              stats.upcoming.list.push({
                id: vaccination.id,
                rabbit_id: vaccination.rabbit_id,
                rabbit_name: vaccination.rabbit?.name,
                vaccine_name: vaccination.vaccine_name,
                vaccine_type: vaccination.vaccine_type,
                next_vaccination_date: vaccination.next_vaccination_date,
                days_until: Math.ceil((nextDate - now) / (1000 * 60 * 60 * 24))
              });
            }
          } else {
            // Overdue
            stats.upcoming.overdue++;
            stats.upcoming.list.push({
              id: vaccination.id,
              rabbit_id: vaccination.rabbit_id,
              rabbit_name: vaccination.rabbit?.name,
              vaccine_name: vaccination.vaccine_name,
              vaccine_type: vaccination.vaccine_type,
              next_vaccination_date: vaccination.next_vaccination_date,
              days_until: Math.ceil((nextDate - now) / (1000 * 60 * 60 * 24)),
              is_overdue: true
            });
          }
        }
      });

      // Sort upcoming list by days_until
      stats.upcoming.list.sort((a, b) => a.days_until - b.days_until);

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
            attributes: ['id', 'name', 'tag_id', 'sex', 'status', 'photo_url'],
            include: [
              {
                model: Breed,
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
              status: {
                [Op.in]: ['healthy', 'pregnant', 'sick'] // Exclude dead/sold
              }
            },
            include: [
              {
                model: Breed,
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
