const planService = require('../services/planService');
const platformAdminService = require('../services/platformAdminService');
const auditService = require('../services/auditService');
const ApiResponse = require('../utils/apiResponse');

/** Sequelize-инстанс -> обычный объект, если можно; иначе как есть. */
const toPlain = (value) => (value && typeof value.toJSON === 'function' ? value.toJSON() : value);

/**
 * Платформенная админка — тарифы и фермы across the board.
 * Доступ только платформенному админу, см. middleware/auth.js.
 * Каждое мутирующее действие пишет строку в журнал (`auditService`) —
 * см. docs/plans/PLATFORM-ADMIN.md, 1.1.
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
      await auditService.record({
        adminId: req.user.id,
        action: 'plan.create',
        after: toPlain(plan),
        ip: req.ip
      });
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
      const before = await planService.getById(req.params.id);
      const plan = await planService.update(req.params.id, req.body);
      await auditService.record({
        adminId: req.user.id,
        action: 'plan.update',
        before: toPlain(before),
        after: toPlain(plan),
        ip: req.ip
      });
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
      const before = await planService.getById(req.params.id);
      await planService.delete(req.params.id);
      await auditService.record({
        adminId: req.user.id,
        action: 'plan.delete',
        before: toPlain(before),
        ip: req.ip
      });
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
      // Старое значение читаем до вызова сервиса — assignPlan уже
      // перезаписывает ферму и возвращает её в обновлённом виде, взять
      // «было» оттуда после вызова уже нельзя.
      const before = await platformAdminService.getFarm(req.params.id);
      const farm = await platformAdminService.assignPlan(req.params.id, req.body.plan_id);
      await auditService.record({
        adminId: req.user.id,
        action: 'plan.assign',
        farmId: req.params.id,
        before: { plan_id: before.plan_id },
        after: { plan_id: farm.plan_id },
        ip: req.ip
      });
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

  /** GET /platform-admin/audit */
  async listAudit(req, res, next) {
    try {
      const result = await auditService.list({
        page: req.query.page,
        limit: req.query.limit,
        farmId: req.query.farm_id
      });
      return ApiResponse.paginated(
        res,
        result.items,
        result.pagination.page,
        result.pagination.limit,
        result.pagination.total,
        'Журнал действий получен'
      );
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new PlatformAdminController();
