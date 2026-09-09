const { SupportRequest, Farm, User } = require('../models');
const logger = require('../utils/logger');

/**
 * Обращения ферм в поддержку.
 *
 * Ферма только заводит обращение — ни списка своих обращений, ни переписки
 * пока нет: отвечает поддержка тем же способом, каким связывалась бы и
 * раньше (по телефону или почте из карточки фермы). Здесь решается ровно
 * одна задача — чтобы «обратитесь в поддержку» перестало быть тупиком.
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
   * Пометить обращение разобранным. Повторный вызов ничего не ломает и
   * возвращает то же обращение: «уже закрыто» — не ошибка админа, а гонка
   * двух открытых панелей.
   */
  async resolve(id) {
    const request = await SupportRequest.findByPk(id);
    if (!request) {
      throw new Error('SUPPORT_REQUEST_NOT_FOUND');
    }

    if (request.status !== 'resolved') {
      await request.update({ status: 'resolved' });
      logger.info('Support request resolved', { supportRequestId: request.id });
    }

    return SupportRequest.findByPk(request.id, { include: SUPPORT_REQUEST_INCLUDE });
  }
}

module.exports = new SupportRequestService();
