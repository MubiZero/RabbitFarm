'use strict';

/**
 * Обращения ферм в поддержку.
 *
 * Внешнего канала (Zendesk и подобное) у сервиса нет, а «обратитесь в
 * поддержку» в приложении написано в нескольких местах — до сих пор без
 * единого способа это сделать. Обращение остаётся внутри продукта: ферма
 * пишет из приложения, платформенный админ читает у себя в панели.
 *
 * Жизненный цикл нарочно из двух состояний: `new` — прочитать, `resolved` —
 * закрыть. Ни приоритетов, ни тегов, ни переписки: на нуле платящих клиентов
 * это была бы система тикетов ради системы тикетов.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('support_requests', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'farms', key: 'id' },
        onDelete: 'CASCADE'
      },
      // Кто написал — конкретный человек фермы, а не «ферма вообще»: отвечать
      // всё равно придётся ему, и роль (владелец или работник) меняет ответ.
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'users', key: 'id' },
        onDelete: 'CASCADE'
      },
      text: {
        type: Sequelize.TEXT,
        allowNull: false
      },
      status: {
        type: Sequelize.ENUM('new', 'resolved'),
        allowNull: false,
        defaultValue: 'new'
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('support_requests', ['farm_id'], { name: 'idx_support_requests_farm' });
    // Панель админа открывается ради необработанных: сортировка идёт по паре
    // «статус, дата», индекс по ней же.
    await queryInterface.addIndex('support_requests', ['status', 'created_at'], { name: 'idx_support_requests_status_created' });
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable('support_requests');
  }
};
