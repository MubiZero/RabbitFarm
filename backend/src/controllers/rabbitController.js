const rabbitService = require('../services/rabbitService');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

/**
 * Rabbit controller
 * Handles HTTP requests for rabbit management
 */
class RabbitController {
  /**
   * Create new rabbit
   * POST /api/v1/rabbits
   */
  async create(req, res, next) {
    try {
      // If photo uploaded, add to request body
      if (req.file) {
        req.body.photo_url = `/uploads/rabbits/${req.file.filename}`;
      }

      // Add user_id from authenticated user
      req.body.user_id = req.user.id;

      const rabbit = await rabbitService.createRabbit(req.body);

      return ApiResponse.created(res, rabbit, 'Кролик успешно добавлен');
    } catch (error) {
      if (error.message === 'BREED_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Порода не найдена');
      }
      if (error.message === 'CAGE_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Клетка не найдена');
      }
      if (error.message === 'TAG_ID_EXISTS') {
        return ApiResponse.badRequest(res, 'Кролик с таким ID клейма уже существует');
      }
      next(error);
    }
  }

  /**
   * Get rabbit by ID
   * GET /api/v1/rabbits/:id
   */
  async getById(req, res, next) {
    try {
      const rabbit = await rabbitService.getRabbitById(req.params.id);

      return ApiResponse.success(res, rabbit);
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      next(error);
    }
  }

  /**
   * Get list of rabbits
   * GET /api/v1/rabbits
   */
  async list(req, res, next) {
    try {
      const { page, limit, sort_by, sort_order, ...filters } = req.query;

      const result = await rabbitService.listRabbits(
        filters,
        { page, limit, sort_by, sort_order }
      );

      return ApiResponse.paginated(
        res,
        result.items,
        result.pagination.page,
        result.pagination.limit,
        result.pagination.total,
        'Список кроликов получен успешно'
      );
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update rabbit
   * PUT /api/v1/rabbits/:id
   */
  async update(req, res, next) {
    try {
      // If photo uploaded, add to request body
      if (req.file) {
        req.body.photo_url = `/uploads/rabbits/${req.file.filename}`;
      }

      const rabbit = await rabbitService.updateRabbit(req.params.id, req.body);

      return ApiResponse.success(res, rabbit, 'Кролик успешно обновлен');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      if (error.message === 'BREED_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Порода не найдена');
      }
      if (error.message === 'CAGE_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Клетка не найдена');
      }
      if (error.message === 'TAG_ID_EXISTS') {
        return ApiResponse.badRequest(res, 'Кролик с таким ID клейма уже существует');
      }
      next(error);
    }
  }

  /**
   * Delete rabbit
   * DELETE /api/v1/rabbits/:id
   */
  async delete(req, res, next) {
    try {
      await rabbitService.deleteRabbit(req.params.id);

      return ApiResponse.success(res, null, 'Кролик успешно удален');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      if (error.message === 'RABBIT_HAS_OFFSPRING') {
        return ApiResponse.badRequest(res, 'Невозможно удалить кролика с потомством');
      }
      next(error);
    }
  }

  /**
   * Get weight history
   * GET /api/v1/rabbits/:id/weights
   */
  async getWeightHistory(req, res, next) {
    try {
      const weights = await rabbitService.getWeightHistory(req.params.id);

      return ApiResponse.success(res, weights, 'История взвешиваний получена успешно');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      next(error);
    }
  }

  /**
   * Add weight record
   * POST /api/v1/rabbits/:id/weights
   */
  async addWeight(req, res, next) {
    try {
      const weight = await rabbitService.addWeightRecord(req.params.id, req.body);

      return ApiResponse.created(res, weight, 'Вес добавлен успешно');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      next(error);
    }
  }

  /**
   * Get statistics
   * GET /api/v1/rabbits/statistics
   */
  async getStatistics(req, res, next) {
    try {
      const stats = await rabbitService.getStatistics();

      return ApiResponse.success(res, stats, 'Статистика получена успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get pedigree
   * GET /api/v1/rabbits/:id/pedigree
   */
  async getPedigree(req, res, next) {
    try {
      const generations = parseInt(req.query.generations) || 3;
      const pedigree = await rabbitService.getPedigree(req.params.id, generations);

      return ApiResponse.success(res, pedigree, 'Родословная получена успешно');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      next(error);
    }
  }

  /**
   * Upload rabbit photo
   * POST /api/v1/rabbits/:id/photo
   */
  async uploadPhoto(req, res, next) {
    try {
      if (!req.file) {
        return ApiResponse.badRequest(res, 'Файл не загружен');
      }

      const photoUrl = `/uploads/rabbits/${req.file.filename}`;

      // Update rabbit with new photo
      const rabbit = await rabbitService.updateRabbit(req.params.id, {
        photo_url: photoUrl
      });

      return ApiResponse.success(res, rabbit, 'Фото загружено успешно');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      next(error);
    }
  }

  /**
   * Delete rabbit photo
   * DELETE /api/v1/rabbits/:id/photo
   */
  async deletePhoto(req, res, next) {
    try {
      // Update rabbit to remove photo
      const rabbit = await rabbitService.updateRabbit(req.params.id, {
        photo_url: null
      });

      return ApiResponse.success(res, rabbit, 'Фото удалено успешно');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      next(error);
    }
  }
}

module.exports = new RabbitController();
