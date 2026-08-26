const { DataTypes } = require('sequelize');

// Force number type for weight field
module.exports = (sequelize) => {
  return sequelize.define('RabbitWeight', {
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
      { fields: ['farm_id'], name: 'idx_rabbit_weights_farm' },
      { fields: ['rabbit_id'] },
      { fields: ['measured_at'] }
    ]
  });
};
