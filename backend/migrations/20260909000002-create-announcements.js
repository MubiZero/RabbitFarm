'use strict';

/**
 * Объявления платформенного админа — рассылка всем фермам, одной ферме или
 * по фильтру (см. docs/plans/PLATFORM-ADMIN.md, 3.1). Запись неизменяема —
 * фиксирует то, что было отправлено и с каким результатом, не редактируется.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('announcements', {
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
      title: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      body: {
        type: Sequelize.TEXT,
        allowNull: false
      },
      channels: {
        type: Sequelize.JSON,
        allowNull: false
      },
      target_type: {
        type: Sequelize.ENUM('all', 'farm', 'filter'),
        allowNull: false
      },
      target_farm_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'farms', key: 'id' },
        onDelete: 'SET NULL'
      },
      target_filter: {
        type: Sequelize.STRING(50),
        allowNull: true
      },
      farms_count: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      },
      recipients_count: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      },
      // { push: { sent, failed }, email: { sent, failed } } — по каналам,
      // отправленным реально (канал, не выбранный в channels, сюда не попадает).
      stats: {
        type: Sequelize.JSON,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('announcements', ['admin_id'], { name: 'idx_announcements_admin' });
    await queryInterface.addIndex('announcements', ['target_farm_id'], { name: 'idx_announcements_farm' });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('announcements');
  }
};
