# Backend Audit Findings Report

**Date:** 2026-02-24
**Method:** User Flow-Centric Code Review (7 flows, 20 файлов)
**Coverage:** 13 controllers, 8 services, key middleware/utils

---

## ИТОГ: 21 находка

| Severity | Кол-во | Описание |
|----------|--------|----------|
| Critical | 3 | Потеря/порча данных, crash-риск |
| High | 8 | Неправильная бизнес-логика, безопасность, performance |
| Medium | 6 | API-контракт, неполная автоматизация |
| Low | 4 | Дублирование, стиль, оптимизация |

---

## CRITICAL

### Finding #1 — Двойное списание корма при update
- **Severity:** Critical
- **Flow:** Flow 5: Feeding & Inventory
- **Location:** `backend/src/controllers/feedingRecordController.js` (строки ~248-341)
- **Description:** В методе `update()` списание корма происходит ДВАЖДЫ: сначала вне транзакции (строки 248-279), затем снова внутри транзакции (строки 291-341). При любой ошибке в транзакции — первое списание остаётся, но запись не обновляется → stock уходит в минус без записи.
- **User Impact:** Остаток корма корректно не отображается, возможен отрицательный stock без фактической причины.
- **Fix:** Убрать первый блок списания вне транзакции. Весь stock adjustment должен происходить только внутри транзакции.

---

### Finding #2 — Dashboard делает 15+ отдельных SQL-запросов
- **Severity:** Critical
- **Flow:** Flow 6: Finance & Reports
- **Location:** `backend/src/controllers/reportController.js` getDashboard() (строки ~30-190)
- **Description:** Каждый счётчик на дашборде — отдельный `Model.count()` или `Model.sum()`. Итого 15-20 запросов на один HTTP-запрос. При нагрузке или медленном MySQL — таймаут или DoS.
- **User Impact:** Дашборд медленно загружается, при большом количестве данных — таймаут 30с.
- **Fix:** Заменить последовательные запросы на `Promise.all()` для параллельного выполнения. Тяжёлые агрегации вынести в `reportService`.

---

### Finding #3 — tag_id кроликов не уникальный при массовом создании
- **Severity:** Critical
- **Flow:** Flow 3: Breeding Lifecycle
- **Location:** `backend/src/controllers/birthController.js` createKitsFromBirth() (строка ~382)
- **Description:** tag_id генерируется как `Date.now() + index`. Если создаются кроли в одной миллисекунде (batch) — дублирующийся tag_id → ошибка unique constraint в БД без graceful обработки.
- **User Impact:** При регистрации помёта > 1 кролика — возможен crash или частичное создание (часть кролей создана, часть нет).
- **Fix:** Использовать UUID (`crypto.randomUUID()`) или `${Date.now()}-${Math.random().toString(36).slice(2)}` для гарантии уникальности.

---

## HIGH

### Finding #4 — getStatistics() загружает ВСЕ записи в память
- **Severity:** High
- **Flow:** Flow 4: Health Management
- **Location:** `backend/src/controllers/vaccinationController.js` getStatistics() (строки ~315-324)
- **Description:** `Vaccination.findAll()` без LIMIT + JavaScript-цикл для агрегации. При 10,000+ вакцинациях — OOM. То же в `medicalRecordController.js` getStatistics().
- **User Impact:** Зависание или crash сервера при большом количестве данных.
- **Fix:** Заменить `findAll()` + JS-агрегацию на SQL `COUNT()`, `GROUP BY`, `SUM()` с Sequelize. Так же в reportController getHealthReport().

---

### Finding #5 — getPedigree() уязвим к stack overflow при циклических связях
- **Severity:** High
- **Flow:** Flow 2: Farm Setup
- **Location:** `backend/src/services/rabbitService.js` getPedigree() (строки ~539-591)
- **Description:** Рекурсивный обход родословной без проверки на уже посещённых кроликов. Если в БД — циклическая ссылка (отец = потомок), — бесконечная рекурсия → stack overflow → crash Node.js.
- **User Impact:** Crash сервера при некорректных данных в родословной.
- **Fix:** Добавить `Set visited` с id кроликов, прерывать рекурсию при повторном посещении.

---

### Finding #6 — Определение "продажи" по строковому совпадению (case-sensitive)
- **Severity:** High
- **Flow:** Flow 6: Finance & Reports
- **Location:** `backend/src/services/transactionService.js` (строки ~40-44)
- **Description:** `if (category?.toLowerCase() === 'sale' || category?.toLowerCase() === 'продажа')` — правильно (toLowerCase). НО: rabbit_id берётся из `data.notes` или другого нестандартного поля. Кролик помечается 'sold' без проверки что он жив.
- **User Impact:** Кролик, уже продажный или мёртвый, может ещё раз пометиться как 'sold' или наоборот — продажа не обновит статус.
- **Fix:** Добавить проверку `rabbit.status !== 'sold' && rabbit.status !== 'died'` перед обновлением статуса.

---

