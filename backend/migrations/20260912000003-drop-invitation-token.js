'use strict';

/**
 * У приглашения больше нет собственного кода.
 *
 * Приглашённый входит обычным кодом на свой телефон или почту
 * (`/auth/otp/*`), и первый же такой вход заводит ему учётку в ферме,
 * которая его позвала. Длинный токен, который раньше показывался владельцу
 * и уходил SMS-кой, вводить стало некуда — он только путал: человек получал
 * сообщение с кодом, не подходящим ни к одному экрану.
 */
module.exports = {
  up: async (queryInterface) => {
    await queryInterface.removeColumn('invitations', 'token_hash');
  },

  down: async (queryInterface, Sequelize) => {
    // Возвращается колонка, но не сами хеши: коды приглашений не
    // существуют с момента применения `up`. Действующие приглашения после
    // отката придётся выписать заново.
    await queryInterface.addColumn('invitations', 'token_hash', {
      type: Sequelize.STRING(255),
      allowNull: false,
      defaultValue: ''
    });
  }
};
