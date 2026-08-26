const { DataTypes } = require('sequelize');

/**
 * Хозяйство — арендатор сервиса.
 *
 * Раньше фермой считался идентификатор владельца, а принадлежность
 * вычислялась выражением `user.owner_id || user.id`. Пока ферма одна, разницы
 * нет; для сервиса, где ферм много, это выражение — единственная граница
 * между данными разных клиентов, и живёт оно в коде, а не в схеме.
 *
 * Теперь у фермы есть своя строка. От неё идут внешние ключи на всё
 * остальное, поэтому запись, приписанную чужому хозяйству, не примет уже
 * сама база.
 */
module.exports = (sequelize) => {
  return sequelize.define('Farm', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        notEmpty: { msg: 'Название хозяйства обязательно' }
      }
    },
    // Пусто ровно один момент — между созданием фермы и созданием её
    // владельца при регистрации: ссылаться друг на друга они могут только
    // по очереди.
    owner_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    }
  }, {
    tableName: 'farms',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['owner_id'], name: 'idx_farms_owner' }
    ]
  });
};
