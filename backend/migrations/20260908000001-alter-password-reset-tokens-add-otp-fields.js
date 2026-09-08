'use strict';

/**
 * Токен сброса пароля становится коротким 6-значным кодом (SMS/email)
 * вместо неиспользуемого 32-байтного токена — см. src/services/authService.js.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('password_reset_tokens', 'channel', {
      type: Sequelize.ENUM('sms', 'email'),
      allowNull: false,
      defaultValue: 'email'
    });
    await queryInterface.addColumn('password_reset_tokens', 'attempts', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('password_reset_tokens', 'attempts');
    await queryInterface.removeColumn('password_reset_tokens', 'channel');
  }
};
