const { DataTypes } = require('sequelize');

/**
 * Официальный контакт поддержки — email и телефон, которые задаёт
 * платформенный админ и которые видят фермы рядом с внутренней фичей
 * «Обращения». Синглтон: единственная строка с id=1.
 */
module.exports = (sequelize) => {
  return sequelize.define('SupportContact', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    phone: {
      type: DataTypes.STRING(32),
      allowNull: true
    }
  }, {
    tableName: 'support_contact',
    underscored: true,
    timestamps: true,
    createdAt: false,
    updatedAt: 'updated_at'
  });
};
