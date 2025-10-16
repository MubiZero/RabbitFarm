const breedService = require('../services/breedService');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

/**
 * Breed controller
 * Handles HTTP requests for breed management
 */
class BreedController {
  /**
   * Get all breeds
   * GET /api/v1/breeds
   */
  async list(req, res, next) {
    try {
      const breeds = await breedService.getAllBreeds();

      return ApiResponse.success(res, breeds, 'Список пород получен успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get breed by ID
   * GET /api/v1/breeds/:id
   */
  async getById(req, res, next) {
    try {
      const breed = await breedService.getBreedById(req.params.id);

      return ApiResponse.success(res, breed);
    } catch (error) {
      if (error.message === 'BREED_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Порода не найдена');
      }
      next(error);
    }
  }

  /**
   * Create new breed
   * POST /api/v1/breeds
   */
  async create(req, res, next) {
    try {
      const breed = await breedService.createBreed(req.body);

      return ApiResponse.created(res, breed, 'Порода успешно создана');
    } catch (error) {
      if (error.message === 'BREED_NAME_EXISTS') {
        return ApiResponse.badRequest(res, 'Порода с таким названием уже существует');
      }
      next(error);
    }
  }

  /**
   * Update breed
   * PUT /api/v1/breeds/:id
   */
  async update(req, res, next) {
    try {
      const breed = await breedService.updateBreed(req.params.id, req.body);

      return ApiResponse.success(res, breed, 'Порода успешно обновлена');
    } catch (error) {
      if (error.message === 'BREED_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Порода не найдена');
      }
      if (error.message === 'BREED_NAME_EXISTS') {
        return ApiResponse.badRequest(res, 'Порода с таким названием уже существует');
      }
      next(error);
    }
  }

  /**
   * Delete breed
   * DELETE /api/v1/breeds/:id
   */
  async delete(req, res, next) {
    try {
      await breedService.deleteBreed(req.params.id);

      return ApiResponse.success(res, null, 'Порода успешно удалена');
    } catch (error) {
      if (error.message === 'BREED_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Порода не найдена');
      }
      if (error.message === 'BREED_HAS_RABBITS') {
        return ApiResponse.badRequest(res, 'Невозможно удалить породу, у которой есть кролики');
      }
      next(error);
    }
  }
}

module.exports = new BreedController();
