const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Task', {
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
    title: {
      type: DataTypes.STRING(255),
      allowNull: false
    },

    /// Шаблон заголовка для задач, которые завёл сам сервер (см. `i18n/tasks`).
    ///
    /// Есть ключ — заголовок и описание собираются при выдаче на языке того,
    /// кто их читает, а `title` служит запасным вариантом. Нет ключа — задачу
    /// написал человек, и трогать её текст нельзя.
    title_key: {
      type: DataTypes.STRING(64),
      allowNull: true
    },

    /// Подстановки к шаблону — кличка самки на момент создания задачи.
    title_params: {
      type: DataTypes.JSON,
      allowNull: true
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    type: {
      type: DataTypes.ENUM('feeding', 'cleaning', 'vaccination', 'checkup', 'breeding', 'other'),
      allowNull: false
    },
    status: {
      type: DataTypes.ENUM('pending', 'in_progress', 'completed', 'cancelled'),
      allowNull: false,
      defaultValue: 'pending'
    },
    priority: {
      type: DataTypes.ENUM('low', 'medium', 'high', 'urgent'),
      allowNull: false,
      defaultValue: 'medium'
    },
    due_date: {
      type: DataTypes.DATE,
      allowNull: false
    },
    completed_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    rabbit_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    cage_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    assigned_to: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    created_by: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    is_recurring: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false
    },
    recurrence_rule: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    reminder_before: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Minutes before due date'
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    tableName: 'tasks',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_tasks_farm' },
      { fields: ['status'] },
      { fields: ['due_date'] },
      { fields: ['assigned_to'] },
      { fields: ['rabbit_id'] },
      { fields: ['cage_id'] }
    ]
  });
};
