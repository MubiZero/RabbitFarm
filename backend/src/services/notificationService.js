const { DeviceToken, User, Notification } = require('../models');
const { Op } = require('sequelize');
const firebaseConfig = require('../config/firebase');
const { notificationText, DEFAULT_LANGUAGE } = require('../i18n/notifications');
const logger = require('../utils/logger');

const UNREGISTERED_ERROR_CODES = [
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token'
];

/**
 * Push-уведомления (FCM).
 *
 * Молчит, если Firebase не настроен (см. config/firebase.js) — это
 * осознанное решение: сервис не должен падать или отказываться стартовать
 * только потому, что никто ещё не завёл Firebase-проект.
 */
class NotificationService {
  constructor() {
    this._app = null;
  }

  _messaging() {
    if (!firebaseConfig.isConfigured) return null;

    if (!this._app) {
      // Требуется только когда Firebase реально настроен — на стенде без
      // переменных окружения пакет может отсутствовать, и это не должно
      // мешать остальному приложению работать.
      const admin = require('firebase-admin');
      this._app = admin.apps.length
        ? admin.app()
        : admin.initializeApp({
          credential: admin.credential.cert({
            projectId: firebaseConfig.projectId,
            clientEmail: firebaseConfig.clientEmail,
            privateKey: firebaseConfig.privateKey
          })
        });
    }

    return require('firebase-admin').messaging(this._app);
  }

  /**
   * Положить сообщение в ленту — по строке на получателя.
   *
   * Текст не сохраняется, если есть ключ словаря: фраза собирается на языке
   * читателя в момент чтения, иначе смена языка в настройках оставила бы
   * старую ленту на прежнем. Готовый текст хранится только у объявлений
   * платформы — их админ пишет руками, ключа для них нет.
   *
   * Сбой записи не отменяет пуш: доставить сообщение важнее, чем сохранить
   * его копию.
   */
  async _store(farmId, userIds, { title, body, i18n, data }) {
    try {
      await Notification.bulkCreate(userIds.map((userId) => ({
        farm_id: farmId,
        user_id: userId,
        message_key: i18n?.key || null,
        params: i18n?.params || null,
        title: i18n ? null : (title || null),
        body: i18n ? null : (body || null),
        type: data?.type ? String(data.type) : null,
        route: data?.route ? String(data.route) : null
      })));
    } catch (error) {
      logger.error('Failed to store notifications', { farmId, error: error.message });
    }
  }

  /**
   * Отправить пуш конкретным пользователям фермы.
   *
   * Возвращает `{ sent, failed }` на уровне device-токенов (не пользователей —
   * у одного человека их может быть несколько) — нужно объявлениям
   * платформенного админа для «доставлено N из M», обычные вызовы (дайджест)
   * результат просто игнорируют.
   */
  async sendToUsers(farmId, userIds, { title, body, i18n, data = {} }) {
    const ids = [...new Set(userIds)].filter(Boolean);
    if (ids.length === 0) return { sent: 0, failed: 0 };

    // Лента пишется до попытки отправки и независимо от неё. Пуш — канал
    // ненадёжный по устройству: человек мог отказать в разрешении, удалить
    // приложение, потерять токен. Раньше это значило, что он не узнает о
    // просроченных прививках и скором окроле вовсе — сообщения не оставалось
    // нигде. Теперь оно ждёт его в приложении.
    await this._store(farmId, ids, { title, body, i18n, data });

    const messaging = this._messaging();
    if (!messaging) {
      logger.warn('Push skipped: Firebase not configured', { farmId, key: i18n?.key, title });
      return { sent: 0, failed: 0 };
    }

    const deviceTokens = await DeviceToken.findAll({
      where: { farm_id: farmId, user_id: { [Op.in]: ids } }
    });
    if (deviceTokens.length === 0) return { sent: 0, failed: 0 };

    const stringData = Object.fromEntries(
      Object.entries(data).map(([key, value]) => [key, String(value)])
    );

    // Один запрос на язык, а не на всех сразу: FCM шлёт один текст всей
    // пачке токенов, а людям на одной ферме он нужен разный.
    const groups = i18n
      ? await this._groupTokensByLanguage(deviceTokens, i18n)
      : [{ tokens: deviceTokens, title, body }];

    let sent = 0;
    let failed = 0;
    const staleTokens = [];

    for (const group of groups) {
      const response = await messaging.sendEachForMulticast({
        tokens: group.tokens.map(t => t.token),
        notification: { title: group.title, body: group.body },
        data: stringData
      });

      response.responses.forEach((r, i) => {
        if (r.success) {
          sent += 1;
          return;
        }
        failed += 1;
        if (UNREGISTERED_ERROR_CODES.includes(r.error?.code)) {
          staleTokens.push(group.tokens[i].token);
        }
      });
    }

    if (staleTokens.length > 0) {
      await DeviceToken.destroy({ where: { farm_id: farmId, token: { [Op.in]: staleTokens } } });
      logger.info('Removed stale device tokens', { farmId, count: staleTokens.length });
    }

    return { sent, failed };
  }

  /**
   * Разложить токены по языку их владельцев и подготовить текст каждому.
   *
   * Язык спрашивается одним запросом на всех: у фермы с десятком работников
   * это всё равно одна строка на человека, а не запрос на каждый токен.
   */
  async _groupTokensByLanguage(deviceTokens, { key, params }) {
    const userIds = [...new Set(deviceTokens.map(t => t.user_id))];
    const users = await User.findAll({
      where: { id: { [Op.in]: userIds } },
      attributes: ['id', 'language']
    });
    const languageByUser = new Map(users.map(u => [u.id, u.language]));

    const byLanguage = new Map();
    for (const token of deviceTokens) {
      const language = languageByUser.get(token.user_id) || DEFAULT_LANGUAGE;
      if (!byLanguage.has(language)) byLanguage.set(language, []);
      byLanguage.get(language).push(token);
    }

    return [...byLanguage.entries()].map(([language, tokens]) => ({
      tokens,
      ...notificationText(key, language, params)
    }));
  }

  /** Отправить пуш всем участникам фермы с одной из указанных ролей. */
  async sendToRoles(farmId, roles, payload) {
    const members = await User.findAll({
      where: { farm_id: farmId, role: { [Op.in]: roles }, is_active: true }
    });
    await this.sendToUsers(farmId, members.map(m => m.id), payload);
  }
}

module.exports = new NotificationService();
