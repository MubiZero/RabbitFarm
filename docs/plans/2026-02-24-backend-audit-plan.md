# Backend Audit Fix Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Исправить 21 находку из аудита (docs/plans/2026-02-24-backend-audit-findings.md) — от Critical до Low, сохраняя работоспособность всех 670 unit-тестов.

**Architecture:** Каждый таск — атомарный фикс одной проблемы. Сначала тест (unit в `tests/unit/`), потом фикс, потом commit. Не трогать то, что не сломано.

**Tech Stack:** Node.js/Express, Sequelize/MySQL, Jest (unit), Supertest (integration), Winston (logger)

**Findings Reference:** `docs/plans/2026-02-24-backend-audit-findings.md`

**Run tests:** `cd backend && npx jest --testPathPattern="unit" --no-coverage`

---

## SPRINT 1 — CRITICAL

---

### Task 1: Fix — Dashboard N+1 → Promise.all (Finding #2)

**Files:**
- Modify: `backend/src/controllers/reportController.js`
- Test: `backend/tests/unit/controllers/reportController.test.js`

**Context:** getDashboard() выполняет 15+ последовательных SQL-запросов. Минимальный fix — запустить их параллельно через Promise.all.

**Step 1: Прочитай текущий код getDashboard()**

```bash
# Посмотри на метод getDashboard в reportController.js
# Найди все Model.count(), Model.sum(), Model.findAll() вызовы
# Запомни их порядок и что они считают
```

**Step 2: Запусти существующие тесты — убедись что все проходят**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit/controllers/reportController" --no-coverage
```
Expected: все тесты PASS (или файл не существует — тогда просто 0 tests)

**Step 3: Открой reportController.js и найди getDashboard()**

Паттерн для замены: вместо последовательных `await`:
```javascript
// БЫЛО (последовательно):
const totalRabbits = await Rabbit.count({ where: { user_id } });
const aliveRabbits = await Rabbit.count({ where: { user_id, status: 'alive' } });
// ... ещё 13 запросов

// СТАЛО (параллельно):
const [
  totalRabbits,
  aliveRabbits,
  // ... все остальные
] = await Promise.all([
  Rabbit.count({ where: { user_id } }),
  Rabbit.count({ where: { user_id, status: 'alive' } }),
  // ... все остальные в том же порядке
]);
```

**Step 4: Примени рефакторинг**

Обернуть ВСЕ count/sum/findAll вызовы в getDashboard() в один Promise.all. Сохранить те же имена переменных — логика построения response не меняется.

**Step 5: Запусти тесты снова**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```
Expected: 670 PASS, 0 FAIL

**Step 6: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/reportController.js
git commit -m "perf(report): parallelize getDashboard queries with Promise.all

Replaces 15+ sequential SQL calls with single Promise.all, reducing
dashboard response time proportionally to slowest query instead of sum.

Fixes Finding #2 from backend audit."
```

---

### Task 2: Fix — Double stock deduction в feedingRecordController (Finding #1)

**Files:**
- Modify: `backend/src/controllers/feedingRecordController.js`
- Test: `backend/tests/unit/controllers/feedingRecordController.test.js`

**Context:** В методе `update()` stock adjustments происходят дважды: первый раз вне транзакции (строки ~248-279), второй — внутри (строки ~291-341). При ошибке транзакции — stock уходит не туда.

**Step 1: Прочитай метод update() в feedingRecordController.js**

Найди:
- Первый блок изменения stock (ДО начала `t = await sequelize.transaction()`)
- Второй блок внутри transaction
- Разберись что делает каждый блок

**Step 2: Запусти тесты feedingRecord**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit/controllers/feedingRecordController" --no-coverage
```

**Step 3: Удали дублирующий блок stock adjustment ВНЕ транзакции**

Правило: весь stock adjustment происходит ТОЛЬКО внутри транзакции.
- Удали код изменения Feed.quantity/current_stock ДО `sequelize.transaction()`
- Оставь только логику внутри transaction
- Transaction должна: 1) получить старую запись с lock, 2) вычислить delta, 3) обновить stock, 4) обновить feedingRecord

**Step 4: Проверь что transaction правильно rollback-ается при ошибке**

