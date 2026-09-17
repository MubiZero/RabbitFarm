'use strict';

/**
 * Когда по задаче ушло напоминание.
 *
 * Поле `reminder_before` («за сколько минут предупредить») лежало в базе с
 * самого начала и не читалось никем: единственное, что приходило человеку, —
 * утренняя сводка про уже просроченное. То есть напоминание предупреждало о
 * том, что срок пропущен, а не помогало его не пропустить.
 *
 * Отметка нужна, чтобы не слать одно и то же по кругу: задача проверяет
 * напоминания чаще, чем раз в день, и без неё каждый проход слал бы всё тот
 * же сигнал заново.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('tasks', 'reminder_sent_at', {
      type: Sequelize.DATE,
      allowNull: true,
      comment: 'When the advance reminder was delivered'
    });

    await queryInterface.addIndex('tasks', ['reminder_sent_at']);
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('tasks', 'reminder_sent_at');
  }
};
