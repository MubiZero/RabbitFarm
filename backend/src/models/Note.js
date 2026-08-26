const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Note', {
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
      { fields: ['farm_id'], name: 'idx_notes_farm' },
      { fields: ['rabbit_id'] },
      { fields: ['cage_id'] }
    ]
  });
};
