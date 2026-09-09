const { DataTypes } = require('sequelize');

/**
 * Обращение фермы в поддержку — что написали и разобрались ли с этим.
 *
 * Живёт на границе двух миров: заводит его ферма, а читает платформенный
 * админ по всем фермам сразу. Поэтому, как и `AdminAuditLog`, модель не
 * подключена к мультитенантному хуку (`utils/tenancy.js`) — иначе список в
 * панели админа упирался бы в обязательное условие по farm_id. Фильтрует
 * запросы фермы сам сервис, явным `farm_id` в create.
 */
module.exports = (sequelize) => {
  return sequelize.define('SupportRequest', {
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
    text: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    status: {
      type: DataTypes.ENUM('new', 'resolved'),
      allowNull: false,
      defaultValue: 'new'
    }
  }, {
    tableName: 'support_requests',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_support_requests_farm' },
      { fields: ['status', 'created_at'], name: 'idx_support_requests_status_created' }
    ]
  });
};
