'use strict';

/**
 * Ферма без плана — без ограничений (см. src/services/planService.js).
 * SET NULL, а не RESTRICT: удаление плана не должно ломать фермы, которые
 * на нём сидят — они просто становятся безлимитными, а не блокируют операцию.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('farms', 'plan_id', {
      type: Sequelize.INTEGER,
      allowNull: true,
      references: { model: 'plans', key: 'id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL'
    });

    await queryInterface.addIndex('farms', ['plan_id'], { name: 'idx_farms_plan' });
  },

  down: async (queryInterface) => {
    await queryInterface.removeIndex('farms', 'idx_farms_plan');
    await queryInterface.removeColumn('farms', 'plan_id');
  }
};
