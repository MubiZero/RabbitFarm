const planService = require('../services/planService');
const platformAdminService = require('../services/platformAdminService');
const farmExportService = require('../services/farmExportService');
const announcementService = require('../services/announcementService');
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
      if (error.message === 'DEFAULT_PLAN_EXISTS') {
        return ApiResponse.badRequest(res, 'Тариф по умолчанию уже назначен другому — сначала снимите флаг с него');
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
      if (error.message === 'DEFAULT_PLAN_EXISTS') {
        return ApiResponse.badRequest(res, 'Тариф по умолчанию уже назначен другому — сначала снимите флаг с него');
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

  /** GET /platform-admin/farms/:id */
  async getFarm(req, res, next) {
    try {
      const farm = await platformAdminService.getFarm(req.params.id);
      return ApiResponse.success(res, farm, 'Ферма получена');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
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

  /** PATCH /platform-admin/farms/:id/status */
  async updateStatus(req, res, next) {
    try {
      const before = await platformAdminService.getFarm(req.params.id);
      const farm = await platformAdminService.updateStatus(req.params.id, req.body.status);
      await auditService.record({
        adminId: req.user.id,
        action: 'farm.status',
        farmId: req.params.id,
        before: { status: before.status },
        after: { status: farm.status },
        ip: req.ip
      });
      return ApiResponse.success(res, farm, 'Статус фермы обновлён');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      next(error);
    }
  }

  /** PATCH /platform-admin/farms/:id/extras */
  async updateExtras(req, res, next) {
    try {
      const before = await platformAdminService.getFarm(req.params.id);
      const farm = await platformAdminService.updateExtras(req.params.id, req.body);
      await auditService.record({
        adminId: req.user.id,
        action: 'farm.extras',
        farmId: req.params.id,
        before: {
          extra_rabbits: before.extra_rabbits,
          extra_staff: before.extra_staff,
          extras_until: before.extras_until
        },
        after: {
          extra_rabbits: farm.extra_rabbits,
          extra_staff: farm.extra_staff,
          extras_until: farm.extras_until
        },
        ip: req.ip
      });
      return ApiResponse.success(res, farm, 'Поблажка фермы обновлена');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      next(error);
    }
  }

  /**
   * GET /platform-admin/farms/:id/export
   * Читающее действие, но в журнал пишется всё равно: выгрузка всех данных
   * клиента — это то, о чём потом спрашивают «кто и когда».
   */
  async exportFarm(req, res, next) {
    try {
      const data = await farmExportService.exportFarm(req.params.id);
      await auditService.record({
        adminId: req.user.id,
        action: 'farm.export',
        farmId: req.params.id,
        ip: req.ip
      });
      return ApiResponse.success(res, data, 'Экспорт фермы готов');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      next(error);
    }
  }

  /** DELETE /platform-admin/farms/:id */
  async deleteFarm(req, res, next) {
    try {
      const before = await platformAdminService.getFarm(req.params.id);
      const farm = await platformAdminService.softDelete(req.params.id, req.body.confirm_name);
      await auditService.record({
        adminId: req.user.id,
        action: 'farm.delete',
        farmId: req.params.id,
        before: { deleted_at: before.deleted_at },
        after: { deleted_at: farm.deleted_at },
        ip: req.ip
      });
      return ApiResponse.success(res, farm, 'Ферма удалена — данные будут окончательно очищены через 30 дней');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      if (error.message === 'CONFIRM_NAME_MISMATCH') {
        return ApiResponse.badRequest(
          res,
          'Введённое название не совпадает с названием фермы',
          'CONFIRM_NAME_MISMATCH'
        );
      }
      next(error);
    }
  }

  /** POST /platform-admin/farms/:id/restore */
  async restoreFarm(req, res, next) {
    try {
      const before = await platformAdminService.getFarm(req.params.id);
      const farm = await platformAdminService.restore(req.params.id);
      await auditService.record({
        adminId: req.user.id,
        action: 'farm.restore',
        farmId: req.params.id,
        before: { deleted_at: before.deleted_at },
        after: { deleted_at: farm.deleted_at },
        ip: req.ip
      });
      return ApiResponse.success(res, farm, 'Ферма восстановлена');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      if (error.message === 'FARM_NOT_DELETED') {
        return ApiResponse.badRequest(res, 'Ферма не была удалена', 'FARM_NOT_DELETED');
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

  /**
   * POST /platform-admin/announcements
   * Отправка синхронная — ответ приходит вместе со статистикой доставки,
   * подтверждение перед вызовом делает клиент (действие необратимо и уходит наружу).
   */
  async createAnnouncement(req, res, next) {
    try {
      const announcement = await announcementService.create({
        adminId: req.user.id,
        title: req.body.title,
        body: req.body.body,
        channels: req.body.channels,
        targetType: req.body.target_type,
        targetFarmId: req.body.target_farm_id,
        targetFilter: req.body.target_filter
      });
      await auditService.record({
        adminId: req.user.id,
        action: 'announcement.send',
        farmId: req.body.target_type === 'farm' ? req.body.target_farm_id : null,
        after: {
          id: announcement.id,
          target_type: announcement.target_type,
          farms_count: announcement.farms_count,
          recipients_count: announcement.recipients_count,
          channels: announcement.channels,
          stats: announcement.stats
        },
        ip: req.ip
      });
      return ApiResponse.created(res, announcement, 'Объявление отправлено');
    } catch (error) {
      if (error.message === 'FARM_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Ферма не найдена');
      }
      if (error.message === 'NO_RECIPIENTS') {
        return ApiResponse.badRequest(res, 'Получателей не нашлось — проверьте, кому адресовано объявление', 'NO_RECIPIENTS');
      }
      next(error);
    }
  }

  /** GET /platform-admin/announcements */
  async listAnnouncements(req, res, next) {
    try {
      const result = await announcementService.list({
        page: req.query.page,
        limit: req.query.limit
      });
      return ApiResponse.paginated(
        res,
        result.items,
        result.pagination.page,
        result.pagination.limit,
        result.pagination.total,
        'Список объявлений получен'
      );
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new PlatformAdminController();
