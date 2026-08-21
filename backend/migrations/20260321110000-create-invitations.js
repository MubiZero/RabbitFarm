'use strict';

/**
 * Приглашения в ферму.
 *
 * Почтового сервера у сервиса нет, поэтому приглашение — это код, который
 * владелец передаёт человеку любым удобным способом. Код хранится хешем:
 * в базе он бесполезен, а показывается один раз при создании.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.createTable('invitations', {
            id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true
            },
            farm_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: { model: 'users', key: 'id' },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            },
            email: {
                type: Sequelize.STRING(255),
                allowNull: false
            },
            role: {
                type: Sequelize.ENUM('manager', 'worker'),
                allowNull: false,
                defaultValue: 'worker'
            },
            token_hash: {
                type: Sequelize.STRING(255),
                allowNull: false
            },
            expires_at: {
                type: Sequelize.DATE,
                allowNull: false
            },
            accepted_at: {
                type: Sequelize.DATE,
                allowNull: true
            },
            created_by: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: { model: 'users', key: 'id' },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            },
            created_at: {
                type: Sequelize.DATE,
                allowNull: false,
                defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
            },
            updated_at: {
                type: Sequelize.DATE,
                allowNull: false,
                defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
            }
        });

        await queryInterface.addIndex('invitations', ['farm_id']);
        // Поиск при активации идёт по хешу кода.
        await queryInterface.addIndex('invitations', ['token_hash']);
    },

    down: async (queryInterface) => {
        await queryInterface.dropTable('invitations');
    }
};
