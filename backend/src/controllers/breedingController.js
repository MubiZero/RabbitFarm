const breedingService = require('../services/breedingService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Breeding controller
 * Handles HTTP requests for breeding management
 */
class BreedingController {
    /**
     * Create new breeding record
     * POST /api/v1/breeding
     */
    async create(req, res, next) {
        try {
            // Add user_id from authenticated user
            req.body.user_id = req.user.id;

            const breeding = await breedingService.createBreeding(req.body);
            return ApiResponse.created(res, breeding, 'Случка успешно зарегистрирована');
        } catch (error) {
            if (error.message === 'MALE_NOT_FOUND') {
                return ApiResponse.notFound(res, 'Самец не найден');
            }
            if (error.message === 'FEMALE_NOT_FOUND') {
                return ApiResponse.notFound(res, 'Самка не найдена');
            }
            if (error.message === 'INVALID_MALE_SEX') {
                return ApiResponse.badRequest(res, 'Выбранный кролик не является самцом');
            }
            if (error.message === 'INVALID_FEMALE_SEX') {
                return ApiResponse.badRequest(res, 'Выбранный кролик не является самкой');
            }
            next(error);
        }
    }

    /**
     * Get breeding by ID
     * GET /api/v1/breeding/:id
     */
    async getById(req, res, next) {
        try {
            const breeding = await breedingService.getBreedingById(req.params.id, req.user.id);
            return ApiResponse.success(res, breeding);
        } catch (error) {
            if (error.message === 'BREEDING_NOT_FOUND') {
                return ApiResponse.notFound(res, 'Запись о случке не найдена');
            }
            next(error);
        }
    }

    /**
     * List breedings
     * GET /api/v1/breeding
     */
    async list(req, res, next) {
        try {
            const { page, limit, sort_by, sort_order, ...filters } = req.query;
            const result = await breedingService.listBreedings(req.user.id, filters, { page, limit, sort_by, sort_order });

            return ApiResponse.paginated(
                res,
                result.items,
                result.pagination.page,
                result.pagination.limit,
                result.pagination.total,
                'Список случек получен успешно'
            );
        } catch (error) {
            next(error);
        }
    }

    /**
     * Update breeding
     * PUT /api/v1/breeding/:id
     */
    async update(req, res, next) {
        try {
            const breeding = await breedingService.updateBreeding(req.params.id, req.user.id, req.body);
            return ApiResponse.success(res, breeding, 'Запись обновлена успешно');
        } catch (error) {
            if (error.message === 'BREEDING_NOT_FOUND') {
                return ApiResponse.notFound(res, 'Запись о случке не найдена');
            }
            if (error.message === 'INVALID_MALE' || error.message === 'INVALID_FEMALE') {
                return ApiResponse.badRequest(res, 'Некорректный ID самца или самки');
            }
            next(error);
        }
    }

    /**
     * Delete breeding
     * DELETE /api/v1/breeding/:id
     */
    async delete(req, res, next) {
        try {
            await breedingService.deleteBreeding(req.params.id, req.user.id);
            return ApiResponse.success(res, null, 'Запись удалена успешно');
        } catch (error) {
            if (error.message === 'BREEDING_NOT_FOUND') {
                return ApiResponse.notFound(res, 'Запись о случке не найдена');
            }
            next(error);
        }
    }

    /**
     * Get statistics
     * GET /api/v1/breeding/statistics
     */
    async getStatistics(req, res, next) {
        try {
            const stats = await breedingService.getStatistics(req.user.id);
            return ApiResponse.success(res, stats, 'Статистика получена успешно');
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new BreedingController();
