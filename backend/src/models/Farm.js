const { DataTypes } = require('sequelize');

/**
 * Хозяйство — арендатор сервиса.
 *
 * Раньше фермой считался идентификатор владельца, а принадлежность
 * вычислялась выражением `user.owner_id || user.id`. Пока ферма одна, разницы
 * нет; для сервиса, где ферм много, это выражение — единственная граница
 * между данными разных клиентов, и живёт оно в коде, а не в схеме.
 *
 * Теперь у фермы есть своя строка. От неё идут внешние ключи на всё
 * остальное, поэтому запись, приписанную чужому хозяйству, не примет уже
 * сама база.
 */
module.exports = (sequelize) => {
  return sequelize.define('Farm', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        notEmpty: { msg: 'Название хозяйства обязательно' }
      }
    },
    // Пусто ровно один момент — между созданием фермы и созданием её
    // владельца при регистрации: ссылаться друг на друга они могут только
    // по очереди.
    owner_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    // Тариф фермы. NULL — план не назначен, ограничений нет (см.
    // src/services/planService.js). Назначается автоматически при
    // регистрации (тариф по умолчанию) и вручную платформенным админом —
    // сама ферма себе план не выбирает.
    plan_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    // Срок действия платного тарифа. NULL — бессрочно; так будет всегда у
    // бесплатного тарифа по умолчанию, срок нужен только платным.
    plan_expires_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    // Доступ хозяйства целиком. `active` — обычная работа; `read_only` —
    // только чтение (просрочка или неуплата: данные видны, запись
    // запрещена); `suspended` — доступ закрыт полностью. Проверяется в
    // `authenticate` — единственной точке, через которую идёт каждый запрос.
    status: {
      type: DataTypes.ENUM('active', 'read_only', 'suspended'),
      allowNull: false,
      defaultValue: 'active'
    },
    // Разовая поблажка сверх лимита тарифа, а не смена тарифа: тариф
    // остаётся тем же, поблажка просто складывается с его пределом.
    extra_rabbits: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    extra_staff: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    // До какого момента поблажка действует. NULL при ненулевом `extra_*` —
    // «бессрочно», а не «просрочено»: так же, как `plan_expires_at` выше.
    extras_until: {
      type: DataTypes.DATE,
      allowNull: true
    },
    // NULL — ферма живая; иначе мягко удалена: доступ закрыт сразу, а запись
    // с данными ждёт физической зачистки фоновой задачей (см.
    // docs/plans/PLATFORM-ADMIN.md, 2.4). Не `paranoid: true` намеренно —
    // скоуп «не видеть удалённое» испортил бы карточку, экспорт,
    // восстановление и саму зачистку, которым ферму найти обязательно.
    deleted_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    // Порог неактивности, по которому ферме уже отправлено приглашение
    // вернуться (см. `jobs/inactivityWinbackJob`): NULL — заходят, звать
    // некого; 14 или 30 — на этом пороге уведомление уже ушло. Сбрасывается
    // в NULL, как только по ферме снова видна активность.
    inactivity_notified_days: {
      type: DataTypes.INTEGER,
      allowNull: true
    }
  }, {
    tableName: 'farms',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
      { fields: ['owner_id'], name: 'idx_farms_owner' },
      { fields: ['plan_id'], name: 'idx_farms_plan' }
    ]
  });
};
