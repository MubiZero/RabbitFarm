'use strict';

/**
 * Имя приглашённого. При активации приглашения по телефону через OTP-вход
 * отдельной формы для имени больше нет (в отличие от `/join`, где человек
 * вводил его сам) — владелец обычно и так знает, кого зовёт, вводит имя
 * сразу при создании приглашения.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('invitations', 'full_name', {
      type: Sequelize.STRING(255),
      allowNull: true,
      after: 'phone'
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('invitations', 'full_name');
  }
};
