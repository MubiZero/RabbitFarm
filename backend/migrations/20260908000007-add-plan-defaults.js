'use strict';

/**
 * Тариф по умолчанию и срок действия платного тарифа (см.
 * docs/plans/PLATFORM-ADMIN.md, п. 1.2).
 *
 * `plans.is_default` — ровно один тариф может быть таким, проверка живёт в
 * `planService` (сервис бросает `DEFAULT_PLAN_EXISTS`, если админ пытается
 * назначить default второму тарифу, вместо того чтобы молча переключать).
 *
 * `farms.plan_expires_at` — пусто означает «бессрочно». У бесплатного
 * тарифа по умолчанию так будет всегда; срок нужен только платным.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('plans', 'is_default', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false
    });

    await queryInterface.addColumn('farms', 'plan_expires_at', {
      type: Sequelize.DATE,
      allowNull: true
    });

    // В бою ферм с plan_id = NULL на момент миграции не было, но на
    // случай, если дефолтный тариф к моменту миграции уже заведён через
    // админку, — досрочно закрываем дырку и для существующих ферм. Если
    // дефолтного тарифа ещё нет, запрос ничего не находит и ничего не меняет.
    await queryInterface.sequelize.query(`
      UPDATE farms
      SET plan_id = (SELECT id FROM plans WHERE is_default = true LIMIT 1)
      WHERE plan_id IS NULL
        AND EXISTS (SELECT 1 FROM plans WHERE is_default = true)
    `);
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('farms', 'plan_expires_at');
    await queryInterface.removeColumn('plans', 'is_default');
  }
};
