'use strict';

/**
 * Убираем DEFAULT 1 у user_id.
 *
 * Значение по умолчанию ставили только чтобы заполнить существующие строки при
 * добавлении колонки, но снять его забыли на всех таблицах кроме breeds. Пока
 * оно есть, любой INSERT, где забыли указать ферму, молча припишет запись
 * первому пользователю — база при этом не возразит.
 */
const TABLES = ['rabbits', 'cages', 'feeds', 'breedings'];

module.exports = {
    up: async (queryInterface) => {
        for (const table of TABLES) {
            await queryInterface.sequelize.query(
                `ALTER TABLE \`${table}\` ALTER COLUMN \`user_id\` DROP DEFAULT`
            );
        }
    },

    down: async (queryInterface) => {
        for (const table of TABLES) {
            await queryInterface.sequelize.query(
                `ALTER TABLE \`${table}\` ALTER COLUMN \`user_id\` SET DEFAULT 1`
            );
        }
    }
};
