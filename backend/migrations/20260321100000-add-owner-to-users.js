'use strict';

/**
 * Работники фермы.
 *
 * Ферма — это её владелец: данные уже разделены по user_id владельца.
 * Работник получает owner_id, указывающий на владельца, и с этого момента
 * работает внутри его фермы, а не в собственной пустой.
 *
 * owner_id = NULL означает «сам себе ферма» (владелец).
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.addColumn('users', 'owner_id', {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: { model: 'users', key: 'id' },
            onUpdate: 'CASCADE',
            // Удаление владельца уносит его работников: без фермы они
            // не имеют смысла и не должны оставаться висеть.
            onDelete: 'CASCADE'
        });
        await queryInterface.addIndex('users', ['owner_id']);
    },

    down: async (queryInterface) => {
        await queryInterface.removeColumn('users', 'owner_id');
    }
};
