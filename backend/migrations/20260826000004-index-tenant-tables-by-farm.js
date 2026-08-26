'use strict';

/**
 * Индексы под запрос, который теперь делает каждый экран.
 *
 * После разделения по хозяйствам любая выборка начинается с `farm_id`, а
 * дальше идёт то, что нужно экрану: статус, дата, вид. Существующие индексы
 * построены только по второй части — по одной дате или одному статусу на всю
 * таблицу. Пока клиент один, это одно и то же. Когда клиентов сотня, MySQL
 * по такому индексу поднимает строки всех ферм и отбрасывает чужие уже после
 * чтения: чем больше сервис, тем медленнее работает каждый.
 *
 * Составной индекс, где `farm_id` идёт первым, отсекает чужое до чтения.
 */
const INDEXES = [
    ['rabbits', ['farm_id', 'status'], 'idx_rabbits_farm_status'],
    ['rabbits', ['farm_id', 'cage_id'], 'idx_rabbits_farm_cage'],
    ['rabbits', ['farm_id', 'breed_id'], 'idx_rabbits_farm_breed'],
    ['cages', ['farm_id', 'condition'], 'idx_cages_farm_condition'],
    ['breedings', ['farm_id', 'status'], 'idx_breedings_farm_status'],
    ['breedings', ['farm_id', 'expected_birth_date'], 'idx_breedings_farm_expected'],
    ['births', ['farm_id', 'birth_date'], 'idx_births_farm_date'],
    ['tasks', ['farm_id', 'status', 'due_date'], 'idx_tasks_farm_status_due'],
    ['tasks', ['farm_id', 'assigned_to'], 'idx_tasks_farm_assignee'],
    ['transactions', ['farm_id', 'transaction_date'], 'idx_transactions_farm_date'],
    ['transactions', ['farm_id', 'type', 'transaction_date'], 'idx_transactions_farm_type_date'],
    ['feeding_records', ['farm_id', 'fed_at'], 'idx_feeding_farm_fed_at'],
    ['vaccinations', ['farm_id', 'next_vaccination_date'], 'idx_vaccinations_farm_next'],
    ['vaccinations', ['farm_id', 'vaccination_date'], 'idx_vaccinations_farm_date'],
    ['medical_records', ['farm_id', 'started_at'], 'idx_medical_farm_started'],
    ['medical_records', ['farm_id', 'outcome'], 'idx_medical_farm_outcome'],
    ['rabbit_weights', ['farm_id', 'rabbit_id'], 'idx_weights_farm_rabbit'],
    ['photos', ['farm_id', 'rabbit_id'], 'idx_photos_farm_rabbit'],
    ['notes', ['farm_id', 'rabbit_id'], 'idx_notes_farm_rabbit']
];

module.exports = {
    up: async (queryInterface) => {
        for (const [table, fields, name] of INDEXES) {
            await queryInterface.addIndex(table, fields, { name });
        }
    },

    down: async (queryInterface) => {
        for (const [table, , name] of INDEXES) {
            // Откат должен переживать повтор: DDL в MySQL не транзакционен,
            // и прерванный посередине откат оставляет часть индексов снятой.
            const indexes = await queryInterface.showIndex(table);
            if (!indexes.some((index) => index.name === name)) continue;
            await queryInterface.removeIndex(table, name);
        }
    }
};
