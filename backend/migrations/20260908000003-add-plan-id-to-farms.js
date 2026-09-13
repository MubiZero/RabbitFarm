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
    // MySQL не отдаёт индекс, пока на колонке висит внешний ключ, а имя ключу
    // сервер выдал сам (`farms_ibfk_N`) — поэтому имя спрашиваем у
    // information_schema, а не угадываем.
    const [foreignKeys] = await queryInterface.sequelize.query(`
      SELECT CONSTRAINT_NAME AS name
      FROM information_schema.KEY_COLUMN_USAGE
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'farms'
        AND COLUMN_NAME = 'plan_id'
        AND REFERENCED_TABLE_NAME IS NOT NULL
    `);

    for (const { name } of foreignKeys) {
      await queryInterface.removeConstraint('farms', name);
    }

    await queryInterface.removeIndex('farms', 'idx_farms_plan');
    await queryInterface.removeColumn('farms', 'plan_id');
  }
};
