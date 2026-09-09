'use strict';

/**
 * Порог неактивности, по которому ферме уже отправлено приглашение вернуться
 * (см. `jobs/inactivityWinbackJob`).
 *
 * NULL — ферма заходит, звать некого. 14 или 30 — на этом пороге уведомление
 * уже ушло, второй раз в те же ворота не стучимся. Значение сбрасывается в
 * NULL, как только по ферме снова видна активность: вернувшуюся и опять
 * пропавшую ферму нужно позвать заново, а не молчать вечно.
 *
 * Колонка на самой ферме, а не журнал отправленных уведомлений: порогов
 * ровно два, и они не история, а состояние — «где мы сейчас в разговоре с
 * этим клиентом». Заводить под это таблицу — сложность без выгоды.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('farms', 'inactivity_notified_days', {
      type: Sequelize.INTEGER,
      allowNull: true
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('farms', 'inactivity_notified_days');
  }
};
