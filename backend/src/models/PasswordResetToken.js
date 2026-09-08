const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const PasswordResetToken = sequelize.define('PasswordResetToken', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    token_hash: {
      type: DataTypes.STRING(64),
      allowNull: false,
      unique: true,
      comment: 'SHA-256 hash of the reset token'
    },
    expires_at: {
      type: DataTypes.DATE,
      allowNull: false
    },
    channel: {
      type: DataTypes.ENUM('sms', 'email'),
      allowNull: false,
      defaultValue: 'email'
    },
    attempts: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    }
  }, {
    tableName: 'password_reset_tokens',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['user_id'] },
      { fields: ['token_hash'] },
      { fields: ['expires_at'] }
    ]
  });

  return PasswordResetToken;
};
