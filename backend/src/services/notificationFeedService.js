const { Op } = require('sequelize');
const { Notification } = require('../models');
const { notificationText } = require('../i18n/notifications');
const logger = require('../utils/logger');

/**
 * Лента уведомлений одного человека.
 *
 * Отдельный сервис от `notificationService`: тот отвечает за доставку (FCM),
 * этот — за чтение. Смешивать их значило бы тащить в экран ленты всю возню
 * с токенами устройств.
 */
class NotificationFeedService {
  /**
   * Собрать фразу на языке читателя.
   *
   * Ключ мог исчезнуть из словаря вместе с фичей, которая его слала, — тогда
   * строка в ленте не должна ронять весь список. Показываем, что было, и
   * пишем в лог.
   */
  _text(row, language) {
    if (!row.message_key) {
      return { title: row.title || '', body: row.body || '' };
    }

    try {
      return notificationText(row.message_key, language, row.params || {});
    } catch (error) {
      logger.warn('Unknown notification key in feed', {
        key: row.message_key,
        error: error.message
      });
      return { title: row.title || row.message_key, body: row.body || '' };
    }
  }

  async list(farmId, userId, language, { page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;

    const { count, rows } = await Notification.findAndCountAll({
      where: { farm_id: farmId, user_id: userId },
      // Второй ключ сортировки не для красоты: дайджест кладёт несколько
      // сообщений одной секундой, и без него страницы разъезжались бы между
      // запросами, показывая одно сообщение дважды, а другое ни разу.
      order: [['created_at', 'DESC'], ['id', 'DESC']],
      limit: safeLimit,
      offset: (safePage - 1) * safeLimit
    });

    const items = rows.map((row) => {
      const { title, body } = this._text(row, language);
      return {
        id: row.id,
        title,
        body,
        type: row.type,
        route: row.route,
        read_at: row.read_at,
        created_at: row.created_at
      };
    });

    return {
      items,
      pagination: {
        page: safePage,
        limit: safeLimit,
        total: count,
        totalPages: Math.ceil(count / safeLimit)
      }
    };
  }

  async unreadCount(farmId, userId) {
    return Notification.count({
      where: { farm_id: farmId, user_id: userId, read_at: null }
    });
  }

  /**
   * Отметить прочитанным. Без `id` — всю ленту разом: человек открыл экран,
   * значит увидел всё, что на нём было.
   */
  async markRead(farmId, userId, id = null) {
    const where = { farm_id: farmId, user_id: userId, read_at: null };
    if (id) where.id = id;

    const [updated] = await Notification.update({ read_at: new Date() }, { where });
    return updated;
  }

  /**
   * Чистка старого.
   *
   * Лента — не архив: смысл её в том, чтобы не пропустить дело на этой
   * неделе. Без ограничения таблица растёт вечно, а вниз по ней всё равно
   * никто не листает.
   */
  async purgeOlderThan(days = 90) {
    const edge = new Date(Date.now() - days * 24 * 60 * 60 * 1000);
    return Notification.destroy({
      where: { created_at: { [Op.lt]: edge } },
      tenantScope: 'all'
    });
  }
}

module.exports = new NotificationFeedService();
