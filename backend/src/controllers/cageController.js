const cageService = require('../services/cageService');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

/**
 * Cage controller
 * Handles HTTP requests for cage management
 */
class CageController {
  async create(req, res, next) {
    try {
      const cage = await cageService.createCage({ ...req.body, user_id: req.user.id });
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

  async getById(req, res, next) {
    try {
      const cage = await cageService.getCageById(req.params.id, req.user.id);
      return ApiResponse.success(res, cage);
    } catch (error) {
      if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.notFound(res, 'Клетка не найдена');
      next(error);
    }
  }

  async list(req, res, next) {
    try {
      const result = await cageService.listCages(req.user.id, req.query);
      return ApiResponse.paginated(
        res,
        result.items,
        result.page,
        result.limit,
        result.total,
        'Список клеток получен успешно'
      );
    } catch (error) {
      next(error);
    }
  }

  async update(req, res, next) {
    try {
      const cage = await cageService.updateCage(req.params.id, req.user.id, req.body);
      return ApiResponse.success(res, cage, 'Клетка успешно обновлена');
    } catch (error) {
      if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.notFound(res, 'Клетка не найдена');
      if (error.name === 'SequelizeUniqueConstraintError') {
        return ApiResponse.badRequest(res, 'Клетка с таким номером уже существует');
      }
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  async delete(req, res, next) {
    try {
      await cageService.deleteCage(req.params.id, req.user.id);
      return ApiResponse.success(res, null, 'Клетка успешно удалена');
    } catch (error) {
      if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.notFound(res, 'Клетка не найдена');
      if (error.message === 'CAGE_HAS_RABBITS') {
        return ApiResponse.badRequest(res, 'Невозможно удалить клетку с кроликами. Сначала переместите кроликов.');
      }
      next(error);
    }
  }

  async getStatistics(req, res, next) {
    try {
      const stats = await cageService.getStatistics(req.user.id);
      return ApiResponse.success(res, stats, 'Статистика клеток получена успешно');
    } catch (error) {
      next(error);
    }
  }

  async markCleaned(req, res, next) {
    try {
      const cage = await cageService.markCleaned(req.params.id, req.user.id);
      return ApiResponse.success(res, cage, 'Отметка об уборке сохранена');
    } catch (error) {
      if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.notFound(res, 'Клетка не найдена');
      next(error);
    }
  }

  async getLayout(req, res, next) {
    try {
      const layout = await cageService.getLayout(req.user.id);
      return ApiResponse.success(res, layout, 'Схема размещения получена успешно');
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new CageController();
