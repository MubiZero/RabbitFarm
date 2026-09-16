'use strict';

/**
 * Язык человека, чтобы уведомления приходили на нём, а не всегда по-русски.
 *
 * Приложение давно говорит на четырёх языках, а пуши и письма с сервера
 * уходили одним русским текстом — таджикский фермер получал сообщение,
 * которого не читает.
 *
 * Хранится у пользователя, а не у устройства: тем же языком подписываются
 * письма, а у почты устройства нет. Существующим строкам достаётся `ru` —
 * ровно то, что они и получали до сих пор.
 */
const LANGUAGES = ['ru', 'en', 'tg', 'uz'];

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('users', 'language', {
      type: Sequelize.ENUM(...LANGUAGES),
      allowNull: false,
      defaultValue: 'ru'
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('users', 'language');
  }
};
