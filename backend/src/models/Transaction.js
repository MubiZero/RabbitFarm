const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Transaction', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    type: {
      type: DataTypes.ENUM('доход', 'расход'),
      allowNull: false
    },
    category: {
      type: DataTypes.ENUM(
        'продажа кролика', 'продажа мяса', 'продажа шкурок', 'плата за случку',
        'корма', 'ветеринария', 'оборудование', 'коммунальные услуги', 'прочее'
      ),
      allowNull: false
    },
    amount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false
    },
    transaction_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    receipt_url: {
      type: DataTypes.STRING(500),
      allowNull: true
    },
    created_by: {
      type: DataTypes.INTEGER,
      allowNull: true
    }
  }, {
    tableName: 'transactions',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['type'] },
      { fields: ['category'] },
      { fields: ['transaction_date'] },
      { fields: ['rabbit_id'] }
    ]
  });
};
