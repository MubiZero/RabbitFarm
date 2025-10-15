const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Vaccination', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    vaccine_name: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    vaccine_type: {
      type: DataTypes.ENUM('vhd', 'myxomatosis', 'pasteurellosis', 'other'),
      allowNull: false
    },
    vaccination_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    next_vaccination_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    batch_number: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    veterinarian: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'vaccinations',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['rabbit_id'] },
      { fields: ['vaccine_type'] },
      { fields: ['vaccination_date'] },
      { fields: ['next_vaccination_date'] }
    ]
  });
};
