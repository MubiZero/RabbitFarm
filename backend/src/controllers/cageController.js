const { Cage, Rabbit, Breed } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');
const { Op } = require('sequelize');

/**
 * Cage controller
 * Handles HTTP requests for cage management
 */
class CageController {
  /**
   * Create new cage
   * POST /api/v1/cages
   */
  async create(req, res, next) {
    try {
      const cage = await Cage.create({
        ...req.body,
        user_id: req.user.id
      });

      return ApiResponse.created(res, cage, 'Клетка успешно создана');
    } catch (error) {
      if (error.name === 'SequelizeUniqueConstraintError') {
        return ApiResponse.badRequest(res, 'Клетка с таким номером уже существует');
      }
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  /**
   * Get cage by ID
   * GET /api/v1/cages/:id
   */
  async getById(req, res, next) {
    try {
      const cage = await Cage.findOne({
        where: {
          id: req.params.id,
          user_id: req.user.id
        },
        include: [
          {
            model: Rabbit,
            as: 'rabbits',
            attributes: ['id', 'name', 'tag_id', 'sex', 'status', 'breed_id']
          }
        ]
      });

      if (!cage) {
        return ApiResponse.notFound(res, 'Клетка не найдена');
      }

      // Add occupancy info
      const cageData = cage.toJSON();
      cageData.current_occupancy = cage.rabbits ? cage.rabbits.length : 0;
      cageData.is_full = cageData.current_occupancy >= cage.capacity;
      cageData.is_available = cageData.current_occupancy < cage.capacity && cage.condition === 'good';

      return ApiResponse.success(res, cageData);
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get list of cages
   * GET /api/v1/cages
   */
  async list(req, res, next) {
    try {
      const {
        page = 1,
        limit = 50,
        sort_by = 'number',
        sort_order = 'ASC',
        type,
        condition,
        location,
        search,
        only_available
      } = req.query;

      const offset = (parseInt(page) - 1) * parseInt(limit);
      const where = {
        user_id: req.user.id // Filter by user
      };

      // Filters
      if (type) where.type = type;
      if (condition) where.condition = condition;
      if (location) where.location = { [Op.like]: `%${location}%` };
      if (search) {
        where[Op.or] = [
          { number: { [Op.like]: `%${search}%` } },
          { location: { [Op.like]: `%${search}%` } },
          { notes: { [Op.like]: `%${search}%` } }
        ];
      }

      const cages = await Cage.findAndCountAll({
        where,
        include: [
          {
            model: Rabbit,
            as: 'rabbits',
            attributes: ['id', 'name', 'tag_id', 'sex', 'status']
          }
        ],
        limit: parseInt(limit),
        offset,
        order: [[sort_by, sort_order.toUpperCase()]],
        distinct: true
      });

      // Add occupancy info to each cage
      let items = cages.rows.map(cage => {
        const cageData = cage.toJSON();
        cageData.current_occupancy = cage.rabbits ? cage.rabbits.length : 0;
        cageData.is_full = cageData.current_occupancy >= cage.capacity;
        cageData.is_available = cageData.current_occupancy < cage.capacity && cage.condition === 'good';
        return cageData;
      });

      // Filter by availability if requested
      if (only_available === 'true') {
        items = items.filter(cage => cage.is_available);
      }

      const total = only_available === 'true' ? items.length : cages.count;

      return ApiResponse.paginated(
        res,
        items,
        parseInt(page),
        parseInt(limit),
        total,
        'Список клеток получен успешно'
      );
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update cage
   * PUT /api/v1/cages/:id
   */
  async update(req, res, next) {
    try {
      const cage = await Cage.findOne({
        where: {
          id: req.params.id,
          user_id: req.user.id
        }
      });

      if (!cage) {
        return ApiResponse.notFound(res, 'Клетка не найдена');
      }

      await cage.update(req.body);

      return ApiResponse.success(res, cage, 'Клетка успешно обновлена');
    } catch (error) {
      if (error.name === 'SequelizeUniqueConstraintError') {
        return ApiResponse.badRequest(res, 'Клетка с таким номером уже существует');
      }
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  /**
   * Delete cage
   * DELETE /api/v1/cages/:id
   */
  async delete(req, res, next) {
    try {
      const cage = await Cage.findOne({
        where: {
          id: req.params.id,
          user_id: req.user.id
        },
        include: [{ model: Rabbit, as: 'rabbits' }]
      });

      if (!cage) {
        return ApiResponse.notFound(res, 'Клетка не найдена');
      }

      // Check if cage has rabbits
      if (cage.rabbits && cage.rabbits.length > 0) {
        return ApiResponse.badRequest(
          res,
          'Невозможно удалить клетку с кроликами. Сначала переместите кроликов.'
        );
      }

      await cage.destroy();

      return ApiResponse.success(res, null, 'Клетка успешно удалена');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get cage statistics
   * GET /api/v1/cages/statistics
   */
  async getStatistics(req, res, next) {
    try {
      const cages = await Cage.findAll({
        where: {
          user_id: req.user.id
        },
        include: [
          {
            model: Rabbit,
            as: 'rabbits',
            attributes: ['id']
          }
        ]
      });

      const stats = {
        total_cages: cages.length,
        by_type: {
          single: 0,
          group: 0,
          maternity: 0
        },
        by_condition: {
          good: 0,
          needs_repair: 0,
          broken: 0
        },
        occupancy: {
          total_capacity: 0,
          current_occupancy: 0,
          available_spaces: 0,
          occupancy_rate: 0,
          full_cages: 0,
          empty_cages: 0
        }
      };

      cages.forEach(cage => {
        // Count by type
        stats.by_type[cage.type]++;

        // Count by condition
        stats.by_condition[cage.condition]++;

        // Calculate occupancy
        const currentOccupancy = cage.rabbits ? cage.rabbits.length : 0;
        stats.occupancy.total_capacity += cage.capacity;
        stats.occupancy.current_occupancy += currentOccupancy;

        if (currentOccupancy >= cage.capacity) {
          stats.occupancy.full_cages++;
        }
        if (currentOccupancy === 0) {
          stats.occupancy.empty_cages++;
        }
      });

      stats.occupancy.available_spaces =
        stats.occupancy.total_capacity - stats.occupancy.current_occupancy;

      stats.occupancy.occupancy_rate = stats.occupancy.total_capacity > 0
        ? Math.round((stats.occupancy.current_occupancy / stats.occupancy.total_capacity) * 100)
        : 0;

      return ApiResponse.success(res, stats, 'Статистика клеток получена успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update last cleaned date
   * PATCH /api/v1/cages/:id/clean
   */
  async markCleaned(req, res, next) {
    try {
      const cage = await Cage.findOne({
        where: {
          id: req.params.id,
          user_id: req.user.id
        }
      });

      if (!cage) {
        return ApiResponse.notFound(res, 'Клетка не найдена');
      }

      await cage.update({
        last_cleaned_at: new Date()
      });

      return ApiResponse.success(res, cage, 'Отметка об уборке сохранена');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get cage layout/map
   * GET /api/v1/cages/layout
   */
  async getLayout(req, res, next) {
    try {
      const cages = await Cage.findAll({
        where: {
          user_id: req.user.id
        },
        include: [
          {
            model: Rabbit,
            as: 'rabbits',
            attributes: ['id', 'name', 'tag_id', 'sex', 'status']
          }
        ],
        order: [['location', 'ASC'], ['number', 'ASC']]
      });

      // Group cages by location
      const layout = {};

      cages.forEach(cage => {
        const location = cage.location || 'Без локации';

        if (!layout[location]) {
          layout[location] = [];
        }

        const cageData = cage.toJSON();
        cageData.current_occupancy = cage.rabbits ? cage.rabbits.length : 0;
        cageData.is_full = cageData.current_occupancy >= cage.capacity;
        cageData.is_available = cageData.current_occupancy < cage.capacity && cage.condition === 'good';

        layout[location].push(cageData);
      });

      return ApiResponse.success(res, layout, 'Схема размещения получена успешно');
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new CageController();
