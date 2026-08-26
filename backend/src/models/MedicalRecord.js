const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('MedicalRecord', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    // Хозяйство, которому принадлежит запись.
    //
    // Раньше принадлежность выводили из соседей — чей кролик, чья клетка,
    // кто внёс. Оба признака подводили: «кто внёс» — это не «чьё», а сама
    // ссылка на автора обнуляется при удалении человека, и запись оставалась
    // ничьей. Теперь хозяйство записано в строке и держится внешним ключом.
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    symptoms: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    diagnosis: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    treatment: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    medication: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    dosage: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    started_at: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    ended_at: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    outcome: {
      type: DataTypes.ENUM('recovered', 'ongoing', 'died', 'euthanized'),
      allowNull: true
    },
    cost: {
      type: DataTypes.DECIMAL(10, 2),
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
    tableName: 'medical_records',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_medical_records_farm' },
      { fields: ['rabbit_id'] },
      { fields: ['started_at'] },
      { fields: ['outcome'] }
    ]
  });
};
