const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Photo', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    url: {
      type: DataTypes.STRING(500),
      allowNull: false
    },
    caption: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    taken_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    uploaded_by: {
      type: DataTypes.INTEGER,
      allowNull: true
    }
  }, {
    tableName: 'photos',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['rabbit_id'] },
      { fields: ['taken_at'] }
    ]
  });
};
