'use strict';

/**
 * Журнал фермы перестаёт быть только кадровым.
 *
 * До сих пор в него писались лишь действия над людьми (сменил роль, отключил
 * доступ), и ответ на вопрос «кто удалил мою запись» взять было неоткуда:
 * удаление не оставляло следа нигде. Три колонки ниже дают журналу предмет —
 * какая сущность, с каким идентификатором и как она называлась на момент
 * удаления.
 *
 * `entity_label` хранится строкой намеренно: после удаления связанной строки
 * идти больше некуда, и без подписи журнал показывал бы «удалён кролик №417»
 * — то есть ничего.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('farm_audit_log', 'entity_type', {
      type: Sequelize.STRING(40),
      allowNull: true
    });
    await queryInterface.addColumn('farm_audit_log', 'entity_id', {
      type: Sequelize.INTEGER,
      allowNull: true
    });
    await queryInterface.addColumn('farm_audit_log', 'entity_label', {
      type: Sequelize.STRING(120),
      allowNull: true
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('farm_audit_log', 'entity_label');
    await queryInterface.removeColumn('farm_audit_log', 'entity_id');
    await queryInterface.removeColumn('farm_audit_log', 'entity_type');
  }
};
