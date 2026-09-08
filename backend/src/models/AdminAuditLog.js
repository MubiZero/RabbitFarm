const { DataTypes } = require('sequelize');

/**
 * Журнал действий платформенного админа — кто, когда, что за действие, над
 * какой фермой, что было и что стало. Пишется хелпером `services/auditService`
 * из мутирующих методов `platformAdminController`, не самим сервисом.
 *
 * Неизменяемая запись: `updatedAt` нет, строку журнала не редактируют.
 * Глобальная сущность, как и `Plan`, — не участвует в изоляции ферм
 * (`utils/tenancy.js`): платформенный админ видит журнал по всем фермам сразу.
 */
module.exports = (sequelize) => {
  return sequelize.define('AdminAuditLog', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    admin_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    action: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    before: {
      type: DataTypes.JSON,
      allowNull: true
    },
    after: {
      type: DataTypes.JSON,
      allowNull: true
    },
    ip: {
      type: DataTypes.STRING(64),
      allowNull: true
    }
  }, {
    tableName: 'admin_audit_log',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['farm_id'], name: 'idx_admin_audit_log_farm' },
      { fields: ['admin_id'], name: 'idx_admin_audit_log_admin' }
    ]
  });
};
