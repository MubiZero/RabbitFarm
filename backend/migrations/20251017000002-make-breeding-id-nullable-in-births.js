'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.changeColumn('births', 'breeding_id', {
      type: Sequelize.INTEGER,
      allowNull: true,
      references: {
        model: 'breedings',
        key: 'id'
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE'
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.changeColumn('births', 'breeding_id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: 'breedings',
        key: 'id'
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE'
    });
  }
};
