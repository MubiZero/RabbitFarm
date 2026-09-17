const { User, Farm } = require('../models');
const farmAuditService = require('./farmAuditService');
const logger = require('../utils/logger');

/**
 * Удаление собственной учётной записи.
 *
 * Обязательно по правилам обоих магазинов приложений: если в приложении
 * можно завести учётку, из него же её должно быть можно удалить — без писем
 * в поддержку. До сих пор такого пути не было вовсе.
 *
 * Что именно удаляется, зависит от того, чьё это хозяйство:
 *
 * * **Владелец** удаляет хозяйство целиком. Доступ закрывается сразу
 *   (`middleware/auth` видит `farms.deleted_at`), данные ждут физической
 *   зачистки 30 дней (`jobs/farmPurgeJob`) — это окно на «удалил сгоряча».
 *   Вместе с фермой доступ теряют и её работники: ферма одна, и делить её
 *   не на что.
 * * **Работник и управляющий** удаляют только себя. Записи, которые они
 *   завели, остаются хозяйству — это его данные, а не их: ссылки на автора
 *   гаснут в `NULL` (`SET NULL` у всех таблиц фермы).
 */
const PURGE_AFTER_DAYS = 30;

class AccountService {
  /**
   * @param {Object} actor - `req.user`
   * @param {String} confirmName - название фермы, набранное владельцем
   */
  async deleteAccount(actor, { confirmName } = {}) {
    const user = await User.findByPk(actor.id, {
      include: [{ model: Farm, as: 'farm' }]
    });

    if (!user) {
      throw new Error('USER_NOT_FOUND');
    }

    // Платформенный админ ведёт чужие хозяйства, и его действия подписаны в
    // журнале платформы навсегда. Такую учётку из приложения не удаляют.
    if (user.is_platform_admin) {
      throw new Error('PLATFORM_ADMIN_ACCOUNT');
    }

    return user.role === 'owner'
      ? this._deleteFarm(user, confirmName)
      : this._deleteMembership(user);
  }

  async _deleteFarm(user, confirmName) {
    const farm = user.farm;
    if (!farm) {
      throw new Error('FARM_NOT_FOUND');
    }

    // Название набирают руками — именно это отличает намеренное удаление от
    // случайного нажатия. Совпадение проверяет сервер, не доверяя клиенту:
    // так же сделано у платформенного админа (`platformAdminService`).
    if ((confirmName || '').trim() !== farm.name) {
      throw new Error('CONFIRM_NAME_MISMATCH');
    }

    const deletedAt = new Date();
    await farm.update({ deleted_at: deletedAt });

    logger.info('Farm deleted by owner', { farmId: farm.id, userId: user.id });

    return {
      scope: 'farm',
      farm_name: farm.name,
      deleted_at: deletedAt.toISOString(),
      purge_at: new Date(
        deletedAt.getTime() + PURGE_AFTER_DAYS * 24 * 60 * 60 * 1000
      ).toISOString()
    };
  }

  async _deleteMembership(user) {
    const farmId = user.farm_id;

    // Имя записывается в журнал до удаления: ссылки на человека гаснут
    // вместе с ним (`SET NULL`), и без этого владелец увидел бы «кто-то ушёл»
    // — то есть ничего.
    if (farmId) {
      await farmAuditService.record({
        farmId,
        actorId: user.id,
        targetUserId: user.id,
        action: 'staff.self_deleted',
        before: { full_name: user.full_name, role: user.role }
      });
    }

    await user.destroy();

    logger.info('Staff account deleted by owner request', {
      userId: user.id,
      farmId
    });

    return { scope: 'user' };
  }
}

module.exports = new AccountService();
module.exports.PURGE_AFTER_DAYS = PURGE_AFTER_DAYS;
