const { FarmAuditLog, User } = require('../models');
const logger = require('../utils/logger');

/**
 * Журнал кадровых действий фермы: кто, когда, над кем и что сделал.
 * Пишется из `staffService` после каждого успешного изменения состава.
 *
 * Действия: `staff.role_changed`, `staff.deactivated`, `staff.activated`,
 * `staff.ownership_transferred`.
 *
 * Запись в журнал не должна ронять само действие: сбой здесь логируется, а
 * не пробрасывается — тот же принцип, что в `services/auditService`.
 */

// Кто и над кем — именами, а не идентификаторами: журнал читает человек, и
// «Пётр понизил Ивана» ему говорит больше, чем «12 → 34».
const PEOPLE_INCLUDE = [
  { model: User, as: 'actor', attributes: ['id', 'full_name', 'email', 'role'] },
  { model: User, as: 'target', attributes: ['id', 'full_name', 'email', 'role'] }
];

class FarmAuditService {
  async record({ farmId, actorId = null, action, targetUserId = null, before = null, after = null }) {
    try {
      await FarmAuditLog.create({
        farm_id: farmId,
        actor_id: actorId,
        target_user_id: targetUserId,
        action,
        before,
        after
      });
    } catch (error) {
      logger.error('Failed to write farm audit log', {
        error: error.message,
        farmId,
        actorId,
        action
      });
    }
  }

  /** Записи журнала одной фермы постранично, свежие сверху. */
  async list(farmId, { page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;
    const offset = (safePage - 1) * safeLimit;

    // Второй ключ сортировки не для красоты: одно обращение к PATCH /staff/:id
    // пишет и смену роли, и отключение доступа — created_at у них совпадает
    // с точностью до секунды, и без id страницы разъезжались бы между
    // запросами, показывая одну запись дважды, а другую ни разу.
    const { count, rows } = await FarmAuditLog.findAndCountAll({
      where: { farm_id: farmId },
      include: PEOPLE_INCLUDE,
      order: [['created_at', 'DESC'], ['id', 'DESC']],
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

module.exports = new FarmAuditService();
