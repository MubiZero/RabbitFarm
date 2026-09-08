const { DataTypes } = require('sequelize');

/**
 * Объявление платформенного админа — кто отправил, кому и с каким
 * результатом по каждому каналу. Пишется сервисом `announcementService`
 * синхронно с самой отправкой, не заранее и не фоновой задачей.
 *
 * Неизменяемая запись: `updatedAt` нет. Глобальная сущность, как `Plan` и
 * `AdminAuditLog`, — не участвует в изоляции ферм (`utils/tenancy.js`).
 */
module.exports = (sequelize) => {
  return sequelize.define('Announcement', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    admin_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    body: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    channels: {
      type: DataTypes.JSON,
      allowNull: false
    },
    target_type: {
      type: DataTypes.ENUM('all', 'farm', 'filter'),
      allowNull: false
    },
    target_farm_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    target_filter: {
      type: DataTypes.STRING(50),
      allowNull: true
    },
    farms_count: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    recipients_count: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    stats: {
      type: DataTypes.JSON,
      allowNull: true
    }
  }, {
    tableName: 'announcements',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['admin_id'], name: 'idx_announcements_admin' },
      { fields: ['target_farm_id'], name: 'idx_announcements_farm' }
    ]
  });
};
