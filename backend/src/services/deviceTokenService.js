const { DeviceToken } = require('../models');
const logger = require('../utils/logger');

/**
 * Токены устройств для push-уведомлений.
 *
 * Уникальность по самому токену: одно и то же устройство может сменить
 * владельца (логаут одного работника, логин другого), и upsert по `token`
 * просто переписывает user_id вместо накопления дублей.
 */
class DeviceTokenService {
  async register(farmId, userId, { token, platform }) {
    await DeviceToken.upsert(
      { farm_id: farmId, user_id: userId, token, platform },
      { conflictFields: ['token'] }
    );
    logger.info('Device token registered', { userId, platform });
  }

  async unregister(farmId, token) {
    await DeviceToken.destroy({ where: { farm_id: farmId, token } });
    logger.info('Device token unregistered', { farmId });
  }
}

module.exports = new DeviceTokenService();
