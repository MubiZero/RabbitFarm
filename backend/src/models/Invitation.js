const { DataTypes } = require('sequelize');
const { TJ_PHONE_PATTERN } = require('../utils/phone');

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
    // Куда звали: адрес или номер. Заполнено ровно одно из двух — приглашение
    // без контакта некому передать, а с двумя непонятно, куда слать код.
    email: {
      type: DataTypes.STRING(255),
      allowNull: true,
      validate: {
        isEmail: { msg: 'Введите корректный email' }
      }
    },
    phone: {
      type: DataTypes.STRING(20),
      allowNull: true,
      validate: {
        is: {
          args: TJ_PHONE_PATTERN,
          msg: 'Телефон должен быть таджикским номером: +992XXXXXXXXX'
        }
      }
    },
    role: {
      type: DataTypes.ENUM('manager', 'worker'),
      allowNull: false,
      defaultValue: 'worker'
    },
    // Имя приглашённого. При активации приглашения по телефону через
    // OTP-вход отдельной формы для ввода имени больше нет — владелец вводит
    // его сразу при создании приглашения (см. `createInvitationSchema`,
    // где оно обязательно для приглашений по телефону).
    full_name: {
      type: DataTypes.STRING(255),
      allowNull: true
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
    updatedAt: 'updated_at',
    validate: {
      // База обе колонки разрешает пустыми, поэтому «ровно один контакт»
      // держится здесь: приглашение без адреса и без номера — мусор, который
      // никому не отдать, а с двумя сразу непонятно, каким каналом слать.
      //
      // Оба `undefined` (не `null`) — значит, это частичный bulk `.update()`,
      // который email/phone не трогает вовсе: Sequelize валидирует такой
      // апдейт на «пустом» инстансе из одних только переданных полей, и без
      // этой проверки любой `Invitation.update({expires_at}, {where})`
      // ловил бы ложное «нужен ровно один контакт».
      exactlyOneContact() {
        if (this.email === undefined && this.phone === undefined) return;
        if (Boolean(this.email) === Boolean(this.phone)) {
          throw new Error('Приглашение выписывается на email или на телефон — что-то одно');
        }
      }
    }
  });

  return Invitation;
};