В catch-блоке должен быть `await t.rollback()`. Убедись что он есть.

**Step 5: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```
Expected: 670 PASS

**Step 6: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/feedingRecordController.js
git commit -m "fix(feeding): remove duplicate stock adjustment outside transaction

update() was adjusting feed stock twice: once outside the transaction
and once inside. On transaction failure, stock was decremented without
record being updated, leading to phantom stock loss.

Fixes Finding #1 (Critical) from backend audit."
```

---

### Task 3: Fix — tag_id uniqueness при создании кролей из помёта (Finding #3)

**Files:**
- Modify: `backend/src/controllers/birthController.js`
- Test: `backend/tests/unit/controllers/birthController.test.js` (если нет — создать)

**Context:** `createKitsFromBirth()` генерирует tag_id через `Date.now() + index`. При batch-создании в одной миллисекунде — дублирующийся tag_id → unique constraint error.

**Step 1: Найди функцию createKitsFromBirth() в birthController.js**

Найди строку с генерацией tag_id, выглядит примерно как:
```javascript
tag_id: `kit-${Date.now()}-${i}`  // или похожее
```

**Step 2: Замени на crypto.randomUUID()**

Node.js 14.17+ имеет встроенный `crypto.randomUUID()`:
```javascript
const { randomUUID } = require('crypto');

// В цикле создания кролей:
tag_id: `kit-${randomUUID().slice(0, 8)}`
// Или просто:
tag_id: randomUUID()
```

Если уже есть `require('crypto')` в файле — использовать его. Если нет — добавить в начало файла.

**Step 3: Убедись что tag_id формат совместим с валидатором**

Найди `backend/src/validators/` файл для rabbits. Проверь Joi-схему для `tag_id` — если там есть `.pattern()` или `.max()` — убедись что UUID проходит.

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```
Expected: 670 PASS

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/birthController.js
git commit -m "fix(birth): use crypto.randomUUID() for kit tag_id generation

Date.now() + index caused duplicate tag_id when multiple kits were
created in the same millisecond, causing unique constraint violations.

Fixes Finding #3 (Critical) from backend audit."
```

---

## SPRINT 2 — HIGH BUSINESS LOGIC

---

### Task 4: Fix — getStatistics() загружает все записи в память (Finding #4)

**Files:**
- Modify: `backend/src/controllers/vaccinationController.js`
- Modify: `backend/src/controllers/medicalRecordController.js`

**Context:** `getStatistics()` использует `findAll()` + JS-цикл вместо SQL-агрегации. При 10k+ записях — OOM.

**Step 1: Прочитай getStatistics() в vaccinationController.js**

Найди паттерн: `const all = await Vaccination.findAll(...)` + `all.reduce(...)` или `all.forEach(...)`.

**Step 2: Замени на SQL-агрегацию в vaccinationController**

```javascript
// БЫЛО:
const vaccinations = await Vaccination.findAll({ include: [{ model: Rabbit, where: { user_id } }] });
const total = vaccinations.length;
const byVaccine = vaccinations.reduce(...);

// СТАЛО:
const [total, byVaccine] = await Promise.all([
  Vaccination.count({ include: [{ model: Rabbit, where: { user_id } }] }),
  Vaccination.findAll({
    attributes: [
      'vaccine_name',
      [sequelize.fn('COUNT', sequelize.col('id')), 'count']
    ],
    include: [{ model: Rabbit, where: { user_id }, attributes: [] }],
    group: ['vaccine_name'],
    raw: true
  })
]);
```

Адаптируй к реальной структуре метода — суть в замене `findAll` + JS-агрегации на `COUNT` + `GROUP BY` в SQL.

**Step 3: Применить тот же паттерн к medicalRecordController.js getStatistics()**

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/vaccinationController.js backend/src/controllers/medicalRecordController.js
git commit -m "perf(health): replace in-memory aggregation with SQL COUNT/GROUP BY

getStatistics() was loading all records into memory for JS aggregation.
Replaced with SQL-level COUNT + GROUP BY to handle large datasets.

