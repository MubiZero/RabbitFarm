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
      const rabbit = await rabbitService.getRabbitById(req.params.id, req.user.id);

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
        req.user.id,
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

      const rabbit = await rabbitService.updateRabbit(req.params.id, req.user.id, req.body);

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
      if (error.message === 'CANNOT_CHANGE_SEX_WITH_HISTORY') {
        return ApiResponse.badRequest(res, 'Нельзя менять пол после того, как у кролика появилось потомство или история случек');
      }
      if (error.message === 'FATHER_NOT_FOUND_OR_INVALID_SEX') {
        return ApiResponse.badRequest(res, 'Отец не найден или должен быть самцом');
      }
      if (error.message === 'MOTHER_NOT_FOUND_OR_INVALID_SEX') {
        return ApiResponse.badRequest(res, 'Мать не найдена или должна быть самкой');
      }
      if (error.message === 'CAGE_FULL') {
        return ApiResponse.badRequest(res, 'Клетка уже заполнена');
      }
      if (error.message === 'CANNOT_BE_OWN_FATHER' || error.message === 'CANNOT_BE_OWN_MOTHER') {
        return ApiResponse.badRequest(res, 'Кролик не может быть родителем самому себе');
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
      await rabbitService.deleteRabbit(req.params.id, req.user.id);

      return ApiResponse.success(res, null, 'Кролик успешно удален');
    } catch (error) {
      if (error.message === 'RABBIT_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }
      if (error.message === 'RABBIT_HAS_OFFSPRING') {
        return ApiResponse.badRequest(res, 'Невозможно удалить кролика с потомством');
      }
      if (error.message === 'RABBIT_HAS_BREEDING_HISTORY') {
        return ApiResponse.badRequest(res, 'Невозможно удалить: у кролика есть история случек');
      }
      if (error.message === 'RABBIT_HAS_BIRTH_HISTORY') {
        return ApiResponse.badRequest(res, 'Невозможно удалить: у самки есть история окролов');
      }
      if (error.message === 'RABBIT_HAS_HEALTH_HISTORY') {
        return ApiResponse.badRequest(res, 'Невозможно удалить: у кролика есть медицинские записи или вакцинации');
      }
      if (error.message === 'RABBIT_HAS_FINANCIAL_HISTORY') {
        return ApiResponse.badRequest(res, 'Невозможно удалить: с кроликом связаны финансовые операции');
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
      const weights = await rabbitService.getWeightHistory(req.params.id, req.user.id);

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
      const weight = await rabbitService.addWeightRecord(req.params.id, req.user.id, req.body);

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
      const stats = await rabbitService.getStatistics(req.user.id);

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
      const pedigree = await rabbitService.getPedigree(req.params.id, req.user.id, generations);

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
      const rabbit = await rabbitService.updateRabbit(req.params.id, req.user.id, {
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
      const rabbit = await rabbitService.updateRabbit(req.params.id, req.user.id, {
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
