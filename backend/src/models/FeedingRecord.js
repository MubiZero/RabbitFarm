const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('FeedingRecord', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    feed_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    cage_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    quantity: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false
    },
    fed_at: {
      type: DataTypes.DATE,
      allowNull: false
    },
    fed_by: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'feeding_records',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['rabbit_id'] },
      { fields: ['feed_id'] },
      { fields: ['cage_id'] },
      { fields: ['fed_at'] }
    ]
  });
};
