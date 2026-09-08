const { Announcement, Farm, User } = require('../models');
const notificationService = require('./notificationService');
const { sendAnnouncementEmail } = require('./notifications/emailTransport');
const platformAdminService = require('./platformAdminService');
const logger = require('../utils/logger');

/**
 * Объявления платформенного админа (см. docs/plans/PLATFORM-ADMIN.md, 3.1).
 *
 * Канал SMS сюда сознательно не входит: шлюз Payom принимает только заранее
 * одобренные шаблоны (см. `notifications/payomSmsTransport.js`), а
 * объявление — произвольный текст. Понадобится SMS-рассылка — заводить
 * отдельный шаблон в кабинете Payom и отдельный путь отправки, не сюда.
 */
const SUPPORTED_CHANNELS = ['push', 'email'];

class AnnouncementService {
  /** Farm id'ы получателей — по одному, всем или по тому же фильтру, что и список ферм. */
  async _resolveFarmIds(targetType, targetFarmId, targetFilter) {
    if (targetType === 'farm') {
      const farm = await Farm.findByPk(targetFarmId);
      if (!farm) {
        throw new Error('FARM_NOT_FOUND');
      }
      return [farm.id];
    }

    if (targetType === 'filter') {
      // Тот же фильтр, что в списке ферм (`no_plan`/`at_limit`/`suspended`/…) —
      // не переизобретаем его здесь, иначе «упёрлась в предел» в объявлениях
      // и в списке ферм могут разойтись.
      const result = await platformAdminService.listFarms({ filter: targetFilter, limit: Number.MAX_SAFE_INTEGER });
      return result.items.map((farm) => farm.id);
    }

    // 'all' — все незаудалённые фермы, тот же критерий, что у notificationDigestJob.
    const farms = await Farm.findAll({ attributes: ['id'], where: { deleted_at: null } });
    return farms.map((farm) => farm.id);
  }

  /**
   * Отправить объявление и сохранить результат. Синхронно — на масштабе
   * платформы (десятки ферм) это доли секунды, очередь не нужна.
   */
  async create({ adminId, title, body, channels, targetType, targetFarmId, targetFilter }) {
    const usedChannels = channels.filter((channel) => SUPPORTED_CHANNELS.includes(channel));
    const farmIds = await this._resolveFarmIds(targetType, targetFarmId, targetFilter);

    const users = farmIds.length
      ? await User.findAll({
        where: { farm_id: farmIds, is_active: true },
        attributes: ['id', 'farm_id', 'email']
      })
      : [];

    // Объявление без единого получателя — не рассылка, а действие впустую:
    // «отправлено» с нулём адресатов вводило бы в заблуждение историю
    // объявлений. Проверяем до отправки, а не постфактум по stats.
    if (users.length === 0) {
      throw new Error('NO_RECIPIENTS');
    }

    const stats = { push: { sent: 0, failed: 0 }, email: { sent: 0, failed: 0 } };

    if (usedChannels.includes('push')) {
      const userIdsByFarm = users.reduce((acc, user) => {
        (acc[user.farm_id] ??= []).push(user.id);
        return acc;
      }, {});

      for (const [farmId, userIds] of Object.entries(userIdsByFarm)) {
        try {
          const result = await notificationService.sendToUsers(Number(farmId), userIds, {
            title,
            body,
            data: { type: 'announcement' }
          });
          stats.push.sent += result.sent;
          stats.push.failed += result.failed;
        } catch (error) {
          logger.error('Announcement push failed for farm', { farmId, error: error.message });
        }
      }
    }

    if (usedChannels.includes('email')) {
      for (const user of users) {
        try {
          await sendAnnouncementEmail({ to: user.email, subject: title, text: body });
          stats.email.sent += 1;
        } catch (error) {
          stats.email.failed += 1;
          logger.error('Announcement email failed', { userId: user.id, error: error.message });
        }
      }
    }

    return Announcement.create({
      admin_id: adminId,
      title,
      body,
      channels: usedChannels,
      target_type: targetType,
      target_farm_id: targetType === 'farm' ? targetFarmId : null,
      target_filter: targetType === 'filter' ? targetFilter : null,
      farms_count: farmIds.length,
      recipients_count: users.length,
      stats
    });
  }

  /** История объявлений, постранично, свежие сверху. */
  async list({ page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;
    const offset = (safePage - 1) * safeLimit;

    const { count, rows } = await Announcement.findAndCountAll({
      // Только имя — история объявлений не карточка фермы, ей незачем тащить
      // остальные поля ради подписи «Ферма N».
      include: [{ model: Farm, as: 'targetFarm', attributes: ['id', 'name'] }],
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

module.exports = new AnnouncementService();
