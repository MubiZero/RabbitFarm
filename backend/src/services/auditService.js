const { AdminAuditLog } = require('../models');
const logger = require('../utils/logger');

/**
 * Журнал действий платформенного админа: кто, когда, что за действие, над
 * какой фермой, что было и что стало. Пишется из `platformAdminController`
 * после каждого успешного мутирующего действия.
 *
 * Запись в журнал не должна ронять само админ-действие — сбой здесь
 * логируется, а не пробрасывается (тот же принцип, что в
 * `utils/fileStorage.js:deleteFile`).
 */
class AuditService {
  async record({ adminId, action, farmId = null, before = null, after = null, ip = null }) {
    try {
      await AdminAuditLog.create({
        admin_id: adminId,
        action,
        farm_id: farmId,
        before,
        after,
        ip
      });
    } catch (error) {
      logger.error('Failed to write admin audit log', {
        error: error.message,
        adminId,
        action,
        farmId
      });
    }
  }

  /** Записи журнала постранично, свежие сверху; опционально по одной ферме. */
  async list({ page = 1, limit = 20, farmId = null } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;
    const offset = (safePage - 1) * safeLimit;

    const where = {};
    if (farmId) {
      where.farm_id = farmId;
    }

    const { count, rows } = await AdminAuditLog.findAndCountAll({
      where,
      order: [['created_at', 'DESC']],
      limit: safeLimit,
      offset
    });

    return {
      items: rows,
      pagination: {
        page: safePage,
        limit: safeLimit,
        total: count,
        totalPages: Math.ceil(count / safeLimit)
      }
    };
  }
}

module.exports = new AuditService();
