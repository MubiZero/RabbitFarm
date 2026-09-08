'use strict';

/**
 * Рычаги админа над одной фермой (см. docs/plans/PLATFORM-ADMIN.md, п. 2.2 и 2.3).
 *
 * `farms.status` — до этого перестать обслуживать неплатящее хозяйство можно
 * было только выключая его людей по одному (`users.is_active`): у самой фермы
 * признака не было. `read_only` вместо полного отключения — продуктовое
 * решение этапа 0: отбирать у фермера историю лечения его же животных из-за
 * неоплаты слишком, а работать всё равно нельзя.
 *
 * `extra_rabbits`/`extra_staff`/`extras_until` — разовая поблажка сверх
 * тарифа («+50 кроликов на месяц»), не смена тарифа: тариф остаётся тем же,
 * и по истечении `extras_until` предел сам возвращается к тарифному.
 * `extras_until = NULL` при ненулевой поблажке означает «бессрочно».
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('farms', 'status', {
      type: Sequelize.ENUM('active', 'read_only', 'suspended'),
      allowNull: false,
      defaultValue: 'active'
    });

    await queryInterface.addColumn('farms', 'extra_rabbits', {
      type: Sequelize.INTEGER,
      allowNull: true
    });

    await queryInterface.addColumn('farms', 'extra_staff', {
      type: Sequelize.INTEGER,
      allowNull: true
    });

    await queryInterface.addColumn('farms', 'extras_until', {
      type: Sequelize.DATE,
      allowNull: true
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('farms', 'extras_until');
    await queryInterface.removeColumn('farms', 'extra_staff');
    await queryInterface.removeColumn('farms', 'extra_rabbits');
    await queryInterface.removeColumn('farms', 'status');
  }
};
