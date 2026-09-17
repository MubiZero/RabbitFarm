'use strict';

/**
 * Кто завёл запись о лечении и о прививке.
 *
 * Лечение и прививки оставались единственными записями фермы без автора:
 * кормление подписано (`fed_by`), заметки подписаны (`created_by`), а
 * «кто поставил вакцину» спросить было не у кого — в хозяйстве с наёмными
 * людьми это тот самый вопрос, ради которого журнал и читают.
 *
 * Ссылка обнуляемая и с `SET NULL`: у записей, заведённых до этой колонки,
 * автора взять неоткуда, а уход человека с фермы не должен уносить историю
 * его работы — иначе журнал теряет смысл ровно тогда, когда в него приходят
 * смотреть.
 *
 * Отдельный индекс не заводится: MySQL создаёт его под внешний ключ сам, и
 * второй такой же только мешал бы — откатить миграцию с ним нельзя
 * («Cannot drop index: needed in a foreign key constraint»).
 */
const TABLES = ['medical_records', 'vaccinations'];

module.exports = {
  async up(queryInterface, Sequelize) {
    for (const table of TABLES) {
      await queryInterface.addColumn(table, 'created_by', {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'users', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
        comment: 'Who entered the record'
      });
    }
  },

  async down(queryInterface) {
    for (const table of TABLES) {
      // Имя внешнего ключа придумывает Sequelize, и полагаться на его форму
      // значит однажды получить нерабочий откат. Спрашиваем у самой базы.
      const [keys] = await queryInterface.sequelize.query(
        `SELECT CONSTRAINT_NAME AS name
           FROM information_schema.KEY_COLUMN_USAGE
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = '${table}'
            AND COLUMN_NAME = 'created_by'
            AND REFERENCED_TABLE_NAME IS NOT NULL`
      );

      for (const key of keys) {
        await queryInterface.removeConstraint(table, key.name);
      }

      await queryInterface.removeColumn(table, 'created_by');
    }
  }
};
