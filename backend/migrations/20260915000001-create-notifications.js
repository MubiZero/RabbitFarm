'use strict';

/**
 * Лента уведомлений внутри приложения.
 *
 * До сих пор единственным каналом был пуш. Человек, отказавший в разрешении
 * (а спрашивали его холодным системным диалогом сразу после входа) или
 * просто не открывший телефон утром, никогда и нигде не узнавал о
 * просроченных прививках, кончающемся корме и окроле послезавтра. Данные в
 * приложении были — но искать их надо было самому, и сводка не подсказывала,
 * что о чём-то уже сообщали.
 *
 * Текст не хранится: лежат ключ и подстановки, а собирается фраза на языке
 * читателя в момент чтения — тем же способом, что и заголовки задач. Иначе
 * смена языка в настройках оставляла бы старую ленту на прежнем языке.
 * Исключение — объявления платформы: у них свободный текст, который админ
 * пишет руками, и ключа для него нет.
 */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('notifications', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      farm_id: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      // Ключ словаря и подстановки к нему (см. src/i18n/notifications.js).
      message_key: {
        type: Sequelize.STRING(64),
        allowNull: true
      },
      params: {
        type: Sequelize.JSON,
        allowNull: true
      },
      // Готовый текст — только там, где ключа нет: объявления платформы.
      title: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      body: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      // Куда ведёт нажатие и что это за сообщение — то же, что уходит в
      // `data` пуша, чтобы лента и шторка вели в одно место.
      type: {
        type: Sequelize.STRING(40),
        allowNull: true
      },
      route: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      read_at: {
        type: Sequelize.DATE,
        allowNull: true
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      }
    });

    await queryInterface.addIndex('notifications', {
      fields: ['user_id', 'created_at'],
      name: 'idx_notifications_user_created'
    });
    // Счётчик непрочитанных спрашивают на каждом открытии «Сегодня».
    await queryInterface.addIndex('notifications', {
      fields: ['user_id', 'read_at'],
      name: 'idx_notifications_user_unread'
    });
    await queryInterface.addIndex('notifications', {
      fields: ['farm_id'],
      name: 'idx_notifications_farm'
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('notifications');
  }
};
