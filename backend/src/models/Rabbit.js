const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Rabbit = sequelize.define('Rabbit', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    tag_id: {
      type: DataTypes.STRING(50),
      unique: true,
      allowNull: true,
      comment: 'Tag/chip ID'
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    breed_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    sex: {
      type: DataTypes.ENUM('male', 'female'),
      allowNull: false
    },
    birth_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    color: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    cage_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    father_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    mother_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    status: {
      type: DataTypes.ENUM('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead'),
      allowNull: false,
      defaultValue: 'healthy'
    },
    purpose: {
      type: DataTypes.ENUM('breeding', 'meat', 'sale', 'show'),
      allowNull: false,
      defaultValue: 'breeding'
    },
    acquired_date: {
      type: DataTypes.DATEONLY,
      allowNull: true,
      comment: 'Date acquired if not born on farm'
    },
    sold_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    death_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    death_reason: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    current_weight: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: true,
      comment: 'Current weight in kg'
    },
    temperament: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    photo_url: {
      type: DataTypes.STRING(500),
      allowNull: true,
      comment: 'Main photo'
    }
  }, {
    tableName: 'rabbits',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['tag_id'] },
      { fields: ['name'] },
      { fields: ['breed_id'] },
      { fields: ['sex'] },
      { fields: ['status'] },
      { fields: ['purpose'] },
      { fields: ['birth_date'] },
      { fields: ['cage_id'] },
      { fields: ['father_id'] },
      { fields: ['mother_id'] }
    ]
  });

  // Virtual field: age in months
  Rabbit.prototype.getAgeInMonths = function() {
    const today = new Date();
    const birthDate = new Date(this.birth_date);
    const months = (today.getFullYear() - birthDate.getFullYear()) * 12 +
                   today.getMonth() - birthDate.getMonth();
    return months;
  };

  return Rabbit;
};
