'use strict';

/**
 * Телефон становится основным способом входа — email и пароль остаются
 * запасным вариантом, а не обязательным. Работник, заведённый через
 * OTP-вход по приглашению, может вообще никогда не завести ни того, ни
 * другого.
 *
 * Уникальный индекс на `phone` — MySQL допускает сколько угодно строк с
 * `NULL` в unique-колонке, так что он не мешает тем, у кого телефона нет.
 * Перед прогоном на боевой базе стоит проверить дубли непустых телефонов
 * (`phone` раньше был свободным текстом без проверки на уникальность):
 *   SELECT phone, COUNT(*) FROM users WHERE phone IS NOT NULL
 *   GROUP BY phone HAVING COUNT(*) > 1;
 * Если найдутся — индекс не встанет, и это ожидаемо: лучше явная ошибка
 * миграции, чем неоднозначный логин по телефону.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.changeColumn('users', 'email', {
      type: Sequelize.STRING(255),
      allowNull: true
    });
    await queryInterface.changeColumn('users', 'password_hash', {
      type: Sequelize.STRING(255),
      allowNull: true
    });
    await queryInterface.addIndex('users', ['phone'], {
      unique: true,
      name: 'uniq_users_phone'
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeIndex('users', 'uniq_users_phone');
    await queryInterface.changeColumn('users', 'password_hash', {
      type: Sequelize.STRING(255),
      allowNull: false
    });
    await queryInterface.changeColumn('users', 'email', {
      type: Sequelize.STRING(255),
      allowNull: false
    });
  }
};