### Finding #7 — Логика kits_weaned в birthController некорректна
- **Severity:** High
- **Flow:** Flow 3: Breeding Lifecycle
- **Location:** `backend/src/controllers/birthController.js` createKitsFromBirth() (строка ~397)
- **Description:** Поле `kits_weaned` обновляется при СОЗДАНИИ кроликов из помёта, а не при отъёме. По смыслу это должно происходить только при weaning (отъёме от матери).
- **User Impact:** Статистика помётов показывает неверные данные: kits_weaned = alive_count сразу после рождения.
- **Fix:** Убрать обновление `kits_weaned` из `createKitsFromBirth()`. Добавить endpoint или логику для weaning-события.

---

### Finding #8 — Расчёт вместимости клетки при создании помёта не учитывает мать
- **Severity:** High
- **Flow:** Flow 3: Breeding Lifecycle
- **Location:** `backend/src/controllers/birthController.js` (строка ~365)
- **Description:** Проверка `currentCount + newKits <= capacity` считает текущих кроликов, но мать уже находится в клетке — она уже включена в count. Логика верная. НО: если матери нет в клетке (отдельный вопрос) — count будет занижен.
- **User Impact:** Возможна переполненная клетка если проверка выполняется некорректно.
- **Fix:** Явно проверять: если мать в той же клетке — она уже в `currentCount`, не добавлять дополнительно.

---

### Finding #9 — only_available фильтр для клеток применяется после запроса из БД
- **Severity:** High (performance)
- **Flow:** Flow 2: Farm Setup
- **Location:** `backend/src/services/cageService.js` (строка ~86)
- **Description:** `cages.filter(c => c.status === 'available')` происходит в JavaScript после получения всех клеток из БД с пагинацией. Это ломает пагинацию (запросили 20, отфильтровали до 5) и убивает производительность.
- **User Impact:** При фильтрации `only_available=true` — пагинация некорректна, возможно меньше результатов чем ожидается.
- **Fix:** Добавить `status: 'available'` в `WHERE` условие Sequelize до запроса.

---

### Finding #10 — updateTask() позволяет переназначать задачу без проверки прав
- **Severity:** High
- **Flow:** Flow 7: Task Management
- **Location:** `backend/src/services/taskService.js` updateTask() (строки ~155-187)
- **Description:** Поле `assigned_to` можно обновить до любого user_id без проверки существования пользователя или принадлежности к ферме. Задача может быть назначена несуществующему пользователю.
- **User Impact:** Задачи назначаются "в никуда", данные некорректны.
- **Fix:** При обновлении `assigned_to` — проверять что пользователь существует (`User.findByPk`).

---

### Finding #11 — Recurrence validation в taskService молча падает
- **Severity:** High
- **Flow:** Flow 7: Task Management
- **Location:** `backend/src/services/taskService.js` completeTask() (строка ~261)
- **Description:** Если `recurrence_rule` не входит в `RECURRENCE_OFFSETS` — следующая задача молча не создаётся, задача помечается completed, но пользователь не получает ошибку и не знает что повторение не сработало.
- **User Impact:** Повторяющиеся задачи (вакцинация, кормление) тихо прекращают создаваться.
- **Fix:** Валидировать `recurrence_rule` при создании задачи (validator), не при выполнении. Или бросать ошибку при completeTask если rule невалидна.

---

## MEDIUM

### Finding #12 — Статус медицинской записи не автоматизирован при создании
- **Severity:** Medium
- **Flow:** Flow 4: Health Management
- **Location:** `backend/src/controllers/medicalRecordController.js` (строки ~264-266)
- **Description:** При создании медкарты с outcome='died' — статус кролика НЕ обновляется автоматически. Только при UPDATE медкарты. Пользователь должен сначала создать запись, потом обновить её.
- **User Impact:** После регистрации смерти кролик остаётся со старым статусом до ручного обновления.
- **Fix:** В `createMedicalRecord()` если outcome ∈ ['died', 'euthanized'] — обновлять статус кролика сразу.

---

### Finding #13 — reportController getFarmReport() дефолтная дата 2020-01-01
- **Severity:** Medium
- **Flow:** Flow 6: Finance & Reports
- **Location:** `backend/src/controllers/reportController.js` getFarmReport() (строка ~299)
- **Description:** Если `date_from` не передан, дефолт = '2020-01-01'. Запрос сканирует всю таблицу за 5+ лет. Не критично, но неправильный UX и performance.
- **User Impact:** Отчёт без фильтра по дате возвращает данные за 5 лет — медленно и неинформативно.
- **Fix:** Дефолтный период = последние 30 дней. Задокументировать в Swagger.

---

### Finding #14 — getFinancialReport() принимает groupBy но не использует
- **Severity:** Medium
- **Flow:** Flow 6: Finance & Reports
- **Location:** `backend/src/controllers/reportController.js` getFinancialReport() (~строка 464)
- **Description:** Параметр `groupBy` принимается из query, но не применяется к запросу. Flutter-клиент может передавать его ожидая группировку — получает один вариант группировки всегда.
- **User Impact:** Отчёт не группируется по выбранному параметру.
- **Fix:** Реализовать `groupBy` логику (by_category, by_month, by_type) или убрать параметр из API и Swagger.

