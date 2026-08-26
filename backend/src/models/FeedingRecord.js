const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('FeedingRecord', {
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
      { fields: ['farm_id'], name: 'idx_feeding_records_farm' },
      { fields: ['rabbit_id'] },
      { fields: ['feed_id'] },
      { fields: ['cage_id'] },
      { fields: ['fed_at'] }
    ]
  });
};
