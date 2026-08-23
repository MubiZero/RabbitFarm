'use strict';

/**
 * Связь автоматического расхода с записью, которая его породила.
 *
 * Медицинская запись и вакцинация со стоимостью создают расход, но обратной
 * ссылки не было. Поэтому при правке стоимости расход не пересчитывался
 * (нужную транзакцию было нечем найти), а при удалении записи он оставался в
 * ведомости сиротой — с описанием, ссылающимся на лечение, которого больше
 * нет. CASCADE выбран осознанно: такой расход принадлежит записи и без неё
 * смысла не имеет; самостоятельные расходы владелец заводит вручную и они
 * не затрагиваются.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.addColumn('transactions', 'medical_record_id', {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: { model: 'medical_records', key: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE',
            comment: 'Расход создан автоматически из медицинской записи'
        });

        await queryInterface.addColumn('transactions', 'vaccination_id', {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: { model: 'vaccinations', key: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE',
            comment: 'Расход создан автоматически из записи о вакцинации'
        });
    },

    down: async (queryInterface) => {
        await queryInterface.removeColumn('transactions', 'vaccination_id');
        await queryInterface.removeColumn('transactions', 'medical_record_id');
    }
};
