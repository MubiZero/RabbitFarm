const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const User = sequelize.define('User', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true,
      validate: {
        isEmail: { msg: 'Введите корректный email' }
      }
    },
    password_hash: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    full_name: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        notEmpty: { msg: 'Имя обязательно' },
        len: {
          args: [2, 255],
          msg: 'Имя должно быть от 2 до 255 символов'
        }
      }
    },
    // Хозяйство, в котором человек работает. Заполнено всегда: учётная
    // запись вне фермы не значит ничего.
    //
    // Раньше здесь стоял `owner_id`, отвечавший сразу на два вопроса — к
    // какой ферме относится человек и кто на ферме главный. Второй ответ
    // переехал в `farms.owner_id`, и у принадлежности остался один источник.
    farm_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    role: {
      type: DataTypes.ENUM('owner', 'manager', 'worker'),
      allowNull: false,
      defaultValue: 'worker'
    },
    phone: {
      type: DataTypes.STRING(20),
      allowNull: true,
      validate: {
        is: {
          args: /^[+]?[(]?[0-9]{1,3}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$/,
          msg: 'Неверный формат телефона'
        }
      }
    },
    avatar_url: {
      type: DataTypes.STRING(500),
      allowNull: true
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true
    },
    last_login_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    // Поколение токенов. Растёт при каждой смене пароля, и все выданные
    // раньше токены перестают приниматься.
    token_version: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    // Платформенный суперадмин — не роль фермы, а отдельный флаг: видит и
    // администрирует все фермы сразу. Ставится вручную в БД.
    is_platform_admin: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false
    }
  }, {
    tableName: 'users',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['farm_id'], name: 'idx_users_farm' },
      { fields: ['email'] },
      { fields: ['role'] },
      { fields: ['is_active'] }
    ]
  });

  // Instance methods
  User.prototype.toJSON = function() {
    const values = { ...this.get() };
    delete values.password_hash;
    return values;
  };

  return User;
};
