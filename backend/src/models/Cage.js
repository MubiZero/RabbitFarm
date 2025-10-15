const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Cage = sequelize.define('Cage', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    number: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: { msg: 'Cage number is required' }
      }
    },
    type: {
      type: DataTypes.ENUM('single', 'group', 'maternity'),
      allowNull: false,
      defaultValue: 'single'
    },
    size: {
      type: DataTypes.STRING(50),
      allowNull: true,
      comment: 'Dimensions (e.g., "60x80x45")'
    },
    capacity: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1,
      validate: {
        min: { args: [1], msg: 'Capacity must be at least 1' }
      }
    },
    location: {
      type: DataTypes.STRING(255),
      allowNull: true,
      comment: 'Location on farm'
    },
    condition: {
      type: DataTypes.ENUM('good', 'needs_repair', 'broken'),
      allowNull: false,
      defaultValue: 'good'
    },
    last_cleaned_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'cages',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['number'] },
      { fields: ['type'] },
      { fields: ['condition'] }
    ]
  });

  return Cage;
};