Fixes Finding #4 (High) from backend audit."
```

---

### Task 5: Fix — getPedigree() stack overflow при циклических ссылках (Finding #5)

**Files:**
- Modify: `backend/src/services/rabbitService.js`
- Test: `backend/tests/unit/services/rabbitService.test.js` (добавить тест-кейс)

**Context:** Рекурсивный обход родословной без защиты от циклов → stack overflow.

**Step 1: Найди функцию getPedigree() в rabbitService.js**

Найди рекурсивный вызов — примерно:
```javascript
async function buildPedigree(rabbit, depth) {
  if (depth === 0) return rabbit;
  // рекурсивный вызов для father/mother
}
```

**Step 2: Добавь Set для отслеживания посещённых**

```javascript
// В начале публичного метода (не рекурсивного):
const visited = new Set();

// Передай visited в рекурсивную функцию:
async function buildPedigree(rabbitId, depth, visited) {
  if (depth === 0 || visited.has(rabbitId)) return null;
  visited.add(rabbitId);

  const rabbit = await Rabbit.findByPk(rabbitId, ...);
  if (!rabbit) return null;

  return {
    ...rabbit.toJSON(),
    father: rabbit.father_id ? await buildPedigree(rabbit.father_id, depth - 1, visited) : null,
    mother: rabbit.mother_id ? await buildPedigree(rabbit.mother_id, depth - 1, visited) : null,
  };
}
```

**Step 3: Напиши тест для циклической ссылки**

```javascript
// В tests/unit/services/rabbitService.test.js
it('should handle circular parent references without stack overflow', async () => {
  // Мокаем: rabbit A → father = rabbit B, rabbit B → father = rabbit A
  const mockRabbitA = { id: 1, father_id: 2, mother_id: null, toJSON: () => ({ id: 1 }) };
  const mockRabbitB = { id: 2, father_id: 1, mother_id: null, toJSON: () => ({ id: 2 }) };

  Rabbit.findByPk = jest.fn()
    .mockResolvedValueOnce(mockRabbitA)
    .mockResolvedValueOnce(mockRabbitB)
    .mockResolvedValueOnce(mockRabbitA); // circular!

  // Не должен упасть с stack overflow:
  await expect(rabbitService.getPedigree(1, 1, 3)).resolves.not.toThrow();
});
```

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```
Expected: все PASS включая новый тест

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/rabbitService.js backend/tests/unit/services/rabbitService.test.js
git commit -m "fix(rabbit): prevent stack overflow in getPedigree with circular refs

Added visited Set to track processed rabbit IDs during pedigree recursion.
Returns null for already-visited nodes instead of recursing infinitely.

Fixes Finding #5 (High) from backend audit."
```

---

### Task 6: Fix — kits_weaned обновляется при создании, а не при отъёме (Finding #7)

**Files:**
- Modify: `backend/src/controllers/birthController.js`

**Context:** `kits_weaned` поле Birth модели обновляется в `createKitsFromBirth()` сразу при создании кролей — это семантически неверно. Отъём (weaning) — отдельное событие.

**Step 1: Прочитай createKitsFromBirth() и найди обновление kits_weaned**

Найди строку вида: `await birth.update({ kits_weaned: birth.kits_weaned + count })` или похожее.

**Step 2: Удали обновление kits_weaned из createKitsFromBirth()**

Просто убери эту строку/блок. `kits_weaned` должен оставаться 0 при создании кролей.

**Step 3: Проверь — есть ли endpoint для weaning**

Посмотри `backend/src/routes/birth.routes.js`. Если нет `PUT /births/:id/wean` или похожего — это gap, который нужно отметить в комментарии к коду, но НЕ реализовывать сейчас (YAGNI для этого таска).

Добавь TODO-комментарий:
```javascript
// TODO: kits_weaned должен обновляться через отдельный weaning endpoint,
// а не при createKitsFromBirth. См. Finding #7 в backend-audit-findings.md
```

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/birthController.js
git commit -m "fix(birth): remove incorrect kits_weaned update on kit creation

kits_weaned was being set when creating rabbit records from birth,
but should only be set when weaning actually occurs (separate event).

Fixes Finding #7 (High) from backend audit."
```

---

### Task 7: Fix — only_available фильтр клеток в JS вместо SQL (Finding #9)

