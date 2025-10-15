const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Task', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: false
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
      { fields: ['status'] },
      { fields: ['due_date'] },
      { fields: ['assigned_to'] },
      { fields: ['rabbit_id'] },
      { fields: ['cage_id'] }
    ]
  });
};
