const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const TokenBlacklist = sequelize.define('TokenBlacklist', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    jti: {
      type: DataTypes.STRING(36),
      allowNull: false,
      unique: true,
      comment: 'JWT ID (jti claim) of the blacklisted token'
    },
    expires_at: {
      type: DataTypes.DATE,
      allowNull: false,
      comment: 'When the token naturally expires (for cleanup)'
    }
  }, {
    tableName: 'token_blacklist',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    indexes: [
      { fields: ['jti'] },
      { fields: ['expires_at'] }
    ]
  });

  return TokenBlacklist;
};
