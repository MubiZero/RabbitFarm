const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Feed', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    type: {
      type: DataTypes.ENUM('pellets', 'hay', 'vegetables', 'grain', 'supplements', 'other'),
      allowNull: false
    },
    brand: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    unit: {
      type: DataTypes.ENUM('kg', 'liter', 'piece'),
      allowNull: false,
      defaultValue: 'kg'
    },
    current_stock: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0
    },
    min_stock: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0
    },
    cost_per_unit: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'feeds',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['name'] },
      { fields: ['type'] }
    ]
  });
};
