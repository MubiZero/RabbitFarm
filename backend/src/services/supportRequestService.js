const { SupportRequest, Farm, User } = require('../models');
const notificationService = require('./notificationService');
const { sendAnnouncementEmail } = require('./notifications/emailTransport');
const { notificationText } = require('../i18n/notifications');
const logger = require('../utils/logger');

/**
 * Обращения ферм в поддержку.
 *
 * Разговор замкнут в обе стороны: ферма пишет и видит свои обращения со
 * статусом, админ отвечает текстом, а автор узнаёт об ответе пушем и
 * письмом. Переписки в несколько кругов пока нет — одно обращение, один
 * ответ; на практике этого хватает, а нить сообщений потребовала бы
 * отдельной сущности и экрана.
 */

// Только подпись «кто и откуда написал»: карточку фермы админ откроет
// отдельно, тащить сюда её тариф и потребление незачем.
const SUPPORT_REQUEST_INCLUDE = [
  { model: Farm, as: 'farm', attributes: ['id', 'name'] },
  { model: User, as: 'author', attributes: ['id', 'full_name', 'email', 'phone', 'role'] }
];

class SupportRequestService {
  /** Новое обращение от конкретного человека конкретной фермы. */
  async create({ farmId, userId, text }) {
    const created = await SupportRequest.create({
      farm_id: farmId,
      user_id: userId,
      text
    });

    logger.info('Support request created', { supportRequestId: created.id, farmId, userId });

    return SupportRequest.findByPk(created.id, { include: SUPPORT_REQUEST_INCLUDE });
  }

  /**
   * Все обращения платформы постранично: сначала необработанные, внутри —
   * свежие сверху.
   *
   * Порядок именно такой, потому что панель открывают ради вопроса «на что
   * ещё не ответили»: с одной лишь сортировкой по дате новое обращение
   * тонуло бы среди закрытых, как только их накопится страница.
   * `status` — ENUM('new','resolved'), и MySQL сортирует его по порядку
   * объявления, то есть `new` идёт первым.
   */
  async list({ page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;
    const offset = (safePage - 1) * safeLimit;

    const { count, rows } = await SupportRequest.findAndCountAll({
      include: SUPPORT_REQUEST_INCLUDE,
      order: [['status', 'ASC'], ['created_at', 'DESC']],
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

  /**
   * Пометить обращение разобранным — и, если админ написал ответ, передать
   * его автору. Повторный вызов ничего не ломает и возвращает то же
   * обращение: «уже закрыто» — не ошибка админа, а гонка двух открытых
   * панелей. Повторное уведомление при этом не уходит.
   */
  /** Обращения одной фермы — то, что видит сама ферма. */
  async listForFarm(farmId, { page = 1, limit = 20 } = {}) {
    const safePage = parseInt(page) || 1;
    const safeLimit = parseInt(limit) || 20;

    const { count, rows } = await SupportRequest.findAndCountAll({
      where: { farm_id: farmId },
      include: SUPPORT_REQUEST_INCLUDE,
      order: [['created_at', 'DESC'], ['id', 'DESC']],
      limit: safeLimit,
      offset: (safePage - 1) * safeLimit
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

  /**
   * Сказать автору, что ему ответили.
   *
   * Два канала, как и у остальных важных сообщений: человек, написавший в
   * поддержку, вполне мог с тех пор не открывать приложение. Сбой любого из
   * каналов не отменяет самой отметки «разобрано» — ответ уже записан и
   * виден в списке обращений.
   */
  async _notifyAuthor(request, answer) {
    try {
      const author = await User.findByPk(request.user_id, {
        attributes: ['id', 'email', 'language']
      });
      if (!author) return;

      const params = { answer };
      await notificationService.sendToUsers(request.farm_id, [author.id], {
        i18n: { key: 'supportAnswered', params },
        data: { type: 'support_answered', route: '/support' }
      });

      if (author.email) {
        const { title, body } = notificationText('supportAnswered', author.language, params);
        await sendAnnouncementEmail({ to: author.email, subject: title, text: body });
      }
    } catch (error) {
      logger.error('Support answer notification failed', {
        supportRequestId: request.id,
        error: error.message
      });
    }
  }

  async resolve(id, { answer = null, actorId = null } = {}) {
    const request = await SupportRequest.findByPk(id);
    if (!request) {
      throw new Error('SUPPORT_REQUEST_NOT_FOUND');
    }

    if (request.status !== 'resolved') {
      await request.update({
        status: 'resolved',
        answer,
        resolved_by: actorId,
        resolved_at: new Date()
      });
      logger.info('Support request resolved', { supportRequestId: request.id });

      // Ответ без адресата — это снова отметка для одного админа.
      if (answer) await this._notifyAuthor(request, answer);
    }

    return SupportRequest.findByPk(request.id, { include: SUPPORT_REQUEST_INCLUDE });
  }
}

module.exports = new SupportRequestService();
