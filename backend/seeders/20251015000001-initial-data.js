'use strict';
const bcrypt = require('bcrypt');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Hash password for default user
    const passwordHash = await bcrypt.hash('admin123', 10);

    // Insert users
    await queryInterface.bulkInsert('users', [
      {
        email: 'admin@rabbitfarm.com',
        password_hash: passwordHash,
        full_name: 'Администратор',
        role: 'owner',
        phone: '+79991234567',
        is_active: true,
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        email: 'manager@rabbitfarm.com',
        password_hash: await bcrypt.hash('manager123', 10),
        full_name: 'Менеджер фермы',
        role: 'manager',
        phone: '+79991234568',
        is_active: true,
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        email: 'worker@rabbitfarm.com',
        password_hash: await bcrypt.hash('worker123', 10),
        full_name: 'Работник',
        role: 'worker',
        phone: '+79991234569',
        is_active: true,
        created_at: new Date(),
        updated_at: new Date()
      }
    ], {});

    // Insert breeds
    await queryInterface.bulkInsert('breeds', [
      {
        name: 'Калифорнийская',
        user_id: 1,
        description: 'Мясная порода кроликов с белым окрасом и темными ушами, лапами и носом. Отличается быстрым набором веса.',
        average_weight: 4.5,
        average_litter_size: 8,
        purpose: 'meat',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Новозеландская белая',
        user_id: 1,
        description: 'Популярная мясная порода с чисто белым окрасом. Быстро растет и дает хорошее мясо.',
        average_weight: 5.0,
        average_litter_size: 9,
        purpose: 'meat',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Советская шиншилла',
        user_id: 1,
        description: 'Мясо-шкурковая порода с серебристо-голубым окрасом. Ценится за качественный мех.',
        average_weight: 5.0,
        average_litter_size: 8,
        purpose: 'combined',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Серый великан',
        user_id: 1,
        description: 'Крупная порода кроликов серого окраса. Вынослива и неприхотлива в содержании.',
        average_weight: 6.0,
        average_litter_size: 8,
        purpose: 'combined',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Фландр (Бельгийский великан)',
        user_id: 1,
        description: 'Одна из самых крупных пород кроликов. Спокойный темперамент, крупное телосложение.',
        average_weight: 7.0,
        average_litter_size: 7,
        purpose: 'meat',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Рекс',
        user_id: 1,
        description: 'Порода с уникальным велюровым мехом. Среднего размера, спокойный характер.',
        average_weight: 4.0,
        average_litter_size: 6,
        purpose: 'fur',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Венский голубой',
        user_id: 1,
        description: 'Мясо-шкурковая порода с красивым серо-голубым окрасом. Качественный мех и вкусное мясо.',
        average_weight: 4.5,
        average_litter_size: 8,
        purpose: 'combined',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Белый великан',
        user_id: 1,
        description: 'Крупная порода белого цвета. Альбиносы с красными глазами. Хорошие мясные качества.',
        average_weight: 5.5,
        average_litter_size: 7,
        purpose: 'combined',
        created_at: new Date(),
        updated_at: new Date()
      }
    ], {});

    // Insert cages
    await queryInterface.bulkInsert('cages', [
      {
        number: 'A1',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция А, ряд 1',
        condition: 'good',
        last_cleaned_at: new Date(),
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'A2',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция А, ряд 1',
        condition: 'good',
        last_cleaned_at: new Date(),
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'A3',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция А, ряд 1',
        condition: 'good',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'B1',
        type: 'maternity',
        size: '80x100x50',
        capacity: 1,
        location: 'Секция Б, ряд 1',
        condition: 'good',
        notes: 'Маточник для окролов',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'B2',
        type: 'maternity',
        size: '80x100x50',
        capacity: 1,
        location: 'Секция Б, ряд 1',
        condition: 'good',
        notes: 'Маточник для окролов',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'C1',
        type: 'group',
        size: '150x120x60',
        capacity: 5,
        location: 'Секция В, ряд 1',
        condition: 'good',
        notes: 'Для молодняка после отсадки',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'C2',
        type: 'group',
        size: '150x120x60',
        capacity: 5,
        location: 'Секция В, ряд 1',
        condition: 'good',
        notes: 'Для молодняка после отсадки',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'D1',
        type: 'single',
        size: '60x80x45',
        capacity: 1,
        location: 'Секция Г, ряд 1',
        condition: 'needs_repair',
        notes: 'Требуется ремонт дверцы',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'E1',
        type: 'single',
        size: '70x90x50',
        capacity: 1,
        location: 'Секция Д, ряд 1',
        condition: 'good',
        notes: 'Увеличенная клетка для крупных пород',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        number: 'E2',
        type: 'single',
        size: '70x90x50',
        capacity: 1,
        location: 'Секция Д, ряд 1',
        condition: 'good',
        notes: 'Увеличенная клетка для крупных пород',
        created_at: new Date(),
        updated_at: new Date()
      }
    ], {});

    // Insert feeds
    await queryInterface.bulkInsert('feeds', [
      {
        name: 'Комбикорм для кроликов ПК-90',
        type: 'pellets',
        brand: 'Провими',
        unit: 'kg',
        current_stock: 150.00,
        min_stock: 50.00,
        cost_per_unit: 45.00,
        notes: 'Основной комбикорм для взрослых кроликов',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Сено луговое',
        type: 'hay',
        brand: null,
        unit: 'kg',
        current_stock: 200.00,
        min_stock: 80.00,
        cost_per_unit: 15.00,
        notes: 'Качественное сено с лугов',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Морковь',
        type: 'vegetables',
        brand: null,
        unit: 'kg',
        current_stock: 30.00,
        min_stock: 10.00,
        cost_per_unit: 25.00,
        notes: 'Сочный корм',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Овёс',
        type: 'grain',
        brand: null,
        unit: 'kg',
        current_stock: 50.00,
        min_stock: 20.00,
        cost_per_unit: 18.00,
        notes: 'Зерновая подкормка',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Витаминная добавка "Ушастик"',
        type: 'supplements',
        brand: 'Агроветзащита',
        unit: 'kg',
        current_stock: 5.00,
        min_stock: 2.00,
        cost_per_unit: 350.00,
        notes: 'Витаминно-минеральная добавка',
        created_at: new Date(),
        updated_at: new Date()
      },
      {
        name: 'Соль-лизунец',
        type: 'supplements',
        brand: null,
        unit: 'piece',
        current_stock: 10.00,
        min_stock: 5.00,
        cost_per_unit: 50.00,
        notes: 'Минеральная подкормка',
        created_at: new Date(),
        updated_at: new Date()
      }
    ], {});

    console.log('✅ Seed data inserted successfully!');
    console.log('📧 Default users:');
    console.log('   - admin@rabbitfarm.com / admin123 (Owner)');
    console.log('   - manager@rabbitfarm.com / manager123 (Manager)');
    console.log('   - worker@rabbitfarm.com / worker123 (Worker)');
    console.log('🐰 8 breeds inserted');
    console.log('🏠 10 cages inserted');
    console.log('🌾 6 feed types inserted');
  },

  down: async (queryInterface, Sequelize) => {
    // Delete in reverse order to respect foreign keys
    await queryInterface.bulkDelete('feeds', null, {});
    await queryInterface.bulkDelete('cages', null, {});
    await queryInterface.bulkDelete('breeds', null, {});
    await queryInterface.bulkDelete('users', null, {});
  }
};
