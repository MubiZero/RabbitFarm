const { DataTypes } = require('sequelize');

/**
 * Код входа. Ключ — сам контакт (телефон или почта), а не `user_id`: на
 * момент запроса кода за контактом может стоять ещё не созданный
 * пользователь, только активное приглашение (см. `otpAuthService.verifyOtp`).
 */
module.exports = (sequelize) => {
  const LoginOtp = sequelize.define('LoginOtp', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    identifier: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    channel: {
      type: DataTypes.ENUM('phone', 'email'),
      allowNull: false,
      defaultValue: 'phone'
    },
    // Без unique — 6-значный код не гарантирует уникальность хеша по всей
    // таблице, ищем по `identifier`.
    token_hash: {
      type: DataTypes.STRING(64),
      allowNull: false
    },
    attempts: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    expires_at: {
      type: DataTypes.DATE,
      allowNull: false
    }
  }, {
    tableName: 'login_otps',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['identifier'], name: 'idx_login_otps_phone' },
      { fields: ['expires_at'], name: 'idx_login_otps_expires_at' }
    ]
  });

  return LoginOtp;
};
