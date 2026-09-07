'use strict';

/**
 * Токены устройств для push-уведомлений (FCM).
 *
 * Один токен — одно физическое устройство. `farm_id` продублирован рядом с
 * `user_id`, а не выводится через связь: страховка многоарендности
 * (tenancy.js) требует его в каждом запросе к этой таблице напрямую.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('device_tokens', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'farms', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'users', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      token: {
        type: Sequelize.STRING(255),
        allowNull: false,
        unique: true
      },
      platform: {
        type: Sequelize.ENUM('android', 'ios'),
        allowNull: false
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('device_tokens', ['farm_id'], { name: 'idx_device_tokens_farm' });
    await queryInterface.addIndex('device_tokens', ['user_id'], { name: 'idx_device_tokens_user' });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('device_tokens');
  }
};
