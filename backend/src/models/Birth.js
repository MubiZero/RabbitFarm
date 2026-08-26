const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Birth', {
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
    breeding_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    mother_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    birth_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    kits_born_alive: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    kits_born_dead: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    kits_weaned: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    weaning_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    complications: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'births',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_births_farm' },
      { fields: ['breeding_id'] },
      { fields: ['mother_id'] },
      { fields: ['birth_date'] }
    ]
  });
};
