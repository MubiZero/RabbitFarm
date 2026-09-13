'use strict';

/**
 * Код входа теперь приходит и на почту, а не только в SMS: почта стала
 * вторым способом входа вместо пароля. Ключ таблицы —
 * контакт, которым человек входит, плюс канал доставки.
 *
 * Переименование, а не новая колонка: запись всегда про один контакт, и
 * два поля `phone`/`email`, из которых заполнено ровно одно, пришлось бы
 * проверять в каждом запросе.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.renameColumn('login_otps', 'phone', 'identifier');
    await queryInterface.changeColumn('login_otps', 'identifier', {
      // Почта длиннее номера: 255 — та же граница, что у `users.email`.
      type: Sequelize.STRING(255),
      allowNull: false
    });
    await queryInterface.addColumn('login_otps', 'channel', {
      type: Sequelize.ENUM('phone', 'email'),
      allowNull: false,
      defaultValue: 'phone'
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Коды живут десять минут — уносить с собой почтовые записи не жалко,
    // а в колонке на 20 символов они бы всё равно не поместились.
    await queryInterface.bulkDelete('login_otps', { channel: 'email' });
    await queryInterface.removeColumn('login_otps', 'channel');
    await queryInterface.changeColumn('login_otps', 'identifier', {
      type: Sequelize.STRING(20),
      allowNull: false
    });
    await queryInterface.renameColumn('login_otps', 'identifier', 'phone');
  }
};
