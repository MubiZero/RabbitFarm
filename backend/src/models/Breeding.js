const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Breeding', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    male_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    female_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    breeding_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    status: {
      type: DataTypes.ENUM('planned', 'completed', 'failed', 'cancelled'),
      allowNull: false,
      defaultValue: 'planned'
    },
    palpation_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    is_pregnant: {
      type: DataTypes.BOOLEAN,
      allowNull: true
    },
    expected_birth_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'breedings',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['male_id'] },
      { fields: ['female_id'] },
      { fields: ['breeding_date'] },
      { fields: ['status'] },
      { fields: ['expected_birth_date'] }
    ],
    hooks: {
      beforeSave: (breeding) => {
        if (breeding.breeding_date && !breeding.expected_birth_date) {
          const breedingDate = new Date(breeding.breeding_date);
          breedingDate.setDate(breedingDate.getDate() + 31);
          breeding.expected_birth_date = breedingDate.toISOString().split('T')[0];
        }
      }
    }
  });
};
