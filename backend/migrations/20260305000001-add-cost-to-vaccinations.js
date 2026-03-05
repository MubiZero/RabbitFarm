'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('vaccinations', 'cost', {
      type: Sequelize.DECIMAL(10, 2),
      allowNull: true,
      after: 'veterinarian'
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('vaccinations', 'cost');
  }
};
