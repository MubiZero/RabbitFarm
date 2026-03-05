'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('rabbits', 'deleted_at', {
      type: Sequelize.DATE,
      allowNull: true
    });
    await queryInterface.addColumn('cages', 'deleted_at', {
      type: Sequelize.DATE,
      allowNull: true
    });
    await queryInterface.addColumn('feeds', 'deleted_at', {
      type: Sequelize.DATE,
      allowNull: true
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('feeds', 'deleted_at');
    await queryInterface.removeColumn('cages', 'deleted_at');
    await queryInterface.removeColumn('rabbits', 'deleted_at');
  }
};
