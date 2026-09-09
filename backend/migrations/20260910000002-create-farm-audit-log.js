'use strict';

/**
 * Журнал кадровых действий фермы. Запись неизменяема — только created_at,
 * без updated_at.
 *
 * Ссылки на людей обнуляемые (ON DELETE SET NULL): удаление работника не
 * должно уносить историю действий над ним. Ссылка на ферму — наоборот,
 * каскадом: журнал живёт ровно столько же, сколько само хозяйство.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('farm_audit_log', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'farms', key: 'id' },
        onDelete: 'CASCADE'
      },
      actor_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'users', key: 'id' },
        onDelete: 'SET NULL'
      },
      target_user_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'users', key: 'id' },
        onDelete: 'SET NULL'
      },
      action: {
        type: Sequelize.STRING(100),
        allowNull: false
      },
      before: {
        type: Sequelize.JSON,
        allowNull: true
      },
      after: {
        type: Sequelize.JSON,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    // Читают журнал всегда одной фермой и всегда свежим сверху — индекс
    // повторяет этот запрос целиком, чтобы выборка не упиралась в сортировку.
    await queryInterface.addIndex('farm_audit_log', ['farm_id', 'created_at'], {
      name: 'idx_farm_audit_log_farm_created'
    });
    await queryInterface.addIndex('farm_audit_log', ['target_user_id'], {
      name: 'idx_farm_audit_log_target'
    });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('farm_audit_log');
  }
};