---

### Finding #15 — vaccinationController getByRabbit() не проверяет автора вакцинации
- **Severity:** Medium
- **Flow:** Flow 4: Health Management
- **Location:** `backend/src/controllers/vaccinationController.js` getByRabbit() (строка ~209)
- **Description:** Проверяется ownership кролика (rabbit.user_id === req.user.id), но при выборке вакцинаций не добавляется `user_id` фильтр на саму вакцинацию. Если вакцинации от другого пользователя каким-то образом привязаны к кролику — они утекут.
- **User Impact:** Теоретическая утечка данных между пользователями.
- **Fix:** Добавить `include: [{ model: Rabbit, where: { user_id } }]` при запросе вакцинаций.

---

### Finding #16 — Inconsistency: mixed error handling между контроллерами
- **Severity:** Medium
- **Flow:** Все flows (cross-cutting)
- **Location:** Все контроллеры
- **Description:** Часть контроллеров (feedController, cageController) — function-based. Другие (breedingController) — class-based. Часть ошибок ловится в контроллере, часть делегируется в `next(error)`. Нет единого паттерна.
- **User Impact:** Нет прямого UX-эффекта, но усложняет дебаг и поддержку.
- **Fix:** Стандартизировать: все ошибки бизнес-логики — через `next(error)`, контроллеры только маппируют HTTP-коды. (Уже частично сделано в service layer refactoring.)

---

## LOW

### Finding #17 — feedService использует runtime require для Sequelize.col()
- **Severity:** Low
- **Location:** `backend/src/services/feedService.js` (строки ~43, 127)
- **Description:** `require('sequelize').col('min_stock')` внутри функции вместо top-level `const { Op, col } = require('sequelize')`.
- **Fix:** Вынести в импорты в начале файла.

---

### Finding #18 — console.warn() вместо logger в feedingRecordController
- **Severity:** Low
- **Location:** `backend/src/controllers/feedingRecordController.js` (строка ~331)
- **Description:** Используется `console.warn()` вместо Winston logger — логи не попадают в файлы.
- **Fix:** Заменить на `logger.warn()`.

---

### Finding #19 — Поиск кроликов case-sensitive
- **Severity:** Low
- **Location:** `backend/src/services/rabbitService.js` listRabbits() (строки ~192-195)
- **Description:** LIKE без COLLATE — поиск "rex" не найдёт "Rex".
- **Fix:** Использовать `Op.iLike` (PostgreSQL) или добавить `LOWER()` в MySQL: `where: sequelize.where(sequelize.fn('LOWER', sequelize.col('name')), 'LIKE', '%rex%')`.

---

### Finding #20 — rabbitController не верифицирует успех удаления файла фото
- **Severity:** Low
- **Location:** `backend/src/controllers/rabbitController.js` uploadPhoto(), deletePhoto()
- **Description:** Если файл не удалился с диска — запись в БД обновляется, но файл остаётся. Orphan файлы.
- **Fix:** Добавить try/catch вокруг file deletion, логировать ошибки, при критических — откатить БД-операцию.

---

### Finding #21 — cageController обрабатывает Sequelize-ошибки прямо в контроллере
- **Severity:** Low
- **Location:** `backend/src/controllers/cageController.js` (строки ~15-20, 57-62)
- **Description:** `SequelizeUniqueConstraintError` ловится в контроллере, хотя должна обрабатываться в сервисе или глобальном errorHandler.
- **Fix:** Перенести обработку Sequelize-специфичных ошибок в глобальный errorHandler.js.

---

## ПРИОРИТИЗИРОВАННЫЙ FIX PLAN

### Sprint 1 — Critical (делать сразу)
1. Finding #2 — Dashboard N+1 → Promise.all + reportService
2. Finding #1 — Double stock deduction → atomic transaction fix
3. Finding #3 — tag_id uniqueness → UUID-based generation

### Sprint 2 — High Business Logic
4. Finding #4 — Statistics memory → SQL aggregation
5. Finding #5 — Pedigree stack overflow → visited Set
6. Finding #7 — kits_weaned logic → correct weaning flow
7. Finding #9 — only_available filter → WHERE clause (not JS filter)

### Sprint 3 — High Security/Integrity
8. Finding #6 — Sale status check → add alive/not-sold validation
9. Finding #10 — Task assignment → validate assigned_to user exists
10. Finding #11 — Recurrence validation → validate at create, not complete

### Sprint 4 — Medium UX/Contract
11. Finding #12 — Medical record death → auto-update rabbit status on create
12. Finding #14 — groupBy implementation → implement or remove
13. Finding #13 — Default date range → last 30 days
14. Finding #15 — Vaccination user filter → add user_id to query
15. Finding #16 — Error handling standardization

### Sprint 5 — Low Tech-Debt
16. Finding #17 — Runtime require → top-level import
17. Finding #18 — console.warn → logger.warn
18. Finding #19 — Case-insensitive search
19. Finding #20 — File deletion verification
20. Finding #21 — Sequelize errors in errorHandler