**Files:**
- Modify: `backend/src/services/cageService.js`

**Context:** `only_available` фильтр применяется через `Array.filter()` после получения всех клеток из БД, что ломает пагинацию и убивает производительность.

**Step 1: Найди в cageService.js метод listCages() или getCages()**

Найди строку вида: `cages = cages.filter(c => c.status === 'available')` или похожее.

**Step 2: Перенеси фильтр в WHERE условие Sequelize**

```javascript
// БЫЛО (post-query filter):
const cages = await Cage.findAll({ where: { user_id }, limit, offset });
const filtered = onlyAvailable ? cages.filter(c => c.status === 'available') : cages;

// СТАЛО (в query):
const where = { user_id };
if (onlyAvailable) where.status = 'available';

const { count, rows } = await Cage.findAndCountAll({
  where,
  limit,
  offset
});
```

Убедись что `Cage.findAndCountAll()` используется (не `findAll` + отдельный `count`), чтобы пагинация работала корректно с фильтром.

**Step 3: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 4: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/cageService.js
git commit -m "fix(cage): move only_available filter from JS to SQL WHERE clause

Post-query JS filtering broke pagination (requested 20, returned 5)
and fetched all records unnecessarily. Now filters at DB level.

Fixes Finding #9 (High) from backend audit."
```

---

## SPRINT 3 — HIGH SECURITY / INTEGRITY

---

### Task 8: Fix — Продажа кролика без проверки его статуса (Finding #6)

**Files:**
- Modify: `backend/src/services/transactionService.js`

**Context:** При создании транзакции с category='sale' — кролик помечается 'sold' без проверки что он жив и не продан ранее.

**Step 1: Найди в transactionService.js блок с обновлением rabbit.status**

Выглядит примерно:
```javascript
if (category?.toLowerCase() === 'sale' || ...) {
  await Rabbit.update({ status: 'sold' }, { where: { id: rabbit_id } });
}
```

**Step 2: Добавь проверку текущего статуса кролика**

```javascript
if (category?.toLowerCase() === 'sale' || category?.toLowerCase() === 'продажа') {
  if (data.rabbit_id) {
    const rabbit = await Rabbit.findOne({
      where: { id: data.rabbit_id, user_id: data.user_id }
    });
    if (!rabbit) throw new Error('RABBIT_NOT_FOUND');

    // Только если кролик живой и не уже продан:
    if (rabbit.status === 'alive') {
      await rabbit.update({ status: 'sold' }, { transaction: t });
    }
    // Если уже sold/died — не трогать, транзакцию всё равно создаём
  }
}
```

**Step 3: Убедись что это происходит внутри transaction (t)**

Обновление `rabbit.update()` должно быть в том же `t`, что и создание транзакции финансов.

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/transactionService.js
git commit -m "fix(transaction): check rabbit status before marking as sold

Sale transactions were blindly setting rabbit status to 'sold'
without checking if rabbit was already sold or deceased.
Now only updates status for alive rabbits.

Fixes Finding #6 (High) from backend audit."
```

---

### Task 9: Fix — updateTask() не валидирует assigned_to (Finding #10)

**Files:**
- Modify: `backend/src/services/taskService.js`

**Context:** `assigned_to` можно обновить до любого user_id без проверки существования пользователя.

**Step 1: Найди updateTask() в taskService.js**

Найди где обрабатывается поле `assigned_to` при update.

**Step 2: Добавь валидацию**

```javascript
if (data.assigned_to !== undefined && data.assigned_to !== null) {
  const User = require('../models').User;
  const assignee = await User.findByPk(data.assigned_to);
  if (!assignee) throw new Error('ASSIGNED_USER_NOT_FOUND');
}
```

**Step 3: Добавь ASSIGNED_USER_NOT_FOUND в обработку ошибок в taskController.js**

```javascript
// В catch блоке updateTask:
if (error.message === 'ASSIGNED_USER_NOT_FOUND') {
  return ApiResponse.notFound(res, 'Assigned user not found');
}
```

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/taskService.js backend/src/controllers/taskController.js
git commit -m "fix(task): validate assigned_to user exists on task update

Tasks could be assigned to non-existent user IDs silently.
Now validates the assignee user exists before updating.

