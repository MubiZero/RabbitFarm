'use strict';

/**
 * Платежи через Эсхата Мерчант. Заявка появляется здесь только если банк
 * принял её при создании — см. src/models/Payment.js.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('payments', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'farms', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      invoice_id: {
        type: Sequelize.STRING(64),
        allowNull: false,
        unique: true
      },
      order_id: {
        type: Sequelize.STRING(64),
        allowNull: true
      },
      pos_id: {
        type: Sequelize.INTEGER,
        allowNull: true
      },
      amount: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false
      },
      currency: {
        type: Sequelize.STRING(3),
        allowNull: false,
        defaultValue: '972'
      },
      description: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      status: {
        type: Sequelize.ENUM('new', 'completed', 'failed'),
        allowNull: false,
        defaultValue: 'new'
      },
      raw_response: {
        type: Sequelize.JSON,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('payments', ['farm_id'], { name: 'idx_payments_farm' });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('payments');
  }
};
