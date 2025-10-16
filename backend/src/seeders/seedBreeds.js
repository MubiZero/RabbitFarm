const { Breed } = require('../models');

async function seedBreeds() {
  try {
    // Check if breeds already exist
    const count = await Breed.count();
    if (count > 0) {
      console.log('Breeds already exist. Skipping seeding.');
      return;
    }

    // Create breeds
    const breeds = [
      {
        name: 'Калифорнийская',
        description: 'Порода средних размеров, выведена в Калифорнии (США). Характеризуется белым окрасом с черными ушами, носом, лапами и хвостом.',
        average_weight: 4.5,
        average_litter_size: 8,
        purpose: 'combined'
      },
      {
        name: 'Новозеландская белая',
        description: 'Мясная порода кроликов с белоснежной шкуркой. Отличается быстрым ростом и хорошими мясными качествами.',
        average_weight: 5.0,
        average_litter_size: 9,
        purpose: 'meat'
      },
      {
        name: 'Советская шиншилла',
        description: 'Крупная порода кроликов с красивым серебристо-серым мехом. Универсального направления.',
        average_weight: 5.5,
        average_litter_size: 8,
        purpose: 'combined'
      },
      {
        name: 'Серый великан',
        description: 'Одна из самых крупных пород кроликов. Неприхотливы, хорошо приспосабливаются к климату.',
        average_weight: 6.0,
        average_litter_size: 8,
        purpose: 'combined'
      },
      {
        name: 'Фландр (Бельгийский великан)',
        description: 'Самая крупная порода кроликов. Спокойный характер, хорошо подходит как декоративная порода.',
        average_weight: 7.0,
        average_litter_size: 7,
        purpose: 'combined'
      },
      {
        name: 'Рекс',
        description: 'Порода с короткой бархатистой шерстью. Ценится за красивый мех и диетическое мясо.',
        average_weight: 4.0,
        average_litter_size: 6,
        purpose: 'fur'
      },
      {
        name: 'Белый великан',
        description: 'Крупная порода с чисто-белым окрасом. Хорошие мясные и шкурковые качества.',
        average_weight: 5.5,
        average_litter_size: 7,
        purpose: 'combined'
      },
      {
        name: 'Черно-бурый',
        description: 'Оригинальная отечественная порода с красивым черно-бурым окрасом.',
        average_weight: 5.0,
        average_litter_size: 8,
        purpose: 'combined'
      }
    ];

    await Breed.bulkCreate(breeds);
    console.log(`Successfully seeded ${breeds.length} breeds!`);
  } catch (error) {
    console.error('Error seeding breeds:', error);
    throw error;
  }
}

module.exports = seedBreeds;

// Run if called directly
if (require.main === module) {
  const { sequelize } = require('../models');

  seedBreeds()
    .then(() => {
      console.log('Seeding completed!');
      return sequelize.close();
    })
    .then(() => {
      process.exit(0);
    })
    .catch((error) => {
      console.error('Seeding failed:', error);
      process.exit(1);
    });
}
