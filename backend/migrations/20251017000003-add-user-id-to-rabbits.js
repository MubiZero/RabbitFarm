'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('rabbits', 'user_id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 1, // Default to first user for existing records
      references: {
        model: 'users',
        key: 'id'
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE'
    });

    await queryInterface.addIndex('rabbits', ['user_id']);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeIndex('rabbits', ['user_id']);
    await queryInterface.removeColumn('rabbits', 'user_id');
  }
};
