'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Используем raw SQL для изменения колонки
    await queryInterface.sequelize.query(
      'ALTER TABLE `births` MODIFY COLUMN `breeding_id` INTEGER NULL;'
    );
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.sequelize.query(
      'ALTER TABLE `births` MODIFY COLUMN `breeding_id` INTEGER NOT NULL;'
    );
  }
};
