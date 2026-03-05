'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('idempotency_keys', {
      key: {
        type: Sequelize.STRING(255),
        primaryKey: true,
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      request_path: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      request_method: {
        type: Sequelize.STRING(10),
        allowNull: false
      },
      response_status: {
        type: Sequelize.INTEGER,
        allowNull: true
      },
      response_body: {
        type: Sequelize.JSON,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false
      }
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('idempotency_keys');
  }
};
