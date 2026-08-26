const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Photo', {
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
      { fields: ['farm_id'], name: 'idx_photos_farm' },
      { fields: ['rabbit_id'] },
      { fields: ['taken_at'] }
    ]
  });
};
