'use strict';

/**
 * Единственная настройка уведомлений на сейчас: получать ли ежедневный
 * дайджест (`jobs/notificationDigestJob.js`) — просроченные вакцинации,
 * низкий остаток корма, задачи без исполнителя.
 *
 * По умолчанию `true`: раньше выбора не было вовсе, и молчание не должно
 * стать дефолтом просто потому, что появилась колонка.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('users', 'digest_enabled', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: true
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('users', 'digest_enabled');
  }
};
