'use strict';

/**
 * Коды входа по телефону. Отдельная таблица от `password_reset_tokens`:
 * там ключ — уже существующий `User`, здесь — телефон, за которым на
 * момент запроса кода может стоять ещё не созданный пользователь (только
 * активное приглашение). `token_hash` намеренно без `unique` — 6-значный
 * код не гарантирует уникальность хеша по всей таблице, ищем по `phone`.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('login_otps', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      phone: {
        type: Sequelize.STRING(20),
        allowNull: false
      },
      token_hash: {
        type: Sequelize.STRING(64),
        allowNull: false
      },
      attempts: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0
      },
      expires_at: {
        type: Sequelize.DATE,
        allowNull: false
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('login_otps', ['phone'], { name: 'idx_login_otps_phone' });
    await queryInterface.addIndex('login_otps', ['expires_at'], { name: 'idx_login_otps_expires_at' });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('login_otps');
  }
};
