const { DataTypes } = require('sequelize');

/**
 * Код входа по телефону. Ключ — сам телефон, а не `user_id`: на момент
 * запроса кода за номером может стоять ещё не созданный пользователь,
 * только активное приглашение (см. `otpAuthService.verifyOtp`).
 */
module.exports = (sequelize) => {
  const LoginOtp = sequelize.define('LoginOtp', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    phone: {
      type: DataTypes.STRING(20),
      allowNull: false
    },
    // Без unique — 6-значный код не гарантирует уникальность хеша по всей
    // таблице, ищем по `phone`, как и в `PasswordResetToken`.
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
      { fields: ['phone'], name: 'idx_login_otps_phone' },
      { fields: ['expires_at'], name: 'idx_login_otps_expires_at' }
    ]
  });

  return LoginOtp;
};
