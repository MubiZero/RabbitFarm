const { DataTypes } = require('sequelize');

/**
 * Платёж через Эсхата Мерчант.
 *
 * Заявка появляется здесь только если банк принял её при создании —
 * отклонённые банком заявки не сохраняются вовсе (иначе список платежей
 * показывал бы деньги, которых не будет, как ожидающие).
 *
 * `status` меняется только по результату подписанного запроса
 * /orders/status, никогда по одному лишь вебхуку — вебхук ничего не
 * доказывает, он только повод перепроверить.
 */
module.exports = (sequelize) => {
  return sequelize.define('Payment', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    // Наш идентификатор платежа — ключ идемпотентности. Банковский invoiceId
    // и наш — одно и то же значение.
    invoice_id: {
      type: DataTypes.STRING(64),
      allowNull: false,
      unique: true
    },
    // Появляется в ответе на create — до этого момента платежа не существует
    // даже локально.
    order_id: {
      type: DataTypes.STRING(64),
      allowNull: true
    },
    // Касса, которую банк назначил из пула (orderTypeId=3). Нужна дословно —
    // без неё не подписать запрос статуса.
    pos_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    amount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false
    },
    currency: {
      type: DataTypes.STRING(3),
      allowNull: false,
      defaultValue: '972'
    },
    description: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    status: {
      type: DataTypes.ENUM('new', 'completed', 'failed'),
      allowNull: false,
      defaultValue: 'new'
    },
    // Сырой ответ банка на последнюю проверку — для разбора спорных случаев
    // без похода в логи.
    raw_response: {
      type: DataTypes.JSON,
      allowNull: true
    }
  }, {
    tableName: 'payments',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_payments_farm' },
      { fields: ['invoice_id'], name: 'idx_payments_invoice', unique: true }
    ]
  });
};
