const { DataTypes } = require('sequelize');

/**
 * Журнал кадровых действий внутри фермы — кто, когда, над кем и что сделал:
 * сменил роль, отключил доступ, передал хозяйство. Раньше это оставалось
 * только в `logger.info`, то есть в стдауте сервера: владелец не мог
 * посмотреть, кто и когда понизил работника, не имея доступа к серверу.
 *
 * Пишется хелпером `services/farmAuditService` из `staffService`, читается
 * через `GET /staff/audit`.
 *
 * Неизменяемая запись: `updatedAt` нет, строку журнала не редактируют.
 * В отличие от `AdminAuditLog` (журнал платформенного админа, глобальный),
 * эта таблица принадлежит ферме и участвует в изоляции (`utils/tenancy.js`).
 */
module.exports = (sequelize) => {
  return sequelize.define('FarmAuditLog', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    // Кто сделал и над кем. Обе ссылки обнуляемые: удаление человека не
    // должно уносить историю его действий — иначе журнал теряет смысл
    // ровно тогда, когда в него приходят смотреть.
    actor_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    target_user_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    action: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    before: {
      type: DataTypes.JSON,
      allowNull: true
    },
    after: {
      type: DataTypes.JSON,
      allowNull: true
    }
  }, {
    tableName: 'farm_audit_log',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['farm_id', 'created_at'], name: 'idx_farm_audit_log_farm_created' },
      { fields: ['target_user_id'], name: 'idx_farm_audit_log_target' }
    ]
  });
};
