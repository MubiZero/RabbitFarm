'use strict';

module.exports = {
    up: async (queryInterface, Sequelize) => {
        // Add user_id to cages
        await queryInterface.addColumn('cages', 'user_id', {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 1,
            references: { model: 'users', key: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });
        await queryInterface.addIndex('cages', ['user_id']);
        await queryInterface.addConstraint('cages', {
            fields: ['user_id', 'number'],
            type: 'unique',
            name: 'unique_user_cage_number'
        });

        // Add user_id to feeds
        await queryInterface.addColumn('feeds', 'user_id', {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 1,
            references: { model: 'users', key: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });
        await queryInterface.addIndex('feeds', ['user_id']);
        await queryInterface.addConstraint('feeds', {
            fields: ['user_id', 'name'],
            type: 'unique',
            name: 'unique_user_feed_name'
        });

        // Add user_id to breedings
        await queryInterface.addColumn('breedings', 'user_id', {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 1,
            references: { model: 'users', key: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });
        await queryInterface.addIndex('breedings', ['user_id']);
    },

    down: async (queryInterface, Sequelize) => {
        await queryInterface.removeConstraint('feeds', 'unique_user_feed_name');
        await queryInterface.removeColumn('feeds', 'user_id');

        await queryInterface.removeConstraint('cages', 'unique_user_cage_number');
        await queryInterface.removeColumn('cages', 'user_id');

        await queryInterface.removeColumn('breedings', 'user_id');
    }
};
