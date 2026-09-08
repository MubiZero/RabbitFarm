const { DeviceToken, User } = require('../models');
const { Op } = require('sequelize');
const firebaseConfig = require('../config/firebase');
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
   * Отправить пуш конкретным пользователям фермы.
   *
   * Возвращает `{ sent, failed }` на уровне device-токенов (не пользователей —
   * у одного человека их может быть несколько) — нужно объявлениям
   * платформенного админа для «доставлено N из M», обычные вызовы (дайджест)
   * результат просто игнорируют.
   */
  async sendToUsers(farmId, userIds, { title, body, data = {} }) {
    const ids = [...new Set(userIds)].filter(Boolean);
    if (ids.length === 0) return { sent: 0, failed: 0 };

    const messaging = this._messaging();
    if (!messaging) {
      logger.warn('Push skipped: Firebase not configured', { farmId, title });
      return { sent: 0, failed: 0 };
    }

    const deviceTokens = await DeviceToken.findAll({
      where: { farm_id: farmId, user_id: { [Op.in]: ids } }
    });
    if (deviceTokens.length === 0) return { sent: 0, failed: 0 };

    const stringData = Object.fromEntries(
      Object.entries(data).map(([key, value]) => [key, String(value)])
    );

    const response = await messaging.sendEachForMulticast({
      tokens: deviceTokens.map(t => t.token),
      notification: { title, body },
      data: stringData
    });

    const staleTokens = response.responses
      .map((r, i) => (r.success ? null : { resp: r, token: deviceTokens[i].token }))
      .filter(entry => entry && UNREGISTERED_ERROR_CODES.includes(entry.resp.error?.code))
      .map(entry => entry.token);

    if (staleTokens.length > 0) {
      await DeviceToken.destroy({ where: { farm_id: farmId, token: { [Op.in]: staleTokens } } });
      logger.info('Removed stale device tokens', { farmId, count: staleTokens.length });
    }

    const sent = response.responses.filter(r => r.success).length;
    return { sent, failed: response.responses.length - sent };
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
