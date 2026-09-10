const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const User = sequelize.define('User', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    // Основной вход — по телефону (см. `phone` ниже), email остаётся
    // опциональным запасным способом. Пусто бывает у работника, заведённого
    // через OTP-вход по приглашению и ни разу не задавшего пароль.
    email: {
      type: DataTypes.STRING(255),
      allowNull: true,
      unique: true,
      validate: {
        isEmail: { msg: 'Введите корректный email' }
      }
    },
    password_hash: {
      type: DataTypes.STRING(255),
      allowNull: true
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
    },
    // Единственная настройка уведомлений на сейчас: получать ли ежедневный
    // дайджест (см. `jobs/notificationDigestJob.js`). По умолчанию включён —
    // молчание не должно быть дефолтом там, где раньше выбора не было вовсе.
    digest_enabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true
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
      { fields: ['is_active'] },
      { fields: ['phone'], unique: true, name: 'uniq_users_phone' }
    ],
    validate: {
      // Учётная запись без единого способа связаться с человеком — мусор:
      // ни войти самому (email/пароль или телефон/OTP), ни владельцу его
      // найти. Оба сразу — обычное дело, запрещена только пустота.
      //
      // Оба `undefined` (не `null`) значит частичный bulk `.update()`,
      // который email/phone не трогает вовсе — Sequelize валидирует такой
      // апдейт на «пустом» инстансе из одних только переданных полей (тот же
      // случай разобран в `Invitation.exactlyOneContact`), и без этой
      // проверки любой `User.update({role}, {where})` ловил бы ложное
      // «нужен email или телефон».
      hasIdentity() {
        if (this.email === undefined && this.phone === undefined) return;
        if (!this.email && !this.phone) {
          throw new Error('Нужен email или телефон');
        }
      }
    }
  });

  // Instance methods
  User.prototype.toJSON = function() {
    const values = { ...this.get() };
    // Клиенту нужно знать, задан ли пароль вообще (вход мог быть только по
    // OTP) — чтобы предложить «Задать пароль» или «Изменить пароль», не сам
    // хеш конечно.
    values.has_password = !!values.password_hash;
    delete values.password_hash;
    return values;
  };

  return User;
};
