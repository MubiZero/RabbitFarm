const { DataTypes } = require('sequelize');

/**
 * Токен устройства для push-уведомлений.
 *
 * Один токен — одно устройство. Уникальность по `token` (а не по паре
 * user_id+token) на случай, если устройство сменит владельца: логаут одного
 * работника и логин другого на том же телефоне переписывает строку через
 * upsert, а не плодит дубли.
 */
module.exports = (sequelize) => {
  return sequelize.define('DeviceToken', {
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
    token: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true
    },
    platform: {
      type: DataTypes.ENUM('android', 'ios'),
      allowNull: false
    }
  }, {
    tableName: 'device_tokens',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_device_tokens_farm' },
      { fields: ['user_id'], name: 'idx_device_tokens_user' }
    ]
  });
};