Fixes Finding #10 (High) from backend audit."
```

---

### Task 10: Fix — Recurrence validation при completeTask (Finding #11)

**Files:**
- Modify: `backend/src/services/taskService.js`
- Modify: `backend/src/validators/taskValidator.js`

**Context:** Невалидный `recurrence_rule` при completeTask() — следующая задача молча не создаётся.

**Step 1: Найди RECURRENCE_OFFSETS объект в taskService.js**

Примерно: `const RECURRENCE_OFFSETS = { daily: 1, weekly: 7, monthly: 30 }` или похожее.

**Step 2: Добавь валидацию recurrence_rule в taskValidator.js**

```javascript
// В схеме создания задачи:
recurrence_rule: Joi.string().valid('daily', 'weekly', 'monthly', 'yearly').allow(null)
// (или те ключи что есть в RECURRENCE_OFFSETS)
```

**Step 3: В completeTask() — бросай ошибку при невалидном rule**

```javascript
if (task.recurrence_rule && !RECURRENCE_OFFSETS[task.recurrence_rule]) {
  throw new Error(`INVALID_RECURRENCE_RULE: ${task.recurrence_rule}`);
}
```

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/taskService.js backend/src/validators/taskValidator.js
git commit -m "fix(task): validate recurrence_rule at creation and on completion

Invalid recurrence rules were silently dropping recurring task creation.
Now validated at task creation via Joi, and throws on complete if invalid.

Fixes Finding #11 (High) from backend audit."
```

---

## SPRINT 4 — MEDIUM UX / CONTRACT

---

### Task 11: Fix — Статус кролика при создании медзаписи со смертью (Finding #12)

**Files:**
- Modify: `backend/src/controllers/medicalRecordController.js`

**Context:** При создании медзаписи с outcome='died'/'euthanized' — статус кролика не обновляется. Только при UPDATE.

**Step 1: Найди метод create() в medicalRecordController.js**

Найди блок который обрабатывает `outcome`.

**Step 2: Добавь обновление статуса кролика при create**

```javascript
// После успешного создания медзаписи:
if (['died', 'euthanized'].includes(data.outcome)) {
  await Rabbit.update(
    { status: data.outcome === 'died' ? 'died' : 'died' }, // адаптируй к реальным статусам
    { where: { id: data.rabbit_id }, transaction: t }
  );
}
```

Это должно быть внутри transaction если она используется, или с отдельным transaction если нет.

**Step 3: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 4: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/medicalRecordController.js
git commit -m "fix(health): auto-update rabbit status on medical record create

Creating a medical record with outcome 'died' or 'euthanized' now
immediately updates the rabbit's status, same as on update.

Fixes Finding #12 (Medium) from backend audit."
```

---

### Task 12: Fix — groupBy в getFinancialReport() (Finding #14)

**Files:**
- Modify: `backend/src/controllers/reportController.js`

**Context:** Параметр `groupBy` принимается но не применяется.

**Step 1: Найди getFinancialReport() в reportController.js**

Найди где `groupBy` извлекается из `req.query` но не используется.

**Step 2: Реализуй группировку или удали параметр**

**Вариант A (реализовать):**
```javascript
const groupBy = req.query.group_by || 'category'; // category | month | type

let groupAttribute;
if (groupBy === 'month') {
  groupAttribute = [sequelize.fn('DATE_FORMAT', sequelize.col('transaction_date'), '%Y-%m'), 'month'];
} else if (groupBy === 'type') {
  groupAttribute = ['type'];
} else {
  groupAttribute = ['category'];
}

const grouped = await Transaction.findAll({
  attributes: [
    ...groupAttribute,
    [sequelize.fn('SUM', sequelize.col('amount')), 'total'],
    [sequelize.fn('COUNT', sequelize.col('id')), 'count']
  ],
  where: { user_id, ...dateFilter },
  group: [groupAttribute[0]],
  raw: true
});
```

**Вариант B (убрать, если сложно):** Удали `groupBy` из query extraction и Swagger-документации. Чистый API лучше сломанного.

Выбери вариант A только если понимаешь схему. Иначе — B.

**Step 3: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 4: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/reportController.js
git commit -m "fix(report): implement groupBy in getFinancialReport

Parameter group_by was accepted but never applied. Now supports
grouping by category (default), month, or type.

Fixes Finding #14 (Medium) from backend audit."
```

