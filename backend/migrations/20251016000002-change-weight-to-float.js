'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Change weight column in rabbit_weights table from DECIMAL to FLOAT
    await queryInterface.changeColumn('rabbit_weights', 'weight', {
      type: Sequelize.FLOAT,
      allowNull: false
    });

    // Change current_weight column in rabbits table from DECIMAL to FLOAT
    await queryInterface.changeColumn('rabbits', 'current_weight', {
      type: Sequelize.FLOAT,
      allowNull: true
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Revert weight column in rabbit_weights table from FLOAT to DECIMAL
    await queryInterface.changeColumn('rabbit_weights', 'weight', {
      type: Sequelize.DECIMAL(5, 2),
      allowNull: false
    });

    // Revert current_weight column in rabbits table from FLOAT to DECIMAL
    await queryInterface.changeColumn('rabbits', 'current_weight', {
      type: Sequelize.DECIMAL(5, 2),
      allowNull: true
    });
  }
};
