'use strict';

/**
 * Снимаем глобальную уникальность номера клетки и бирки кролика.
 *
 * Обе взялись из createTable, когда система была однофермерской. Сейчас это
 * блокирует вторую ферму: номера клеток («А1») и ушные бирки («1», «2») на
 * разных фермах совпадают постоянно, а пользователь видит непонятную ошибку
 * сохранения. Породы через это уже прошли — 20260321000000 делает то же самое.
 */

/**
 * Инлайновый unique из createTable MySQL называет по имени колонки, но
 * полагаться на это на чужой базе нельзя — ищем индекс по факту.
 */
async function removeSingleColumnUnique(queryInterface, table, column) {
    const indexes = await queryInterface.showIndex(table);
    const target = indexes.find((index) =>
        index.unique &&
        index.fields.length === 1 &&
        index.fields[0].attribute === column &&
        index.name !== 'PRIMARY'
    );

    if (target) {
        await queryInterface.removeIndex(table, target.name);
    }
}

module.exports = {
    up: async (queryInterface) => {
        await removeSingleColumnUnique(queryInterface, 'cages', 'number');
        await removeSingleColumnUnique(queryInterface, 'rabbits', 'tag_id');

        // Уникальность бирки внутри фермы. NULL в MySQL считаются разными,
        // поэтому кролики без бирки друг другу не мешают.
        await queryInterface.addConstraint('rabbits', {
            fields: ['user_id', 'tag_id'],
            type: 'unique',
            name: 'unique_user_rabbit_tag'
        });
    },

    down: async (queryInterface) => {
        await queryInterface.removeConstraint('rabbits', 'unique_user_rabbit_tag');
        // Глобальные unique обратно не возвращаем: на данных нескольких ферм
        // они уже не создадутся, а тихо оставить схему без них честнее, чем
        // уронить откат.
    }
};
