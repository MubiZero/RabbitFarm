'use strict';

/**
 * Мягкое удаление фермы (см. docs/plans/PLATFORM-ADMIN.md, 2.4).
 *
 * `farms.deleted_at` — простая колонка, а не Sequelize `paranoid`: `paranoid`
 * тихо добавил бы скоуп ко всем запросам к Farm по всему коду, включая те,
 * где ферму найти обязательно и после удаления (карточка, экспорт,
 * восстановление, фоновая зачистка). Проверка в нужных местах — явная.
 *
 * NULL — ферма живая; дата — доступ закрыт сразу (`authenticate`), а сама
 * запись вместе с файлами ждёт физической зачистки 30 дней.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('farms', 'deleted_at', {
      type: Sequelize.DATE,
      allowNull: true
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('farms', 'deleted_at');
  }
};
