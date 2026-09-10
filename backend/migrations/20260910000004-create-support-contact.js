'use strict';

/**
 * Официальный контакт поддержки (email/телефон), который платформенный
 * админ задаёт один раз и который показывается фермам рядом с внутренней
 * фичей «Обращения» — там, где сейчас голый текст «обратитесь в поддержку»
 * без единого настоящего канала.
 *
 * Синглтон: ровно одна строка с фиксированным id=1, как проще всего
 * моделировать «один активный контакт на всю платформу» без отдельной
 * таблицы key-value ради двух полей.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('support_contact', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true
      },
      email: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      phone: {
        type: Sequelize.STRING(32),
        allowNull: true
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('support_contact');
  }
};
