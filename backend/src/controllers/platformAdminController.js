const planService = require('../services/planService');
const platformAdminService = require('../services/platformAdminService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Платформенная админка — тарифы и фермы across the board.
 * Доступ только платформенному админу, см. middleware/auth.js.
 */
class PlatformAdminController {
  /** GET /platform-admin/plans */
  async listPlans(req, res, next) {
    try {
      const plans = await planService.list();
      return ApiResponse.success(res, plans, 'Список тарифов получен');
    } catch (error) {
      next(error);
    }
  }

  /** POST /platform-admin/plans */
  async createPlan(req, res, next) {
    try {
      const plan = await planService.create(req.body);
      return ApiResponse.created(res, plan, 'Тариф создан');
    } catch (error) {
      if (error.message === 'PLAN_NAME_EXISTS') {
        return ApiResponse.conflict(res, 'Тариф с таким названием уже существует');
      }
      next(error);
    }
  }

  /** PUT /platform-admin/plans/:id */
  async updatePlan(req, res, next) {
    try {
      const plan = await planService.update(req.params.id, req.body);
      return ApiResponse.success(res, plan, 'Тариф обновлён');
    } catch (error) {
      if (error.message === 'PLAN_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Тариф не найден');
      }
      if (error.message === 'PLAN_NAME_EXISTS') {
        return ApiResponse.conflict(res, 'Тариф с таким названием уже существует');
      }
      next(error);
    }
  }

  /** DELETE /platform-admin/plans/:id */
  async deletePlan(req, res, next) {
    try {
      await planService.delete(req.params.id);
      return ApiResponse.success(res, null, 'Тариф удалён');
    } catch (error) {
      if (error.message === 'PLAN_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Тариф не найден');
      }
      next(error);
    }
  }

  /** GET /platform-admin/farms */
  async listFarms(req, res, next) {
    try {
      const result = await platformAdminService.listFarms(req.query);
      return ApiResponse.paginated(
        res,
        result.items,
        result.pagination.page,
        result.pagination.limit,
        result.pagination.total,
        'Список ферм получен'
      );
    } catch (error) {
      next(error);
    }
  }

  /** PATCH /platform-admin/farms/:id/plan */
  async assignPlan(req, res, next) {
    try {
      const farm = await platformAdminService.assignPlan(req.params.id, req.body.plan_id);
      return ApiResponse.success(res, farm, 'Тариф фермы обновлён');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      if (error.message === 'PLAN_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Тариф не найден');
      }
      if (error.message === 'PLAN_INACTIVE') {
        return ApiResponse.badRequest(res, 'Тариф выключен — включите его или выберите другой');
      }
      next(error);
    }
  }
}

module.exports = new PlatformAdminController();
