'use strict';
const bcrypt = require('bcrypt');
const { QueryTypes } = require('sequelize');

/**
 * Демонстрационный набор данных для разработки: три учётные записи с
 * заранее известными паролями, восемь пород, десять клеток и шесть кормов.
 *
 * Это НЕ справочники. В docker-compose и в DEPLOY.md флаг RUN_SEEDS был описан
 * как «залить справочники», из-за чего его легко включить на боевом стенде — и
 * получить владельца фермы с паролем, опубликованным в репозитории. Поэтому
 * сидер жёстко отказывается работать в продакшене.
 */
const assertNotProduction = () => {
  if (process.env.NODE_ENV === 'production') {
    throw new Error(
      'Демо-данные не заливаются в продакшен: сидер создаёт учётные записи ' +
      'с общеизвестными паролями. Уберите RUN_SEEDS или смените NODE_ENV.'
    );
  }
};

const OWNER_EMAIL = 'admin@rabbitfarm.com';
const FARM_NAME = 'Демонстрационная ферма';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    assertNotProduction();

    const now = () => new Date();

    const findUserIdByEmail = async (email) => {
      const [row] = await queryInterface.sequelize.query(
        'SELECT id FROM users WHERE email = :email LIMIT 1',
        { replacements: { email }, type: QueryTypes.SELECT }
      );
      return row ? row.id : null;
    };

    /**
     * Заводит демо-пользователя, если его ещё нет.
     *
     * Сидер запускают повторно — на уже залитом стенде (RUN_SEEDS=true при
     * каждом старте контейнера) вторая попытка не должна падать на уникальном
     * email и плодить дубли. Поэтому существующая запись не пересоздаётся,
     * а только доводится до нужной фермы: на стендах, залитых старой версией
     * сидера, менеджер и работник остались владельцами собственных пустых ферм.
     */
    const ensureUser = async ({ email, password, fullName, role, phone, farmId }) => {
      const existingId = await findUserIdByEmail(email);

      if (existingId) {
        await queryInterface.bulkUpdate('users', { farm_id: farmId, updated_at: now() }, { id: existingId });
        return existingId;
      }

      await queryInterface.bulkInsert('users', [{
        email,
        password_hash: await bcrypt.hash(password, 10),
        full_name: fullName,
        role,
        phone,
        farm_id: farmId,
        is_active: true,
        created_at: now(),
        updated_at: now()
      }], {});

      return findUserIdByEmail(email);
    };

    /**
     * Демо-ферма. Заводится до людей и поначалу без владельца: хозяйство и
     * хозяин ссылаются друг на друга, поэтому появляются по очереди.
     */
    const ensureFarm = async () => {
      const [existing] = await queryInterface.sequelize.query(
        'SELECT id FROM farms WHERE name = :name LIMIT 1',
        { replacements: { name: FARM_NAME }, type: QueryTypes.SELECT }
      );
      if (existing) return existing.id;

      await queryInterface.bulkInsert('farms', [{
        name: FARM_NAME,
        owner_id: null,
        created_at: now(),
        updated_at: now()
      }], {});

      const [created] = await queryInterface.sequelize.query(
        'SELECT id FROM farms WHERE name = :name LIMIT 1',
        { replacements: { name: FARM_NAME }, type: QueryTypes.SELECT }
      );
      return created.id;
    };

    /** Демо-справочник фермы заливается один раз: ферма с записями не трогается. */
    const seedFarmTable = async (table, rows) => {
      const [{ count }] = await queryInterface.sequelize.query(
        `SELECT COUNT(*) AS count FROM ${table} WHERE farm_id = :farmId`,
        { replacements: { farmId }, type: QueryTypes.SELECT }
      );
      if (Number(count) > 0) return 0;

      await queryInterface.bulkInsert(
        table,
        rows.map((row) => ({ ...row, farm_id: farmId, created_at: now(), updated_at: now() })),
        {}
      );
      return rows.length;
    };

    // Все трое — люди одной фермы, иначе роли не проверить: раньше каждый
    // входил в собственное пустое хозяйство.
    const farmId = await ensureFarm();

    const ownerId = await ensureUser({
      email: OWNER_EMAIL,
      password: 'admin123',
      fullName: 'Администратор',
      role: 'owner',
      phone: '+79991234567',
      farmId
    });

    await queryInterface.bulkUpdate('farms', { owner_id: ownerId, updated_at: now() }, { id: farmId });

    await ensureUser({
      email: 'manager@rabbitfarm.com',
      password: 'manager123',
      fullName: 'Менеджер фермы',
      role: 'manager',
      phone: '+79991234568',
      farmId
    });

    await ensureUser({
      email: 'worker@rabbitfarm.com',
      password: 'worker123',
      fullName: 'Работник',
      role: 'worker',
      phone: '+79991234569',
      farmId
    });

    const breedsInserted = await seedFarmTable('breeds', [
      {
        name: 'Калифорнийская',
        description: 'Мясная порода кроликов с белым окрасом и темными ушами, лапами и носом. Отличается быстрым набором веса.',
        average_weight: 4.5,
        average_litter_size: 8,
        purpose: 'meat'
      },
      {
        name: 'Новозеландская белая',
        description: 'Популярная мясная порода с чисто белым окрасом. Быстро растет и дает хорошее мясо.',
        average_weight: 5.0,
        average_litter_size: 9,
        purpose: 'meat'
      },
      {
        name: 'Советская шиншилла',
        description: 'Мясо-шкурковая порода с серебристо-голубым окрасом. Ценится за качественный мех.',
        average_weight: 5.0,
        average_litter_size: 8,
        purpose: 'combined'
      },
      {
        name: 'Серый великан',
        description: 'Крупная порода кроликов серого окраса. Вынослива и неприхотлива в содержании.',
        average_weight: 6.0,
        average_litter_size: 8,
        purpose: 'combined'
      },
      {
        name: 'Фландр (Бельгийский великан)',
        description: 'Одна из самых крупных пород кроликов. Спокойный темперамент, крупное телосложение.',
        average_weight: 7.0,
        average_litter_size: 7,
        purpose: 'meat'
      },
      {
        name: 'Рекс',
        description: 'Порода с уникальным велюровым мехом. Среднего размера, спокойный характер.',
        average_weight: 4.0,
        average_litter_size: 6,
        purpose: 'fur'
      },
      {
        name: 'Венский голубой',
        description: 'Мясо-шкурковая порода с красивым серо-голубым окрасом. Качественный мех и вкусное мясо.',
        average_weight: 4.5,
        average_litter_size: 8,
        purpose: 'combined'
      },
      {
        name: 'Белый великан',
        description: 'Крупная порода белого цвета. Альбиносы с красными глазами. Хорошие мясные качества.',
        average_weight: 5.5,
        average_litter_size: 7,
        purpose: 'combined'
      }
    ]);

    const cagesInserted = await seedFarmTable('cages', [
      {
        number: 'A1',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция А, ряд 1',
        condition: 'good',
        last_cleaned_at: now()
      },
      {
        number: 'A2',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция А, ряд 1',
        condition: 'good',
        last_cleaned_at: now()
      },
      {
        number: 'A3',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция А, ряд 1',
        condition: 'good'
      },
      {
        number: 'B1',
        type: 'maternity',
        size: '80x100x50',
        capacity: 1,
        location: 'Секция Б, ряд 1',
        condition: 'good',
        notes: 'Маточник для окролов'
      },
      {
        number: 'B2',
        type: 'maternity',
        size: '80x100x50',
        capacity: 1,
        location: 'Секция Б, ряд 1',
        condition: 'good',
        notes: 'Маточник для окролов'
      },
      {
        number: 'C1',
        type: 'group',
        size: '150x120x60',
        capacity: 5,
        location: 'Секция В, ряд 1',
        condition: 'good',
        notes: 'Для молодняка после отсадки'
      },
      {
        number: 'C2',
        type: 'group',
        size: '150x120x60',
        capacity: 5,
        location: 'Секция В, ряд 1',
        condition: 'good',
        notes: 'Для молодняка после отсадки'
      },
      {
        number: 'D1',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция Г, ряд 1',
        condition: 'needs_repair',
        notes: 'Требуется ремонт дверцы'
      },
      {
        number: 'E1',
        type: 'single',
        size: '70x90x50',
        capacity: 1,
        location: 'Секция Д, ряд 1',
        condition: 'good',
        notes: 'Увеличенная клетка для крупных пород'
      },
      {
        number: 'E2',
        type: 'single',
        size: '70x90x50',
        capacity: 1,
        location: 'Секция Д, ряд 1',
        condition: 'good',
        notes: 'Увеличенная клетка для крупных пород'
      }
    ]);

    const feedsInserted = await seedFarmTable('feeds', [
      {
        name: 'Комбикорм для кроликов ПК-90',
        type: 'pellets',
        brand: 'Провими',
        unit: 'kg',
        current_stock: 150.00,
        min_stock: 50.00,
        cost_per_unit: 45.00,
        notes: 'Основной комбикорм для взрослых кроликов'
      },
      {
        name: 'Сено луговое',
        type: 'hay',
        brand: null,
        unit: 'kg',
        current_stock: 200.00,
        min_stock: 80.00,
        cost_per_unit: 15.00,
        notes: 'Качественное сено с лугов'
      },
      {
        name: 'Морковь',
        type: 'vegetables',
        brand: null,
        unit: 'kg',
        current_stock: 30.00,
        min_stock: 10.00,
        cost_per_unit: 25.00,
        notes: 'Сочный корм'
      },
      {
        name: 'Овёс',
        type: 'grain',
        brand: null,
        unit: 'kg',
        current_stock: 50.00,
        min_stock: 20.00,
        cost_per_unit: 18.00,
        notes: 'Зерновая подкормка'
      },
      {
        name: 'Витаминная добавка "Ушастик"',
        type: 'supplements',
        brand: 'Агроветзащита',
        unit: 'kg',
        current_stock: 5.00,
        min_stock: 2.00,
        cost_per_unit: 350.00,
        notes: 'Витаминно-минеральная добавка'
      },
      {
        name: 'Соль-лизунец',
        type: 'supplements',
        brand: null,
        unit: 'piece',
        current_stock: 10.00,
        min_stock: 5.00,
        cost_per_unit: 50.00,
        notes: 'Минеральная подкормка'
      }
    ]);

    console.log('✅ Seed data inserted successfully!');
    console.log('📧 Default users:');
    console.log('   - admin@rabbitfarm.com / admin123 (Owner)');
    console.log('   - manager@rabbitfarm.com / manager123 (Manager, сотрудник фермы владельца)');
    console.log('   - worker@rabbitfarm.com / worker123 (Worker, сотрудник фермы владельца)');
    console.log(`🐰 ${breedsInserted} breeds inserted`);
    console.log(`🏠 ${cagesInserted} cages inserted`);
    console.log(`🌾 ${feedsInserted} feed types inserted`);
  },

  down: async (queryInterface, Sequelize) => {
    assertNotProduction();

    // Delete in reverse order to respect foreign keys
    await queryInterface.bulkDelete('feeds', null, {});
    await queryInterface.bulkDelete('cages', null, {});
    await queryInterface.bulkDelete('breeds', null, {});
    await queryInterface.bulkDelete('users', null, {});
  }
};
