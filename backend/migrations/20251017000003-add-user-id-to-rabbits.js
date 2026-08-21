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

  down: async (queryInterface) => {
    // MySQL не даёт снять индекс, пока на колонке висит внешний ключ,
    // поэтому сначала убираем ограничение, а колонка унесёт индекс за собой.
    const [foreignKeys] = await queryInterface.sequelize.query(
      "SELECT CONSTRAINT_NAME AS name FROM information_schema.KEY_COLUMN_USAGE " +
      "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'rabbits' " +
      "AND COLUMN_NAME = 'user_id' AND REFERENCED_TABLE_NAME IS NOT NULL"
    );

    for (const foreignKey of foreignKeys) {
      await queryInterface.removeConstraint('rabbits', foreignKey.name);
    }

    await queryInterface.removeColumn('rabbits', 'user_id');
  }
};
