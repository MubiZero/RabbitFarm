const { DataTypes } = require('sequelize');

// Force number type for weight field
module.exports = (sequelize) => {
  return sequelize.define('RabbitWeight', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    weight: {
      type: DataTypes.FLOAT,
      allowNull: false,
      get() {
        const value = this.getDataValue('weight');
        return value !== null ? parseFloat(value) : null;
      }
    },
    measured_at: {
      type: DataTypes.DATE,
      allowNull: false
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'rabbit_weights',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['rabbit_id'] },
      { fields: ['measured_at'] }
    ]
  });
};
