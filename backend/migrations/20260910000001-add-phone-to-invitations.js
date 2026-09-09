'use strict';

/**
 * Приглашение по телефону: адрес перестаёт быть обязательным, рядом
 * появляется номер. Ровно один из двух заполнен — правило прикладное
 * (см. модель `Invitation`), в схеме обе колонки обнуляемые.
 *
 * Откат безопасен только пока приглашений по телефону нет: вернуть
 * `email NOT NULL` при живых строках без адреса база не даст, поэтому в down
 * такие строки сносятся — это неразосланные коды, а не история.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('invitations', 'phone', {
      type: Sequelize.STRING(20),
      allowNull: true,
      after: 'email'
    });

    await queryInterface.changeColumn('invitations', 'email', {
      type: Sequelize.STRING(255),
      allowNull: true
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.sequelize.query('DELETE FROM `invitations` WHERE `email` IS NULL');

    await queryInterface.changeColumn('invitations', 'email', {
      type: Sequelize.STRING(255),
      allowNull: false
    });

    await queryInterface.removeColumn('invitations', 'phone');
  }
};
