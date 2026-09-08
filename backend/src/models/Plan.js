const { DataTypes } = require('sequelize');

/**
 * Тарифный план — редактируется в платформенной админке, не фермой.
 *
 * Глобальная сущность сервиса, а не хозяйства: у плана нет `farm_id`, и он
 * не участвует в изоляции ферм (см. `utils/tenancy.js`) — все фермы видят
 * один и тот же список планов.
 *
 * `max_rabbits`/`max_staff` = NULL означает «без ограничения». Ферма без
 * назначенного плана (`farms.plan_id = NULL`) тоже без ограничений — лимиты
 * включаются только когда админ явно назначил план.
 */
module.exports = (sequelize) => {
  return sequelize.define('Plan', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: { msg: 'Название тарифа обязательно' }
      }
    },
    max_rabbits: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    max_staff: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    price: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true
    },
    // Тариф, который автоматически достаётся новой ферме при регистрации.
    // Ровно один тариф может быть таким — проверка в planService, не здесь:
    // на уровне модели/БД второй default не запрещён нарочно, чтобы не
    // городить составной unique-индекс ради редкого админского действия.
    is_default: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false
    }
  }, {
    tableName: 'plans',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  });
};
