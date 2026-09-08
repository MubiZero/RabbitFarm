'use strict';

/**
 * Журнал действий платформенного админа. Запись неизменяема — только
 * created_at, без updated_at: строку журнала не редактируют и не трогают.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('admin_audit_log', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      admin_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'users', key: 'id' }
      },
      action: {
        type: Sequelize.STRING(100),
        allowNull: false
      },
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'farms', key: 'id' },
        onDelete: 'SET NULL'
      },
      before: {
        type: Sequelize.JSON,
        allowNull: true
      },
      after: {
        type: Sequelize.JSON,
        allowNull: true
      },
      ip: {
        type: Sequelize.STRING(64),
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('admin_audit_log', ['farm_id'], { name: 'idx_admin_audit_log_farm' });
    await queryInterface.addIndex('admin_audit_log', ['admin_id'], { name: 'idx_admin_audit_log_admin' });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('admin_audit_log');
  }
};