---

### Task 13: Fix — Default date range в getFarmReport() (Finding #13)

**Files:**
- Modify: `backend/src/controllers/reportController.js`

**Step 1: Найди getFarmReport() в reportController.js**

Найди дефолтное значение для `date_from` (~'2020-01-01').

**Step 2: Замени на последние 30 дней**

```javascript
const now = new Date();
const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);

const date_from = req.query.date_from
  ? new Date(req.query.date_from)
  : thirtyDaysAgo;
const date_to = req.query.date_to
  ? new Date(req.query.date_to)
  : now;
```

**Step 3: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 4: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/reportController.js
git commit -m "fix(report): change default date range from 2020-01-01 to last 30 days

Hardcoded 2020 start date caused full-table scans on unflitered requests.
Default now uses last 30 days, which is also more useful for users.

Fixes Finding #13 (Medium) from backend audit."
```

---

### Task 14: Fix — Vaccination user filter в getByRabbit() (Finding #15)

**Files:**
- Modify: `backend/src/controllers/vaccinationController.js`

**Step 1: Найди getByRabbit() в vaccinationController.js**

**Step 2: Убедись что запрос вакцинаций включает user_id через rabbit relationship**

```javascript
const vaccinations = await Vaccination.findAll({
  include: [{
    model: Rabbit,
    where: { id: rabbitId, user_id: req.user.id }, // user_id обязателен
    attributes: []
  }]
});
```

Если `where: { user_id }` на Rabbit уже есть — всё хорошо, просто подтверди. Если нет — добавь.

**Step 3: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 4: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/controllers/vaccinationController.js
git commit -m "fix(vaccination): ensure user_id filter on getByRabbit query

getByRabbit validated rabbit ownership but didn't enforce user_id
in the vaccination JOIN, potentially leaking cross-user data.

Fixes Finding #15 (Medium) from backend audit."
```

---

## SPRINT 5 — LOW TECH-DEBT

---

### Task 15: Fix — runtime require → top-level import в feedService (Finding #17)

**Files:**
- Modify: `backend/src/services/feedService.js`

**Step 1: Найди в начале feedService.js блок импортов**

**Step 2: Найди `require('sequelize').col(` или `require('sequelize').fn(` внутри функций**

**Step 3: Добавь в начало файла**

```javascript
const { Op, col, fn, where } = require('sequelize');
// Или если Sequelize импортируется иначе:
const Sequelize = require('sequelize');
```

**Step 4: Замени `require('sequelize').col(` на `col(` везде в файле**

**Step 5: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 6: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/feedService.js
git commit -m "refactor(feed): move Sequelize.col() to top-level import

Runtime require() inside functions is an anti-pattern - it prevents
tree-shaking and makes dependencies unclear. Moved to module top.

