'use strict';

/**
 * Падёж молодняка до отсадки.
 *
 * Крольчонок в приложении не сущность, а число внутри записи об окроле, и
 * отметить его смерть было негде: экран падежа работает с карточкой
 * взрослого кролика, а карточки у крольчонка нет. Единственным следом потерь
 * оставалась разница между `kits_born_alive` и `kits_weaned` — и то лишь
 * после отсадки, то есть через месяц после самого события.
 *
 * Отдельная колонка, а не новая сущность «группа молодняка в клетке»: на
 * ферме считают выводок целиком («из восьми осталось шесть»), а не каждого
 * крольчонка по имени, и заводить на каждого запись никто не станет.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('births', 'kits_died', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0,
      comment: 'Kits lost between birth and weaning'
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('births', 'kits_died');
  }
};
