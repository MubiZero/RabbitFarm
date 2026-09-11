'use strict';

/**
 * Пароля в сервисе больше нет: вход — код из SMS или письма, а на самом
 * устройстве приложение закрывается коротким ПИНом, который хранится там же
 * и до сервера не доходит (см. docs/HANDOFF.md).
 *
 * Поэтому уезжают и хеш пароля, и вся таблица кодов сброса: сбрасывать
 * больше нечего, забытый ПИН лечится обычным входом по коду.
 */
module.exports = {
  up: async (queryInterface) => {
    await queryInterface.removeColumn('users', 'password_hash');
    await queryInterface.dropTable('password_reset_tokens');
  },

  down: async (queryInterface, Sequelize) => {
    // Возвращается структура, но не сами хеши: их не существует с момента
    // применения `up`, и восстановить пароль пользователя неоткуда — после
    // отката все входят по коду и задают пароль заново.
    await queryInterface.addColumn('users', 'password_hash', {
      type: Sequelize.STRING(255),
      allowNull: true
    });
    await queryInterface.createTable('password_reset_tokens', {
      id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'users', key: 'id' },
        onDelete: 'CASCADE'
      },
      token_hash: { type: Sequelize.STRING(64), allowNull: false },
      channel: { type: Sequelize.ENUM('sms', 'email'), allowNull: false },
      attempts: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
      expires_at: { type: Sequelize.DATE, allowNull: false },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });
  }
};
