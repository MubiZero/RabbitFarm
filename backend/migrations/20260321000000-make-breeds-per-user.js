'use strict';

/**
 * Породы становятся пер-фермерскими.
 *
 * Кролики, клетки, корма и случки уже разделены по user_id, а породы
 * оставались общим справочником: любой владелец мог удалить чужую породу,
 * а имя было уникально глобально — второй фермер не мог завести
 * «Новозеландского белого», если тот уже существовал у первого.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        // defaultValue нужен только чтобы заполнить уже существующие строки:
        // NOT NULL без него не добавить. Сразу после заполнения снимаем его,
        // иначе забытый user_id молча припишет породу первому пользователю.
        await queryInterface.addColumn('breeds', 'user_id', {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 1,
            references: { model: 'users', key: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });
        await queryInterface.sequelize.query(
            'ALTER TABLE `breeds` ALTER COLUMN `user_id` DROP DEFAULT'
        );

        // Глобальная уникальность имени больше не нужна и мешает: она
        // создана инлайном в createTable и называется просто `name`.
        await queryInterface.removeIndex('breeds', 'name');

        await queryInterface.addIndex('breeds', ['user_id']);
        await queryInterface.addConstraint('breeds', {
            fields: ['user_id', 'name'],
            type: 'unique',
            name: 'unique_user_breed_name'
        });
    },

    down: async (queryInterface, Sequelize) => {
        await queryInterface.removeConstraint('breeds', 'unique_user_breed_name');
        await queryInterface.removeColumn('breeds', 'user_id');

        // Возвращаем глобальную уникальность под прежним именем.
        await queryInterface.addIndex('breeds', ['name'], {
            unique: true,
            name: 'name'
        });
    }
};
