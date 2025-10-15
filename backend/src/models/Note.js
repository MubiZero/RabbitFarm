const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Note', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    cage_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    content: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    created_by: {
      type: DataTypes.INTEGER,
      allowNull: true
    }
  }, {
    tableName: 'notes',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['rabbit_id'] },
      { fields: ['cage_id'] }
    ]
  });
};
