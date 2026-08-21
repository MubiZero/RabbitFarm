const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Invitation = sequelize.define('Invitation', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    // Ферма, в которую зовут: id владельца.
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        isEmail: { msg: 'Введите корректный email' }
      }
    },
    role: {
      type: DataTypes.ENUM('manager', 'worker'),
      allowNull: false,
      defaultValue: 'worker'
    },
    // Сам код не хранится: в базе лежит только его хеш.
    token_hash: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    expires_at: {
      type: DataTypes.DATE,
      allowNull: false
    },
    accepted_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    created_by: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    tableName: 'invitations',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  });

  return Invitation;
};
