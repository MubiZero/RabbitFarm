'use strict';

/**
 * Ответ поддержки — чтобы обращение перестало быть дорогой в один конец.
 *
 * До сих пор человек писал в поддержку и не узнавал ничего: ни что обращение
 * приняли, ни что его разобрали. Отметка «разобрано» меняла флаг, который
 * видел только админ, а ответить внутри продукта было нечем — предполагалось,
 * что поддержка позвонит. Телефона поддержки при этом тоже нет: задать его
 * в приложении было негде.
 *
 * `resolved_by` и `resolved_at` — чтобы у ответа был автор и время: иначе на
 * вопрос «кто это закрыл и когда» отвечать снова нечем.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('support_requests', 'answer', {
      type: Sequelize.TEXT,
      allowNull: true
    });
    await queryInterface.addColumn('support_requests', 'resolved_by', {
      type: Sequelize.INTEGER,
      allowNull: true
    });
    await queryInterface.addColumn('support_requests', 'resolved_at', {
      type: Sequelize.DATE,
      allowNull: true
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('support_requests', 'resolved_at');
    await queryInterface.removeColumn('support_requests', 'resolved_by');
    await queryInterface.removeColumn('support_requests', 'answer');
  }
};
