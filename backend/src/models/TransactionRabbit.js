const { DataTypes } = require('sequelize');

/**
 * Кролики, участвовавшие в одной денежной операции.
 *
 * Продажа партией — обычное дело: тридцать голов уходят в ресторан одной
 * сделкой. Колонка `transactions.rabbit_id` держит ровно одного, поэтому
 * такую сделку нельзя было оформить, не пожертвовав чем-то: либо деньги
 * ложились одной строкой, а кролики оставались живыми, либо книга
 * заполнялась тридцатью одинаковыми строками.
 */
module.exports = (sequelize) => {
  return sequelize.define('TransactionRabbit', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    transaction_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    // Ферма дублируется из операции: страж арендаторов отбирает по ней.
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    tableName: 'transaction_rabbits',
    underscored: true,
    timestamps: true,
    indexes: [
      { fields: ['transaction_id', 'rabbit_id'], unique: true },
      { fields: ['rabbit_id'] },
      { fields: ['farm_id'] }
    ]
  });
};
