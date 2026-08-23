'use strict';

/**
 * Таблица для сброса пароля.
 *
 * Модель PasswordResetToken существовала с самого начала, а миграции для неё
 * не было: тестовая база строится через sync() по моделям, поэтому дыру никто
 * не замечал. В продакшене таблицы нет, и первый же запрос на восстановление
 * пароля падает с ER_NO_SUCH_TABLE.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.createTable('password_reset_tokens', {
            id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true
            },
            user_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: { model: 'users', key: 'id' },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            },
            // Хранится только SHA-256 от кода: утечка таблицы не даёт
            // возможности сбросить чужой пароль.
            token_hash: {
                type: Sequelize.STRING(64),
                allowNull: false,
                unique: true
            },
            expires_at: {
                type: Sequelize.DATE,
                allowNull: false
            },
            created_at: {
                type: Sequelize.DATE,
                allowNull: false,
                defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
            }
        });

        await queryInterface.addIndex('password_reset_tokens', ['user_id']);
        await queryInterface.addIndex('password_reset_tokens', ['expires_at']);
    },

    down: async (queryInterface) => {
        await queryInterface.dropTable('password_reset_tokens');
    }
};
