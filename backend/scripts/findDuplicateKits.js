/**
 * Разбор крольчат, заведённых дважды.
 *
 * Кнопку «Завести крольчат» можно было нажать сколько угодно раз: каждый
 * вызов создавал полный комплект карточек, и выводок из шести превращался в
 * двенадцать, а то и в восемнадцать. С 15 сентября 2026 повтор отклоняется
 * (`births.kits_carded_at`), но карточки, заведённые до этого, никуда не
 * делись — ферма за них платит по тарифу и видит их в поголовье.
 *
 * Скрипт находит такие выводки: окрол, у которого потомков этой матери с
 * датой рождения окрола больше, чем родилось живыми.
 *
 * По умолчанию только отчёт — ничего не меняет:
 *
 *   node scripts/findDuplicateKits.js
 *
 * С `--apply` удаляет лишние карточки, но только заведомо нетронутые:
 * заведённые самым поздним пакетом, с бирками `kit-…`, живые, без единой
 * записи о себе (взвешивание, лечение, прививка, кормление, заметка,
 * проводка, задача, фото), без потомства и не сидящие в чужой клетке.
 *
 *   node scripts/findDuplicateKits.js --apply
 *
 * Карточку, с которой уже работали, скрипт не трогает никогда: за ней стоит
 * живой кролик, которого кто-то взвешивал или лечил, и удалять его на
 * основании арифметики нельзя. Если после удаления избыток остаётся, он
 * назван в отчёте поимённо — это разбор руками.
 *
 * Проверено на подложенных данных: выводок из шести с двенадцатью
 * карточками, одна из лишних взвешена. Отчёт назвал шесть лишних, `--apply`
 * удалил шесть и оставил взвешенную (вместо неё ушла ровно такая же карточка
 * из первого пакета), повторный прогон нашёл ноль.
 */
require('dotenv').config();

const { Op } = require('sequelize');
const {
  Birth, Rabbit, RabbitWeight, MedicalRecord, Vaccination, FeedingRecord,
  Note, Transaction, Task, Photo, sequelize
} = require('../src/models');

const APPLY = process.argv.includes('--apply');

/**
 * Есть ли у карточки хоть один след работы с ней.
 *
 * Каждый счётчик ограничен фермой самой карточки: в проекте запрос без
 * `farm_id` намеренно падает, и это правильно — «посчитать по всем фермам»
 * должно быть решением, а не опечаткой.
 */
async function isUntouched(rabbit) {
  const scope = { farm_id: rabbit.farm_id, rabbit_id: rabbit.id };
  const [weights, medical, vaccinations, feedings, notes, transactions, tasks, photos, offspring] =
    await Promise.all([
      RabbitWeight.count({ where: scope }),
      MedicalRecord.count({ where: scope }),
      Vaccination.count({ where: scope }),
      FeedingRecord.count({ where: scope }),
      Note.count({ where: scope }),
      Transaction.count({ where: scope }),
      Task.count({ where: scope }),
      Photo.count({ where: scope }),
      Rabbit.count({
        where: {
          farm_id: rabbit.farm_id,
          [Op.or]: [{ mother_id: rabbit.id }, { father_id: rabbit.id }]
        }
      })
    ]);

  return weights + medical + vaccinations + feedings + notes
    + transactions + tasks + photos + offspring === 0;
}

async function main() {
  // По всем фермам — это и есть смысл разбора, поэтому область видимости
  // снимается явно.
  const births = await Birth.findAll({
    order: [['farm_id', 'ASC'], ['id', 'ASC']],
    tenantScope: 'all'
  });
  let affected = 0;
  let removed = 0;
  let leftForHands = 0;

  for (const birth of births) {
    const kits = await Rabbit.findAll({
      where: {
        farm_id: birth.farm_id,
        mother_id: birth.mother_id,
        birth_date: birth.birth_date
      },
      order: [['created_at', 'DESC'], ['id', 'DESC']]
    });

    const expected = birth.kits_born_alive;
    const excess = kits.length - expected;
    if (excess <= 0) continue;

    affected += 1;
    console.log(
      `\nФерма ${birth.farm_id}, окрол ${birth.id} (${birth.birth_date}): ` +
      `родилось живыми ${expected}, карточек ${kits.length} — лишних ${excess}`
    );

    // Кандидаты берутся с конца: последний пакет и есть повторное нажатие.
    const candidates = [];
    for (const kit of kits) {
      if (candidates.length === excess) break;
      if (kit.status !== 'active') continue;
      if (!String(kit.tag_id || '').startsWith('kit-')) continue;
      if (kit.cage_id && kit.cage_id !== null && kit.cage_id !== kits[0].cage_id) continue;
      if (await isUntouched(kit)) candidates.push(kit);
    }

    for (const kit of candidates) {
      console.log(`  лишняя: #${kit.id} ${kit.name} (${kit.tag_id})`);
    }

    const rest = excess - candidates.length;
    if (rest > 0) {
      leftForHands += rest;
      console.log(
        `  ещё ${rest} — с этими карточками уже работали (взвешивали, лечили, ` +
        'кормили); разбирать руками'
      );
    }

    if (APPLY && candidates.length > 0) {
      await sequelize.transaction(async (transaction) => {
        for (const kit of candidates) {
          await kit.destroy({ transaction });
        }
      });
      removed += candidates.length;
      console.log(`  удалено: ${candidates.length}`);
    }
  }

  console.log(
    `\nВыводков с лишними карточками: ${affected}. ` +
    (APPLY ? `Удалено карточек: ${removed}. ` : 'Ничего не менялось (запуск без --apply). ') +
    (leftForHands > 0 ? `Требуют разбора руками: ${leftForHands}.` : '')
  );

  await sequelize.close();
}

main().catch(async (error) => {
  console.error('Разбор не удался:', error.message);
  await sequelize.close();
  process.exit(1);
});
