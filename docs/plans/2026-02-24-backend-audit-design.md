# Backend Audit Design: User Flow-Centric Quality Verification

**Date:** 2026-02-24
**Scope:** Backend API (~10,000 lines, Express.js/Sequelize/MySQL)
**Goal:** Проверить корректность бизнес-логики, data integrity, API-контракт и найти дублирования через трассировку реальных пользовательских сценариев.

---

## Контекст

Проект: RabbitFarm — mobile app для управления кроличьей фермой.
Backend: 13 контроллеров, 14 моделей БД, 15 роутов, 10 Joi-валидаторов, 8 сервисов.
Тесты: 670 unit-тестов (100% pass), integration падают из-за отсутствия MySQL в CI.
Предыдущая работа: service layer extraction, token blacklist, password reset, Swagger, 85% coverage.

---

## Проблема

85% test coverage ≠ корректная работа приложения. Тесты проверяют отдельные функции, но не:
- Цепочки взаимосвязанных операций (кролик умер → статус клетки → отчёты)
- Корректность автоматических side-effects (списание корма, беременность)
- Соответствие API-ответов тому, что ожидает Flutter-клиент
- Дублирование паттернов, которые создают риск расхождения поведения

---

## Подход: User Flow-Centric Audit

### Методология

Для каждого из 7 user flows:
1. Читаем все релевантные файлы (контроллер + сервис + модель + роут + валидатор)
2. Трассируем путь данных: HTTP Request → Middleware → Controller → Service → DB → Response
3. Применяем 5-точечный чеклист на каждый endpoint
4. Документируем находки с severity и конкретным fix

### 5-точечный чеклист на endpoint

| # | Точка | Что проверяем |
|---|-------|---------------|
| 1 | **Validation** | Joi-схема покрывает все поля? Типы правильные? Edge cases (пустые строки, 0, отрицательные числа)? |
| 2 | **Business Logic** | Доменные правила соблюдены? (нельзя случить двух самок, нельзя кормить при нулевом остатке) |
| 3 | **Side Effects** | Автоматические мутации корректны и атомарны? (транзакции БД при деструктивных операциях) |
| 4 | **API Contract** | Response = `{ success, data, message, timestamp }`? HTTP-коды правильные? Error codes стандартные? |
| 5 | **User Isolation** | `WHERE user_id = req.user.id` везде? 404 вместо 403 при доступе к чужим ресурсам? |

### Severity критерии

| Severity | Критерий |
|----------|----------|
| **Critical** | Потеря данных, security breach, crash, SQL injection |
| **High** | Неправильная бизнес-логика (неверный расчёт), data corruption, negative stock |
| **Medium** | Неверный API-контракт (Flutter может сломаться), неполная валидация |
| **Low** | Дублирование кода, style inconsistency, suboptimal queries |

---

## 7 User Flows

### Flow 1: Auth & Security
```
POST /auth/register → POST /auth/login → GET /auth/me
→ POST /auth/refresh → POST /auth/logout
→ POST /auth/forgot-password → POST /auth/reset-password
→ PUT /auth/change-password
```
**Ключевые риски:** token lifecycle, blacklist при logout, ownership токенов, bcrypt параметры, password reset expiry.

### Flow 2: Farm Setup (Breeds → Rabbits → Cages)
```
POST /breeds → GET /breeds
→ POST /rabbits (breed_id, cage_id) → GET /rabbits → GET /rabbits/:id
→ POST /cages → GET /cages → PUT /cages/:id
→ DELETE /breeds/:id (cascade?)
→ DELETE /rabbits/:id (cascade: vaccinations, feedings, breedings)
```
**Ключевые риски:** cascade delete integrity, cage status automation на create/delete rabbit, breed delete когда есть кролики.

### Flow 3: Breeding Lifecycle (самый сложный)
```
POST /breeding (male_id, female_id)
→ GET /breeding/:id → PUT /breeding/:id/status
→ POST /births (breeding_id, born_count, alive_count)
→ GET /births → GET /breeding/:id/births
→ DELETE /breeding/:id
```
**Ключевые риски:** gender validation (male + female), нельзя использовать одного кролика в двух активных случках, статус female при беременности, birth count consistency, рождения без случки.

### Flow 4: Health Management
```
POST /vaccinations (rabbit_id, vaccine_name, date, next_date)
→ GET /vaccinations → GET /vaccinations/upcoming → GET /vaccinations/overdue
→ POST /medical-records (rabbit_id, type, description)
→ GET /medical-records → GET /rabbits/:id/health-summary
```
**Ключевые риски:** overdue calculation (timezone?), upcoming window (сколько дней?), orphan records при удалении кролика, типы медицинских записей.

### Flow 5: Feeding & Inventory
```
POST /feeds (name, quantity, unit, min_threshold)
→ PUT /feeds/:id (adjust stock)
→ POST /feeding-records (rabbit_id, feed_id, amount, cost)
→ GET /feeds/:id (current_stock)
→ DELETE /feeding-records/:id (возвращает ли stock?)
```
**Ключевые риски:** atomicity при списании (check + deduct в одной транзакции?), отрицательный остаток, stock при удалении feeding record, min_threshold alerting.

### Flow 6: Finance & Reports
```
POST /transactions (type: income/expense, amount, category)
→ GET /transactions (filter: type, date_from, date_to)
→ GET /transactions/statistics
→ GET /reports/dashboard → GET /reports/farm
→ GET /reports/health → GET /reports/financial
```
**Ключевые риски:** суммы в отчётах совпадают с сырыми транзакциями, категории фиксированные или свободные, user isolation в агрегациях.

### Flow 7: Task Management
```
POST /tasks (title, priority, due_date, rabbit_id?, cage_id?)
→ GET /tasks (filter: status, priority, overdue)
→ PUT /tasks/:id (complete)
→ GET /tasks/statistics
→ DELETE /tasks/:id
```
**Ключевые риски:** overdue определение (сравнение дат, timezone), GET /tasks/overdue endpoint существует?, priority validation, orphan tasks при удалении кролика/клетки.

---

## Фаза 2: Code Duplication Audit

После завершения всех 7 flows — cross-controller анализ:

1. **Pagination pattern** — как `page, limit, offset` реализованы в каждом контроллере? DRY?
2. **Filter/WHERE building** — как строятся условия фильтрации? Общий helper?
3. **Try/catch wrapping** — паттерн обработки ошибок одинаковый везде?
4. **User isolation** — `user_id` добавляется в WHERE везде и одинаково?
5. **Response format** — `apiResponse.success/error` используется везде или есть raw `res.json`?
6. **Service boundary** — есть ли бизнес-логика, оставшаяся в контроллерах (не вынесена в сервисы)?

---

## Findings Document

Все находки записываются в `docs/plans/2026-02-24-backend-audit-findings.md` в процессе аудита:

```markdown
## Finding #N
- **Severity**: Critical | High | Medium | Low
- **Flow**: [Flow Name]
- **Location**: `backend/src/controllers/X.js:NN` (или service/model/route)
- **Description**: Что именно не так
- **User Impact**: Что сломается у пользователя в этом сценарии
- **Fix**: Конкретное исправление (код или описание)
```

---

## Финальный Fix Plan

По завершении аудита — приоритизированный план исправлений:
- Критические → исправить немедленно (один PR)
- Высокие → следующий спринт
- Средние → backlog с приоритетом
- Низкие → tech-debt backlog

---

**Approved:** 2026-02-24
**Next step:** Implementation plan in `docs/plans/2026-02-24-backend-audit-plan.md`
