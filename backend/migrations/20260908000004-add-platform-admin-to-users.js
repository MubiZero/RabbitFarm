'use strict';

/**
 * Платформенный суперадмин — не роль фермы (owner/manager/worker), а
 * отдельный флаг: видит и администрирует все фермы сразу, а не работает
 * внутри одной. Ставится вручную в БД — самостоятельной регистрации нет.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('users', 'is_platform_admin', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('users', 'is_platform_admin');
  }
};
