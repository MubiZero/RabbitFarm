'use strict';

/**
 * Задачи, которые сервер заводит сам (пальпация, маточник, отсадка), до сих
 * пор хранились готовой русской строкой — и таджикоязычный работник видел их
 * по-русски, сколько бы языков ни знало приложение.
 *
 * Теперь рядом с текстом лежит ключ шаблона и его параметры (кличка самки), а
 * читаемый заголовок собирается при выдаче на языке того, кто спрашивает.
 * Сам `title` остаётся заполненным: он же и запасной вариант для сборок,
 * которые про ключи ещё не знают, и то, по чему ищут в списке задач.
 *
 * У задач, заведённых человеком, ключа нет — их текст принадлежит автору и
 * переводу не подлежит.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('tasks', 'title_key', {
      type: Sequelize.STRING(64),
      allowNull: true
    });
    await queryInterface.addColumn('tasks', 'title_params', {
      type: Sequelize.JSON,
      allowNull: true
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('tasks', 'title_key');
    await queryInterface.removeColumn('tasks', 'title_params');
  }
};
