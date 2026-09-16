const { DataTypes } = require('sequelize');

/**
 * Одно уведомление в ленте приложения — см. миграцию
 * `20260915000001-create-notifications`.
 *
 * Пишется на каждого получателя отдельной строкой, а не одной на ферму:
 * прочитал один совладелец — второму сообщение должно остаться
 * непрочитанным, иначе лента врёт про то, кто что видел.
 */
module.exports = (sequelize) => {
  return sequelize.define('Notification', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    message_key: {
      type: DataTypes.STRING(64),
      allowNull: true
    },
    params: {
      type: DataTypes.JSON,
      allowNull: true
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    body: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    type: {
      type: DataTypes.STRING(40),
      allowNull: true
    },
    route: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    read_at: {
      type: DataTypes.DATE,
      allowNull: true
    }
  }, {
    tableName: 'notifications',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    // Уведомление не редактируют: его либо читают, либо нет.
    updatedAt: false
  });
};
