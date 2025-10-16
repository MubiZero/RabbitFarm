const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Breed = sequelize.define('Breed', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: { msg: 'Breed name is required' }
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    average_weight: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: true,
      comment: 'Average weight in kg',
      get() {
        const value = this.getDataValue('average_weight');
        return value !== null ? parseFloat(value) : null;
      }
    },
    average_litter_size: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Average number of kits per litter'
    },
    purpose: {
      type: DataTypes.ENUM('meat', 'fur', 'decorative', 'combined'),
      defaultValue: 'combined'
    },
    photo_url: {
      type: DataTypes.STRING(500),
      allowNull: true
    }
  }, {
    tableName: 'breeds',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['name'] },
      { fields: ['purpose'] }
    ]
  });

  return Breed;
};
