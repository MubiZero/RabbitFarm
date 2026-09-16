'use strict';

/**
 * Страна хозяйства, а из неё — валюта и часовой пояс.
 *
 * До сих пор весь сервис был одной страной: сомони в коде константой, СМС
 * через таджикский шлюз, и один общий `TZ=Asia/Dushanbe` на все фермы сразу.
 * Пока хозяйства были только таджикскими, это работало.
 *
 * Часовой пояс здесь — не про красоту. Границы суток в отчётах считаются
 * поясом процесса, и ферма за его пределами получала бы утреннюю сводку
 * ночью, а её «сегодня» в отчётах разъезжалось бы на смещение пояса.
 *
 * Значения по умолчанию — таджикские: все существующие хозяйства именно
 * такие, и после этой миграции для них не меняется ничего.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('farms', 'country', {
      type: Sequelize.CHAR(2),
      allowNull: false,
      defaultValue: 'TJ',
      comment: 'ISO 3166-1 alpha-2 country of the farm'
    });

    await queryInterface.addColumn('farms', 'currency', {
      type: Sequelize.CHAR(3),
      allowNull: false,
      defaultValue: 'TJS',
      comment: 'ISO 4217 alphabetic currency code used for this farm'
    });

    await queryInterface.addColumn('farms', 'timezone', {
      type: Sequelize.STRING(64),
      allowNull: false,
      defaultValue: 'Asia/Dushanbe',
      comment: 'IANA timezone; day boundaries in reports are counted in it'
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('farms', 'timezone');
    await queryInterface.removeColumn('farms', 'currency');
    await queryInterface.removeColumn('farms', 'country');
  }
};
