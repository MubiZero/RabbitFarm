'use strict';

/**
 * Назначение по умолчанию для нового кролика.
 *
 * Назначение (мясо, племя, продажа) — свойство хозяйства, а не двухсот
 * карточек: большинство ферм держат кроликов для чего-то одного. Выставлять
 * его всему поголовью разом уже можно, но каждый новый кролик снова
 * спрашивал об этом в форме — и фермер, заведя тридцатого подряд «на мясо»,
 * справедливо спрашивал, зачем его об этом спрашивают.
 *
 * Пусто — значит хозяйство ещё не сказало, кого держит: тогда действует
 * прежнее «племя», как и было в колонке кроликов.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('farms', 'default_purpose', {
      type: Sequelize.ENUM('breeding', 'meat', 'sale', 'show'),
      allowNull: true,
      comment: 'Default purpose for newly created rabbits'
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('farms', 'default_purpose');
  }
};