Fixes Finding #17 (Low) from backend audit."
```

---

### Task 16: Fix — console.warn → logger в feedingRecordController (Finding #18)

**Files:**
- Modify: `backend/src/controllers/feedingRecordController.js`

**Step 1: Найди `console.warn(` в feedingRecordController.js**

**Step 2: Проверь как logger импортируется в других контроллерах**

```bash
grep -n "require.*logger\|require.*winston" /mnt/d/projects/RabbitFarm/RabbitFarm/backend/src/controllers/*.js | head -5
```

**Step 3: Добавь тот же import logger в начало feedingRecordController.js (если не импортирован)**

**Step 4: Замени `console.warn(` на `logger.warn(`**

**Step 5: Запусти тесты + commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
git add backend/src/controllers/feedingRecordController.js
git commit -m "fix(feeding): replace console.warn with logger.warn

Ensures warning logs appear in Winston log files and follow
consistent logging patterns across the application.

Fixes Finding #18 (Low) from backend audit."
```

---

### Task 17: Fix — Case-insensitive поиск кроликов (Finding #19)

**Files:**
- Modify: `backend/src/services/rabbitService.js`

**Step 1: Найди listRabbits() в rabbitService.js**

Найди блок поиска: `name: { [Op.like]: '%search%' }`.

**Step 2: Замени на case-insensitive вариант для MySQL**

```javascript
const { Op, fn, col, where: seqWhere } = require('sequelize');

// Вместо:
name: { [Op.like]: `%${search}%` }

// Для MySQL (case-insensitive через LOWER):
seqWhere(fn('LOWER', col('name')), { [Op.like]: `%${search.toLowerCase()}%` })
```

Или если MySQL настроен с case-insensitive collation (utf8_general_ci) — `Op.like` уже работает корректно. Проверь коллацию в `migrations/` или `config/database.js`.

Если коллация уже ci — просто добавь комментарий и пропусти изменение.

**Step 3: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 4: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/services/rabbitService.js
git commit -m "fix(rabbit): make search case-insensitive using LOWER() + Op.like

Searching 'rex' now finds 'Rex' and 'REX'. Uses MySQL LOWER() function
to normalize comparison without requiring schema changes.

Fixes Finding #19 (Low) from backend audit."
```

---

### Task 18: Fix — Sequelize constraint errors в errorHandler (Finding #21)

**Files:**
- Modify: `backend/src/middleware/errorHandler.js`
- Modify: `backend/src/controllers/cageController.js`

**Step 1: Прочитай errorHandler.js**

Найди — обрабатываются ли `SequelizeUniqueConstraintError`, `SequelizeValidationError` глобально?

**Step 2: Добавь в errorHandler.js глобальную обработку если нет**

```javascript
// В errorHandler.js:
if (error.name === 'SequelizeUniqueConstraintError') {
  const field = error.errors[0]?.path || 'field';
  return ApiResponse.error(res, 409, 'UNIQUE_CONSTRAINT', `${field} already exists`);
}

if (error.name === 'SequelizeValidationError') {
  const details = error.errors.map(e => ({ field: e.path, message: e.message }));
  return ApiResponse.validationError(res, details);
}
```

**Step 3: Убери дублирующую обработку из cageController.js**

Если в cageController.js есть отдельный catch для `SequelizeUniqueConstraintError` — удали его, теперь errorHandler обрабатывает.

**Step 4: Запусти тесты**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --no-coverage
```

**Step 5: Commit**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add backend/src/middleware/errorHandler.js backend/src/controllers/cageController.js
git commit -m "refactor(errors): centralize Sequelize constraint errors in errorHandler

SequelizeUniqueConstraintError and SequelizeValidationError were caught
directly in cageController. Moved to global errorHandler for consistency.

Fixes Finding #21 (Low) from backend audit."
```

---

## ФИНАЛЬНАЯ ВЕРИФИКАЦИЯ

### Task 19: Verify — все тесты проходят, нет регрессий

**Step 1: Запусти полный unit test suite**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --coverage --no-coverage 2>&1 | tail -20
```
Expected: 670+ PASS, 0 FAIL

**Step 2: Проверь что coverage не упал ниже 85%**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm/backend
npx jest --testPathPattern="unit" --coverage 2>&1 | grep -E "All files|Statements|Branches"
```
Expected: Statements > 85%

**Step 3: Финальный commit с отчётом**

```bash
cd /mnt/d/projects/RabbitFarm/RabbitFarm
git add docs/plans/
git commit -m "docs: add backend audit findings and fix plan

- 2026-02-24-backend-audit-design.md: audit methodology
- 2026-02-24-backend-audit-findings.md: 21 findings (3 critical, 8 high, 6 medium, 4 low)
- 2026-02-24-backend-audit-plan.md: prioritized fix implementation plan"
```

---

## SUMMARY

| Sprint | Tasks | Severity | Focus |
|--------|-------|----------|-------|
| 1 | 1-3 | Critical | Data integrity, performance, uniqueness |
| 2 | 4-7 | High | Business logic, memory safety |
| 3 | 8-10 | High | Security, data integrity |
| 4 | 11-14 | Medium | UX flows, API contract |
| 5 | 15-18 | Low | Code quality, tech-debt |
| Final | 19 | — | Regression verification |

**Всего:** 18 фиксов + финальная верификация. Каждый — атомарный commit. Порядок соблюдать: Critical сначала.
