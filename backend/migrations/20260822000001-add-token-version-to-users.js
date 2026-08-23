'use strict';

/**
 * Счётчик поколений токенов пользователя.
 *
 * Смена пароля удаляла refresh-токены, но уже выданный access-токен продолжал
 * работать до конца своего срока (по умолчанию 15 минут). То есть владелец
 * сбрасывал пароль работнику из-за потерянного телефона, приложение писало
 * «войдите заново», а у нашедшего телефон доступ ещё оставался.
 *
 * Счётчик, а не отметка времени: в JWT время выдачи хранится с точностью до
 * секунды, поэтому смена пароля в ту же секунду не отличалась бы от выдачи.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.addColumn('users', 'token_version', {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 0,
            comment: 'Токены с другим значением считаются отозванными'
        });
    },

    down: async (queryInterface) => {
        await queryInterface.removeColumn('users', 'token_version');
    }
};
