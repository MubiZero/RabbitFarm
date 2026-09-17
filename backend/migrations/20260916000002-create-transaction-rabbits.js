'use strict';

/**
 * Одна денежная операция — много кроликов.
 *
 * Продажа партией не складывалась ни одним способом: `transactions.rabbit_id`
 * держит ровно одного кролика, поэтому тридцать голов в ресторан можно было
 * оформить либо тридцатью строками в книге, либо одной строкой без связи с
 * поголовьем — и тогда кролики оставались живыми, либо пометить их
 * проданными руками, и тогда деньги висели отдельно от выбытия.
 *
 * Колонка `rabbit_id` остаётся: по ней стоят существующие записи, индексы и
 * выборки «операции по этому кролику». Для одиночной операции она
 * заполняется, как и раньше; связи в этой таблице пишутся всегда, и именно
 * они — источник правды о том, кто участвовал в сделке.
 *
 * Существующие привязки переносятся сюда же, чтобы у старых операций история
 * выглядела так же, как у новых.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('transaction_rabbits', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      transaction_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'transactions', key: 'id' },
        onDelete: 'CASCADE'
      },
      rabbit_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'rabbits', key: 'id' },
        onDelete: 'CASCADE'
      },
      // Ферма дублируется намеренно: страж арендаторов отбирает по ней, и
      // без колонки каждая выборка шла бы через join к операции.
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'farms', key: 'id' },
        onDelete: 'CASCADE'
      },
      created_at: { type: Sequelize.DATE, allowNull: false },
      updated_at: { type: Sequelize.DATE, allowNull: false }
    });

    await queryInterface.addConstraint('transaction_rabbits', {
      fields: ['transaction_id', 'rabbit_id'],
      type: 'unique',
      name: 'unique_transaction_rabbit'
    });

    await queryInterface.addIndex('transaction_rabbits', ['rabbit_id']);
    await queryInterface.addIndex('transaction_rabbits', ['farm_id']);

    // Переносим то, что уже связано одиночной колонкой.
    await queryInterface.sequelize.query(`
      INSERT INTO transaction_rabbits (transaction_id, rabbit_id, farm_id, created_at, updated_at)
      SELECT t.id, t.rabbit_id, t.farm_id, NOW(), NOW()
      FROM transactions t
      WHERE t.rabbit_id IS NOT NULL
    `);
  },

  async down(queryInterface) {
    await queryInterface.dropTable('transaction_rabbits');
  }
};
