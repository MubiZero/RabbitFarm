# RabbitFarm - System Architecture

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                      │
│                      (Android Primary)                      │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────┐     │
│  │ Presentation│  │  Business   │  │  Data Layer      │     │
│  │   Layer     │◄─┤   Logic     │◄─┤  (Remote only,   │     │
│  │  (Widgets)  │  │  (Riverpod) │  │   online-only)   │     │
│  └─────────────┘  └─────────────┘  └──────────────────┘     │
│                                            │                │
│                                            │                │
└────────────────────────────────────────────┼────────────────┘
                                             │
                                             │ HTTPS/REST
                                             │
                        ┌────────────────────▼──────────────────────┐
                        │        Backend API (Express.js)           │
                        │  ┌──────────┐  ┌──────────┐  ┌────────┐   │
                        │  │  Routes  │─►│ Services │─►│ Models │   │
                        │  └──────────┘  └──────────┘  └────────┘   │
                        │       │              │            │       │
                        │       ▼              ▼            ▼       │
                        │  ┌──────────────────────────────────┐     │
                        │  │      Middleware (Auth, etc)      │     │
                        │  └──────────────────────────────────┘     │
                        └───────────────────┬───────────────────────┘
                                            │
                                            │ SQL
                                            │
                        ┌───────────────────▼────────────────────┐
                        │         MySQL Database                 │
                        │    ┌────────────────────────────┐      │
                        │    │  Tables (normalized)       │      │
                        │    │  - users, rabbits, etc     │      │
                        │    └────────────────────────────┘      │
                        └────────────────────────────────────────┘
```

## 📱 Flutter Application Architecture

### Слои (по факту — двухслойные, без domain и use-case классов)

Ниже реальное дерево `lib/`, а не то, что задумывалось на старте: отдельного
domain-слоя с абстрактными репозиториями и use-case классами в проекте нет —
`presentation/providers` работает напрямую с конкретным классом
`XxxRepository`, который сам оборачивает `ApiClient`.

```
lib/
├── core/                           # Сквозная инфраструктура
│   ├── access/                     # Права по роли (farm_access.dart, капабилити)
│   ├── api/
│   │   ├── api_client.dart         # Dio HTTP client
│   │   ├── api_error.dart          # Разбор ошибки ответа
│   │   ├── api_failure.dart        # Типизированный сбой запроса
│   │   ├── api_endpoints.dart      # Константы эндпоинтов
│   │   └── paginated.dart          # Разбор постраничных ответов
│   ├── json/                       # Общие JSON-конвертеры для Freezed-моделей
│   ├── l10n/                       # context.l10n, error_text.dart (текст ошибки по ApiFailure)
│   ├── models/                     # Модели, общие для нескольких фич
│   ├── notifications/
│   │   └── fcm_service.dart        # Push (FCM): регистрация токена, тап по уведомлению
│   ├── providers/                  # Сквозные провайдеры (сессия, тема, revision)
│   ├── router/
│   │   └── app_router.dart         # GoRouter: маршруты, ShellRoute, редирект по авторизации
│   ├── theme/                      # Material 3 theme
│   ├── utils/                      # Даты, форматирование, возраст кролика и т.п.
│   └── widgets/                    # Общая библиотека виджетов, см. widgets.dart:
│       ├── app_async_view.dart     #   единая обвязка loading/error/data
│       ├── app_empty_state.dart, app_error_state.dart, skeleton.dart,
│       └── delayed_spinner.dart, stale_data_banner.dart, ...
│
├── features/                       # Feature modules (15 модулей)
│   ├── auth/                       # ✅ Аутентификация, регистрация фермы
│   ├── onboarding/                 # ✅ Первый вход, название и тип фермы
│   ├── home/                       # ✅ Дневник фермы, «Сегодня», быстрая запись
│   ├── rabbits/                    # ✅ Кролики, породы, родословная, история веса
│   ├── cages/                      # ✅ Клетки
│   ├── breeding/                   # ✅ Случки и рождения
│   ├── health/                     # ✅ Вакцинации и медкарты
│   ├── feeding/                    # ✅ Корма и кормление
│   ├── finance/                    # ✅ Транзакции
│   ├── tasks/                      # ✅ Задачи
│   ├── notes/                      # ✅ Заметки — пятый тип записи в дневнике
│   ├── reports/                    # ✅ Dashboard и отчёты
│   ├── staff/                      # ✅ Работники, приглашения, передача хозяйства
│   ├── device_tokens/              # ✅ Регистрация устройств для push
│   └── settings/                   # ✅ Настройки приложения
│
│   Каждый модуль устроен одинаково:
│   ├── data/
│   │   ├── models/                 # Freezed JSON-модели
│   │   └── repositories/           # Класс-репозиторий поверх ApiClient
│   └── presentation/
│       ├── providers/              # Riverpod-провайдеры
│       └── screens/                # Экраны (форма одна и на создание, и на правку)
│
├── shared/                         # Общее между фичами
│   ├── models/
│   │   └── api_response.dart       # ApiResponse<T> и PaginatedResponse<T>
│   └── widgets/
│       └── logout_dialog.dart
│
└── main.dart                       # App entry point
```

### State Management (Riverpod)

**Provider Types:**
- `Provider` - Immutable computed values
- `StateProvider` - Simple state
- `StateNotifierProvider` - Complex state with business logic
- `FutureProvider` - Async data fetching
- `StreamProvider` - Real-time updates

**Как это выглядит по факту** (упрощено из `rabbits_provider.dart`) — без
абстрактного интерфейса репозитория и без отдельного use-case класса,
провайдер работает с конкретным классом репозитория напрямую:

```dart
// Repository — конкретный класс поверх ApiClient, без интерфейса
class RabbitsRepository {
  final ApiClient apiClient;
  RabbitsRepository({required this.apiClient});

  Future<PaginatedResponse<RabbitModel>> getRabbits({...}) async { ... }
  Future<RabbitModel> getRabbitById(int id) async { ... }
}

final rabbitsRepositoryProvider = Provider<RabbitsRepository>((ref) {
  return RabbitsRepository(apiClient: ref.watch(apiClientProvider));
});

// StateNotifier с состоянием списка (загрузка/ошибка/данные/пагинация)
final rabbitsProvider = StateNotifierProvider<RabbitsNotifier, RabbitsState>((ref) {
  return RabbitsNotifier(ref.watch(rabbitsRepositoryProvider));
});

class RabbitsNotifier extends StateNotifier<RabbitsState> {
  final RabbitsRepository _repository;

  RabbitsNotifier(this._repository) : super(const RabbitsState()) {
    loadRabbits();
  }

  Future<void> loadRabbits() async {
    state = state.copyWith(isLoading: true);
    // ...
  }
}

// Загрузка одной сущности по id — FutureProvider.family, тот же приём
// используют /rabbits/:id, /cages/:id, /breeding/:id и другие detail-маршруты
final rabbitDetailProvider =
    FutureProvider.family<RabbitModel, int>((ref, id) async {
  return ref.watch(rabbitsRepositoryProvider).getRabbitById(id);
});
```

### Navigation (GoRouter)

Актуальный API `go_router` (не `state.location`/`state.params`, которые уже
убраны из пакета): `state.uri.path`, `state.pathParameters`,
`state.uri.queryParameters`. Реальный `app_router.dart` устроен так же, но
плоским списком маршрутов вместо вложенных `routes:` — большинство
detail/form-маршрутов идут `parentNavigatorKey: rootNavigatorKey`, поверх
`ShellRoute` с нижней навигацией, а не внутри неё:

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isAuthRoute = state.uri.path.startsWith('/login');

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      ShellRoute(
        builder: (_, __, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const TodayScreen()),
          // ...
        ],
      ),
      // Detail/form-маршруты — вне ShellRoute, во весь экран:
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RabbitDetailScreen(rabbitId: id);
        },
      ),
    ],
  );
});
```

### Работа без сети — не реализована

Приложение online-only: нет ни локальной SQLite-базы, ни очереди
отложенных операций, ни детектора подключения (`sqflite`/`hive` не
подключены, `mobile/lib/core` и `mobile/lib/shared` не содержат ни
`database/`, ни `connectivity_provider.dart`). Каждый экран сам делает
запрос через `ApiClient (Dio)` и показывает загрузку/ошибку.

Единственная уступка нестабильной сети — [`AppAsyncView`](../mobile/lib/core/widgets/app_async_view.dart)
и [`StaleDataBanner`](../mobile/lib/core/widgets/stale_data_banner.dart):
если повторный запрос (обновление списка) упал, а прежние данные уже
показаны — экран не переключается в пустоту, а оставляет старые данные и
рисует сверху баннер «показаны старые данные» с кнопкой повтора. Полностью
офлайн (без единого успешного запроса) приложением пользоваться нельзя —
это осознанное ограничение MVP, а не пропущенная фича.

## 🔧 Backend API Architecture

### Express.js Structure

```
backend/
├── src/
│   ├── app.js                      # Express app setup
│   ├── server.js                   # Server entry point
│   │
│   ├── config/
│   │   ├── database.js             # Sequelize config
│   │   ├── jwt.js                  # JWT config
│   │   ├── multer.js               # File upload config (memoryStorage) — подключается прямо в роутах
│   │   ├── minio.js                # Клиент MinIO + ensureBucket() при старте
│   │   ├── firebase.js             # Firebase Admin SDK (push), молчит без ключей
│   │   ├── swagger.js              # OpenAPI-схема
│   │   └── validateEnv.js          # Проверка обязательных переменных окружения при старте
│   │
│   ├── middleware/                 # Без отдельного upload.js — загрузка идёт через config/multer.js
│   │   ├── auth.js                 # JWT verification
│   │   ├── validation.js           # Request validation
│   │   ├── errorHandler.js         # Global error handler
│   │   └── rateLimiter.js          # Rate limiting (не на все роуты — см. «Middleware Chain»)
│   │
│   ├── models/                     # ✅ 21 модель Sequelize
│   │   ├── index.js                # Sequelize init, ассоциации, tenancy.attach()
│   │   ├── Farm.js                 # Хозяйство: название, владелец
│   │   ├── User.js                 # Пользователи
│   │   ├── Invitation.js           # Приглашения работников
│   │   ├── Rabbit.js               # Кролики
│   │   ├── RabbitWeight.js         # История веса
│   │   ├── Breed.js                # Породы
│   │   ├── Cage.js                 # Клетки
│   │   ├── Breeding.js             # Случки
│   │   ├── Birth.js                # Рождения
│   │   ├── Vaccination.js          # Вакцинации
│   │   ├── MedicalRecord.js        # Медицинские карты
│   │   ├── Feed.js                 # Корма
│   │   ├── FeedingRecord.js        # Записи кормления
│   │   ├── Transaction.js          # Финансовые транзакции
│   │   ├── Task.js                 # Задачи
│   │   ├── Photo.js                # Фото кроликов
│   │   ├── Note.js                 # Заметки: по кролику, клетке или ферме в целом
│   │   ├── DeviceToken.js          # FCM-токены устройств для push-уведомлений
│   │   ├── RefreshToken.js         # Refresh-токены
│   │   ├── TokenBlacklist.js       # Отозванные access-токены
│   │   └── PasswordResetToken.js   # Сброс паролей
│   │
│   ├── controllers/                # ✅ 16 контроллеров
│   │   ├── authController.js       # Аутентификация, JWT, регистрация фермы
│   │   ├── rabbitController.js     # CRUD кроликов, статистика
│   │   ├── breedController.js      # CRUD пород
│   │   ├── cageController.js       # CRUD клеток, автостатусы
│   │   ├── breedingController.js   # Случки
│   │   ├── birthController.js      # Рождения
│   │   ├── vaccinationController.js # Вакцинации, upcoming/overdue
│   │   ├── medicalRecordController.js # Медкарты
│   │   ├── feedController.js       # Корма, управление складом
│   │   ├── feedingRecordController.js # Кормление, автосписание
│   │   ├── transactionController.js # Финансы, статистика
│   │   ├── taskController.js       # Задачи, планирование
│   │   ├── reportController.js     # Dashboard, отчеты
│   │   ├── staffController.js      # Работники, приглашения, передача хозяйства
│   │   ├── noteController.js       # Заметки по кролику, клетке или ферме
│   │   └── deviceTokenController.js # Регистрация устройств для push-уведомлений
│   │
│   ├── services/                   # Бизнес-логика — не у каждого контроллера свой сервис
│   │   ├── authService.js          # Регистрация, вход, токены
│   │   ├── staffService.js         # Работники, приглашения, передача хозяйства
│   │   ├── noteService.js          # Заметки
│   │   ├── notificationService.js  # Push-уведомления (FCM), опционально — молчит без Firebase
│   │   ├── deviceTokenService.js   # Регистрация FCM-токенов устройств
│   │   ├── rabbitService.js
│   │   ├── breedService.js
│   │   ├── breedingService.js
│   │   ├── cageService.js
│   │   ├── feedService.js
│   │   ├── taskService.js
│   │   ├── transactionService.js
│   │   └── autoExpenseService.js   # Автоматические расходы на лечение
│   │
│   ├── jobs/                       # Фоновые задачи (setInterval / node-cron)
│   │   ├── tokenCleanup.js         # Чистка просроченных токенов, раз в час
│   │   └── notificationDigestJob.js # Дайджест просрочек по фермам, раз в сутки в 08:00
│   │
│   ├── routes/                     # ✅ 17 роутов + index.js (16 под API-версией + files.routes.js отдельно)
│   │   ├── index.js                # Главный роутер, монтирует все модули
│   │   ├── auth.routes.js          # /auth - login, register, refresh
│   │   ├── rabbit.routes.js        # /rabbits - CRUD + статистика
│   │   ├── breed.routes.js         # /breeds - CRUD пород
│   │   ├── cage.routes.js          # /cages - CRUD клеток
│   │   ├── breeding.routes.js      # /breeding - случки
│   │   ├── birth.routes.js         # /births - рождения
│   │   ├── vaccination.routes.js   # /vaccinations - вакцинации
│   │   ├── medical-record.routes.js # /medical-records - медкарты
│   │   ├── feed.routes.js          # /feeds - корма
│   │   ├── feeding-record.routes.js # /feeding-records - кормление
│   │   ├── transaction.routes.js   # /transactions - финансы
│   │   ├── task.routes.js          # /tasks - задачи
│   │   ├── report.routes.js        # /reports - dashboard, отчеты
│   │   ├── staff.routes.js         # /staff - работники, приглашения, передача хозяйства
│   │   ├── note.routes.js          # /notes - заметки
│   │   ├── device-token.routes.js  # /device-tokens - регистрация устройств для push
│   │   └── files.routes.js         # /uploads/:folder/:filename - раздача из MinIO,
│   │                                #   монтируется в app.js напрямую, не через этот index.js
│   │
│   ├── validators/                 # ✅ 15 валидаторов Joi + listQuery.js, messages.js (общие хелперы)
│   │   ├── authValidator.js        # Валидация login, register (включая farm_name)
│   │   ├── rabbitValidator.js      # Валидация кроликов
│   │   ├── breedValidator.js       # Валидация пород
│   │   ├── cageValidator.js        # Валидация клеток
│   │   ├── breedingValidator.js    # Валидация случек
│   │   ├── birthValidator.js       # Валидация рождений
│   │   ├── vaccinationValidator.js # Валидация вакцинаций
│   │   ├── medicalRecordValidator.js # Валидация медкарт
│   │   ├── feedValidator.js        # Валидация кормов
│   │   ├── feedingRecordValidator.js # Валидация кормления
│   │   ├── transactionValidator.js # Валидация транзакций
│   │   ├── taskValidator.js        # Валидация задач
│   │   ├── staffValidator.js       # Валидация приглашений и работников
│   │   ├── noteValidator.js        # Валидация заметок
│   │   └── deviceTokenValidator.js # Валидация регистрации устройств
│   │
│   └── utils/
│       ├── jwt.js                  # JWT helpers
│       ├── password.js             # Password hashing
│       ├── tenancy.js              # Страховка изоляции ферм (см. «Многоарендность»)
│       ├── dateRange.js
│       ├── apiResponse.js          # Standardized responses
│       ├── fileStorage.js          # Загрузка/удаление/раздача файлов через MinIO
│       └── logger.js               # Winston-логгер (см. «Monitoring & Logging»)
│
├── migrations/                     # Sequelize migrations
├── seeders/                        # Seed data
├── uploads/                        # Uploaded files
│   ├── rabbits/
│   ├── receipts/
│   └── temp/
├── tests/
│   ├── unit/
│   └── integration/
├── .env.example
├── .env
└── package.json
```

### API Response Format

**Success Response:**
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Operation successful",
  "timestamp": "2025-10-15T10:00:00.000Z"
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "name",
        "message": "Name is required"
      }
    ]
  },
  "timestamp": "2025-10-15T10:00:00.000Z"
}
```

**Paginated Response:**
```json
{
  "success": true,
  "data": {
    "items": [],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "totalPages": 8
    }
  }
}
```

### Authentication Flow

```
1. User Login
   ├─► POST /api/v1/auth/login
   │   Body: { email, password }
   ├─► Backend validates credentials
   ├─► Generate JWT access token (15min) + refresh token (7days)
   └─► Response: { accessToken, refreshToken, user }

2. Authenticated Request
   ├─► GET /api/v1/rabbits
   │   Header: Authorization: Bearer <accessToken>
   ├─► Middleware verifies token
   └─► If valid: proceed, if expired: 401 error

3. Token Refresh
   ├─► POST /api/v1/auth/refresh
   │   Body: { refreshToken }
   ├─► Backend validates refresh token
   └─► Response: { accessToken }

4. Logout
   └─► POST /api/v1/auth/logout
       └─► Invalidate refresh token
```

### Middleware Chain

Глобально (`app.js`): `helmet` → `cors` → `compression` → body-parsers →
`morgan` → `generalLimiter` (один лимит на весь `/api/`, не per-route) →
роуты → `notFoundHandler` → `errorHandler`.

Внутри роутера конкретного ресурса — `authenticate` на весь роутер,
`authorize([...])` точечно там, где роль имеет значение, `rateLimiter`
не универсален (свой лимитер только там, где нужен, например на аплоаде):

```javascript
// backend/src/routes/rabbit.routes.js (сокращённо)
router.use(authenticate);                                   // JWT на весь роутер

router.get('/', validate(listSchema), rabbitController.list);
router.post('/:id/photo',
  uploadLimiter,                                             // свой лимит, не общий
  upload.single('photo'),
  rabbitController.uploadPhoto);
router.delete('/:id',
  authorize(['owner']),                                       // роль важна не везде
  rabbitController.delete);
```

## 🗄️ Database Design Principles

### Normalization
- 3NF (Third Normal Form)
- Avoid data duplication
- Use foreign keys for relationships

### Indexing Strategy

Одиночные индексы на внешних ключах и часто фильтруемых полях (`cage_id`,
`breed_id`, `status` у `rabbits` и т.п.) заведены как обычные, безымянные
Sequelize-индексы прямо в моделях (`fields: [...]` в `indexes:` блоке) —
своих имён у них нет, искать по названию бессмысленно.

Именованные составные индексы — отдельная миграция
[`20260826000004-index-tenant-tables-by-farm.js`](../backend/migrations/20260826000004-index-tenant-tables-by-farm.js),
и `farm_id` в них всегда первым — с него начинается любая выборка (см.
«Многоарендность»), без этого MySQL поднимал бы строки всех ферм и
отбрасывал чужие уже после чтения:

```sql
CREATE INDEX idx_rabbits_farm_status ON rabbits(farm_id, status);
CREATE INDEX idx_rabbits_farm_cage ON rabbits(farm_id, cage_id);
CREATE INDEX idx_rabbits_farm_breed ON rabbits(farm_id, breed_id);
CREATE INDEX idx_cages_farm_condition ON cages(farm_id, condition);
CREATE INDEX idx_breedings_farm_status ON breedings(farm_id, status);
CREATE INDEX idx_breedings_farm_expected ON breedings(farm_id, expected_birth_date);
CREATE INDEX idx_births_farm_date ON births(farm_id, birth_date);
CREATE INDEX idx_tasks_farm_status_due ON tasks(farm_id, status, due_date);
CREATE INDEX idx_tasks_farm_assignee ON tasks(farm_id, assigned_to);
CREATE INDEX idx_transactions_farm_date ON transactions(farm_id, transaction_date);
CREATE INDEX idx_transactions_farm_type_date ON transactions(farm_id, type, transaction_date);
CREATE INDEX idx_feeding_farm_fed_at ON feeding_records(farm_id, fed_at);
CREATE INDEX idx_vaccinations_farm_next ON vaccinations(farm_id, next_vaccination_date);
CREATE INDEX idx_vaccinations_farm_date ON vaccinations(farm_id, vaccination_date);
CREATE INDEX idx_medical_farm_started ON medical_records(farm_id, started_at);
CREATE INDEX idx_medical_farm_outcome ON medical_records(farm_id, outcome);
CREATE INDEX idx_weights_farm_rabbit ON rabbit_weights(farm_id, rabbit_id);
CREATE INDEX idx_photos_farm_rabbit ON photos(farm_id, rabbit_id);
CREATE INDEX idx_notes_farm_rabbit ON notes(farm_id, rabbit_id);
```

Полнотекстового поиска в проекте нет — ни одного `FULLTEXT`-индекса ни в
одной миграции, поиск по кроликам делает обычный `LIKE`.

### Data Integrity
- Foreign key constraints with CASCADE/RESTRICT
- NOT NULL for required fields
- CHECK constraints for valid values
- UNIQUE constraints where needed

## 🏡 Многоарендность (изоляция ферм)

Сервис обслуживает много независимых хозяйств. Данные одного клиента не
должны быть видны другому ни при каком запросе — это главное свойство
системы, и держится оно на схеме, а не на аккуратности кода.

**Ферма — сущность, а не формула.** Таблица `farms` хранит хозяйство:
название и владельца. У пользователя есть `farm_id NOT NULL`, у каждой
таблицы с данными фермы — тоже. Раньше фермой считался идентификатор
владельца, а принадлежность вычислялась выражением `user.owner_id || user.id`
в middleware: единственная граница между клиентами жила в коде.

```
farms ──< users
      ──< breeds, cages, feeds, rabbits, rabbit_weights
      ──< breedings, births, vaccinations, medical_records
      ──< feeding_records, transactions, tasks, photos, notes
      ──< invitations
```

**Правила**

1. `req.farmId` берётся из `users.farm_id` и больше ниоткуда.
2. Всякая выборка из таблицы фермы обязана нести `farm_id` в `where`.
   `findByPk` для таких таблиц не применяется — только
   `findOne({ where: { id, farm_id } })`.
3. Всякая запись обязана проставлять `farm_id`, включая те, что сервер
   создаёт сам: автоматические расходы на лечение и задачи по случке.
4. «Кто внёс» (`created_by`, `fed_by`, `assigned_to`, `uploaded_by`) — это
   не «чьё». Эти поля обнуляемы и для отбора по ферме непригодны: именно
   поэтому операции работника когда-то пропадали из ведомости владельца.

**Удаление хозяйства.** `users.farm_id` и все таблицы фермы стоят с
`ON DELETE CASCADE`, поэтому отключение клиента — одна операция:
`DELETE FROM farms WHERE id = ?` уносит его данные и не трогает соседей.
`farms.owner_id` намеренно стоит с `ON DELETE SET NULL`, а не с `RESTRICT`:
встречный `RESTRICT` замыкал круг с `users.farm_id` и делал удаление фермы
невозможным вовсе. Правило «у фермы должен быть хозяин» — правило продукта,
и живёт оно в `staffService`, который отказывается трогать владельца.

**Страховка.** `src/utils/tenancy.js` вешает на все таблицы фермы хуки
`beforeFind`, `beforeCount`, `beforeBulkDestroy` и `beforeBulkUpdate` —
запрос без условия по `farm_id` не выполняется вовсе, вместо тихой выдачи
(или порчи) чужих строк получается громкий отказ. `beforeCreate` и
`beforeBulkCreate` отдельно требуют `farm_id` у самой записи. Осознанное
исключение объявляется явно: `{ tenantScope: 'all' }`, и такое исключение
видно в diff.

`Model.sum`, `Model.max` и `Model.min` в Sequelize реализованы через
`aggregate()`, который обычные хуки не запускает — этот путь закрыт
отдельно: `tenancy.js` подменяет `model.aggregate`, прогоняя те же
проверки перед вызовом оригинала.

Точечные `instance.destroy()` / `instance.update()` хук не проверяет: до
них можно дойти только через уже проверенный `find`, которым инстанс был
получен.

## 🔔 Push-уведомления (FCM)

Push — опциональная интеграция, а не обязательная часть стенда. Без
`FIREBASE_PROJECT_ID`/`FIREBASE_CLIENT_EMAIL`/`FIREBASE_PRIVATE_KEY` в `.env`
`notificationService` тихо ничего не отправляет и логирует предупреждение —
сервис не должен отказываться стартовать только потому, что Firebase-проект
ещё не заведён. Мобильный клиент устроен так же: без `google-services.json`
`Firebase.initializeApp()` перехватывается try/catch в `main.dart`, и
приложение продолжает работать без push.

**Устройство ⇄ пользователь.** Таблица `device_tokens` хранит FCM-токен,
привязанный к `user_id` и `farm_id` — не сам факт «пуш пришёл», а то, кому
его слать. Уникальность по токену, а не по паре (user, token): устройство
может сменить владельца (логаут одного работника, логин другого на том же
телефоне), и `upsert` переписывает `user_id`, а не плодит вторую строку.
Модель заведена в `TENANT_MODELS` — как и у любой таблицы фермы, выборка без
`farm_id` в `where` не выполнится.

**Дайджест, а не пуш на каждую просрочку.** Просроченные вакцинации, задачи
без исполнителя и низкий остаток корма собираются раз в сутки, в 08:00
(`node-cron`, `src/jobs/notificationDigestJob.js`) — один пуш на категорию на
ферму, а не пять, если просрочек пять. Исключение — задача с назначенным
исполнителем: тому шлётся точечный пуш по этой конкретной задаче, а не в
общий счёт владельцу. Событийные уведомления (новая заметка, назначение
задачи) остаются мгновенными и идут прямо из `noteService`/`taskService`
после успешного `create`, в отдельной цепочке промисов — сбой отправки
пуша логируется, но никогда не откатывает и не задерживает ответ на запись.

**Тап по уведомлению** ведёт на конкретную запись там, где она вообще
существует: у назначенной задачи, просроченной задачи с исполнителем и
новой заметки в `data.route` теперь готовый путь с id (`/tasks/42`,
`/notes/7`) — мобильный роутер грузит сущность по id и открывает её
привычную форму редактирования (`/vaccinations/:id`, `/feeds/:id`,
`/tasks/:id`, `/notes/:id` — тот же паттерн, что у `/rabbits/:id`).
Дайджесты (просроченные вакцинации, низкий остаток корма, просроченные
задачи без исполнителя) по-прежнему ведут на список без фильтра — это
агрегат по ферме, а не одна запись, конкретной цели для перехода там нет.

**Android — основная платформа, iOS — код и Xcode-проект готовы, доставка
не настроена.** `firebase_messaging` написан платформенно-независимо, в
`ios/Runner` уже прописаны `Runner.entitlements` (`aps-environment`) и
`UIBackgroundModes: remote-notification`. Не хватает того, что нельзя
завести без внешних учёток: Apple Developer аккаунта, APNs-ключа (.p8),
привязки его к проекту в Firebase Console и файла
`GoogleService-Info.plist` для `ios/Runner` — отдельный шаг, не блокирующий
Android. Web push не поддерживается вовсе (нужны VAPID-ключ и service
worker) — код опущен под `kIsWeb`.

## 🔐 Security Architecture

### Authentication
- **JWT** with HS256 algorithm (symmetric secret, `backend/src/config/jwt.js` — not RS256/RSA keypair)
- **Access Token**: 15 minutes (short-lived)
- **Refresh Token**: 7 days, stored in `refresh_tokens` table; the client keeps its copy in `flutter_secure_storage` — no httpOnly cookie exists anywhere in the stack
- **Password**: bcrypt with salt rounds 10

### Authorization

Три роли (`owner`, `manager`, `worker`), без гранулярных permission-строк
вроде `write:rabbits` — `authorize` просто сверяет роль пользователя со
списком разрешённых для роута, а `owner` всегда проходит:

```javascript
// backend/src/middleware/auth.js
const authorize = (allowedRoles = []) => (req, res, next) => {
  if (req.user.role === 'owner') return next();
  if (!allowedRoles.includes(req.user.role)) {
    return ApiResponse.forbidden(res, 'Недостаточно прав');
  }
  next();
};

// Usage — authenticate на весь роутер, authorize точечно на чувствительных операциях
router.use(authenticate);
router.delete('/:id', authorize(['owner']), deleteRabbit);   // удаление кролика — только owner
```

**Реальная матрица прав** (по `grep authorize( src/routes/*.js`, без роута —
доступно всем трём ролям):

| Действие | worker | manager | owner |
|---|---|---|---|
| Читать (списки, карточки, статистика) везде | ✅ | ✅ | ✅ |
| Создавать/править кормление, вакцинации, медкарты, заметки, задачи | ✅ | ✅ | ✅ |
| Завершить задачу (`/tasks/:id/complete`) | ✅ | ✅ | ✅ |
| Создавать/править кроликов, клетки, породы, случки, рождения, корма | ❌ | ✅ | ✅ |
| Финансы: транзакции, финансовый отчёт, себестоимость лечения, доходы по кролику | ❌ | ✅ | ✅ |
| Удалять кормление/заметку/задачу | ❌ | ✅ | ✅ |
| Удалять кролика/клетку/породу/корм/случку/рождение/вакцинацию/медкарту/транзакцию | ❌ | ❌ | ✅ |
| Работники: список, приглашения (просмотр) | ❌ | ✅ | ✅ |
| Работники: пригласить, отозвать приглашение, сбросить пароль, изменить роль, передать хозяйство | ❌ | ❌ | ✅ |

Она не выведена из абстрактного правила («owner может всё, manager —
хозяйство без кадров и без удалений, worker — только текучка») — это
наблюдение по факту, а не документированный принцип в коде: где `authorize`
не указан явно на POST/PUT, роут открыт для всех трёх ролей, включая worker.

### Input Validation
```javascript
// Using Joi
const createRabbitSchema = Joi.object({
  name: Joi.string().min(1).max(100).required(),
  breed_id: Joi.number().integer().positive().required(),
  sex: Joi.string().valid('male', 'female').required(),
  birth_date: Joi.date().max('now').required(),
  // ...
});
```

### File Upload Security
- Whitelist MIME types: `image/jpeg, image/png, image/jpg, image/webp` (`.env` → `ALLOWED_FILE_TYPES`, fallback в `config/multer.js` без `webp`, если переменная не задана)
- Max file size: 5MB (`MAX_FILE_SIZE`)
- Filename полностью генерируется на сервере (`utils/fileStorage.js`) — имя, пришедшее от клиента, никогда не используется как есть, а не просто «очищается»
- **Хранилище — MinIO, не локальный диск.** `multer` держит файл в памяти
  (`memoryStorage`), `fileStorage.uploadFile` кладёт его в бакет; `GET
  /uploads/:folder/:filename` — тонкий прокси-роут (`routes/files.routes.js`),
  который читает объект из MinIO и отдаёт с `Content-Type` из метаданных
  объекта, а не угадывает по расширению. Формат `photo_url` в БД не
  поменялся (`/uploads/rabbits/<файл>`), поэтому это внутренняя замена
  бэкенда, а не смена контракта для мобильного клиента.
- Авторизации на самом маршруте раздачи по-прежнему нет — как и раньше,
  единственная защита это непредсказуемое имя файла (timestamp+random).
  Кто угодно с URL может посмотреть фото; получить чужой URL, не зная его
  и не имея доступа к ферме, нельзя.
- Сканирование на вирусы не подключено (ClamAV или аналог — не реализовано, не только «опционально»)

## 📊 Performance Optimizations

### Backend
- **Connection Pooling**: MySQL pool size 10-20
- **Query Optimization**: Use indexes, avoid N+1 queries
- **Caching**: Redis не подключён (ни в коде, ни в зависимостях) — для MVP не потребовался
- **Pagination**: Limit 20-50 items per page
- **Compression**: gzip for responses
- **CDN**: For static assets (future)

### Flutter
- **Image Optimization**:
  - Compress to 80% quality
  - Resize to max 1920px
  - Use `cached_network_image` for caching
- **Lazy Loading**:
  - ListView.builder for lists
  - Pagination for large datasets
- **State Management**:
  - Use `select` to listen to specific state changes
  - Avoid unnecessary rebuilds
- **Bundle Size**:
  - Remove unused dependencies
  - Enable tree shaking
  - Use ProGuard/R8

## 📱 App Lifecycle

Очередь синхронизации и конфликт-резолюшн не реализованы — см. «Работа без
сети» выше. Реальный старт приложения (`main.dart`):

```
App Start
├─► Firebase.initializeApp() — в try/catch, без ключей push просто выключен
├─► initializeDateFormatting('ru') — даты и числа по-русски
├─► runApp(ProviderScope(MyApp()))
└─► Если запуск был тапом по push из полностью закрытого состояния —
    дождаться первого кадра и передать управление handleMessageTap
```

`redirect` в `GoRouter` сам решает, куда вести неавторизованного/
авторизованного пользователя при каждой навигации — отдельного шага
«проверить авторизацию на старте» не требуется.

## 🧪 Testing Strategy

### Backend Tests
- **Unit Tests**: Services, utils (Jest)
- **Integration Tests**: API endpoints (Supertest)
- **E2E Tests**: Complete workflows (optional)

### Flutter Tests
`mobile/test/` — unit- и widget-тесты (access, api, auth, breeding, domain,
json, l10n, models, screens, utils). Golden-тестов (снапшоты UI) нет ни
одного, отдельной папки `integration_test/` тоже нет.

### Coverage Target
- Backend: порог реально задан в `backend/jest.config.js`
  (`branches 70 / functions 80 / lines 80 / statements 80`)
- Flutter: порог покрытия нигде не настроен — цифры для него нет

## 📈 Monitoring & Logging

### Backend Logging
```javascript
// Winston logger
logger.info('User logged in', { userId: user.id });
logger.error('Database error', { error: err.message, stack: err.stack });
```

### Error Tracking
- **Sentry** не подключён (ни в `backend/package.json`, ни в `mobile/pubspec.yaml`) — в проде ошибки видны только по логам и жалобам пользователей
- **Log files** with rotation (7 days retention)

### Metrics
- API response times
- Error rates
- Active users
- Database query performance

---

## 🎯 Реализованные модули и возможности

### Модули (16/16)

| # | Модуль | Backend | Mobile | Возможности |
|---|--------|---------|--------|-------------|
| 1 | **Auth & Farm** | ✅ | ✅ | JWT токены, Login, Register (с названием фермы), Refresh, Change Password |
| 2 | **Staff** | ✅ | ✅ | Приглашения, роли, сброс пароля, передача хозяйства фермы |
| 3 | **Rabbits** | ✅ | ✅ | CRUD, Статистика, Фильтрация, Родословная |
| 4 | **Breeds** | ✅ | ✅ | CRUD пород, Характеристики |
| 5 | **Cages** | ✅ | ✅ | CRUD, Автоматические статусы (occupied/available) |
| 6 | **Breeding** | ✅ | ✅ | Планирование случек, Отслеживание статусов |
| 7 | **Births** | ✅ | ✅ | Регистрация рождений, Связь со случками |
| 8 | **Vaccinations** | ✅ | ✅ | CRUD, Upcoming/Overdue, Статистика |
| 9 | **Medical Records** | ✅ | ✅ | История болезней, Типы записей |
| 10 | **Feeds** | ✅ | ✅ | Управление кормами, Контроль остатков |
| 11 | **Feeding Records** | ✅ | ✅ | Автоматическое списание со склада |
| 12 | **Transactions** | ✅ | ✅ | Доходы/расходы, Категории, Статистика |
| 13 | **Tasks** | ✅ | ✅ | Планирование, Приоритеты, Overdue tracking |
| 14 | **Reports** | ✅ | ✅ | Dashboard, Farm/Health/Financial отчеты |
| 15 | **Notes** | ✅ | ✅ | Заметка по кролику, клетке или ферме в целом — пятый тип записи в Дневнике |
| 16 | **Push-уведомления** | ✅ | ✅ | FCM: просроченные вакцинации/задачи/корм (дайджест раз в сутки), назначение задачи и новая заметка — мгновенно |

### Backend API - 116 эндпоинтов

**Статистика:**
- 16 контроллеров
- 21 модель БД
- 17 роутов + index.js (16 под `/api/v1` + `files.routes.js`, раздающий `/uploads` из MinIO напрямую)
- 15 валидаторов Joi (+ listQuery.js, messages.js — общие хелперы)
- JWT аутентификация
- Многоарендность: изоляция по ферме на find/count/aggregate/create/destroy/update (см. раздел «Многоарендность»)

**Ключевые возможности Backend:**
- ✅ Автоматическое списание кормов при кормлении
- ✅ Автоматическое обновление статусов клеток
- ✅ Отслеживание просроченных вакцинаций
- ✅ Отслеживание просроченных задач
- ✅ Агрегация данных для отчетов
- ✅ Фильтрация по множественным параметрам
- ✅ Пагинация всех списков
- ✅ Статистика по всем модулям
- ✅ Push-уведомления (FCM): дайджест просрочек раз в сутки + мгновенные события

### Mobile App - 49 экранов

**Статистика (пересчитано 2026-09-07):**
- 90 @freezed классов (20 файлов моделей)
- 110 Riverpod провайдеров (все написаны вручную — riverpod_generator в проекте не используется, несмотря на зависимость в pubspec.yaml)
- 18 репозиториев
- 49 экранов (`presentation/screens/*.dart`)
- 56 маршрутов (`GoRoute` в `app_router.dart`)

**Реализованные экраны (49, пересчитано 2026-09-07 по `presentation/screens/`):**
1. Auth: Login, Register
2. Onboarding: Splash, Welcome, FarmName, FarmType, Ready
3. Home: Today, Farm, Journal, MainNavigation
4. Rabbits: RabbitsList, RabbitDetail, RabbitForm, Herd, Pedigree, WeightHistory, BreedsList, BreedForm, BreedingPlanner, BirthsList, BirthForm
5. Breeding: BreedingCycle, BreedingDetail, BreedingForm
6. Cages: CagesList, CageDetail, CageForm
7. Health: HealthJournal, VaccinationsList, VaccinationForm, MedicalRecordsList, MedicalRecordForm
8. Feeding: FeedsList, FeedForm, FeedStatistics, FeedingRecordsList, FeedingRecordForm, FeedingStatistics
9. Finance: TransactionsList, TransactionForm, TransactionStatistics
10. Tasks: TasksList, TaskForm
11. Notes: NoteForm (заметки прикрепляются к дневнику, отдельного списка нет)
12. Reports: Reports (Farm/Health/Finance — переключаются сегментами на одном экране, не отдельные роуты; финансы скрыты от роли worker)
13. Staff: Staff, JoinFarm
14. Settings: Settings

**Ключевые возможности Mobile:**
- ✅ Material Design 3
- ✅ Цветовая кодировка (статусы, приоритеты)
- ✅ Фильтрация и поиск
- ✅ Pull-to-refresh
- ✅ Пагинация
- ✅ Формы с валидацией
- ✅ DatePicker/TimePicker
- ✅ Навигация go_router

### Интеграция

**Backend ↔ Mobile:**
- ✅ REST API через Dio HTTP client
- ✅ JWT аутентификация с автообновлением
- ✅ Единый формат ApiResponse
- ✅ Обработка ошибок
- ✅ Типизированные модели (Freezed ↔ Sequelize)

---

## 📊 Финальная статистика проекта

### Написано кода (пересчитано 2026-09-07, `wc -l`):
- **Backend:** ~15,400 строк (`backend/src`, без тестов)
- **Mobile:** ~43,100 строк (`mobile/lib`, без `.freezed.dart`/`.g.dart` — со
  сгенерированным кодом выходит ~74,000)
- **Всего:** ~58,500 строк написанного кода

Прежние цифры (~10,000 / ~15,000 / ~25,000) сильно отставали от факта —
особенно по mobile, где реальный объём почти втрое больше заявленного.

### Покрытие функционала:
- **Модули:** 16/16
- **API эндпоинты:** 116
- **Модели БД (backend):** 21
- **UI экраны:** 49
- **Backend-тесты:** 1156 (741 юнит + 415 интеграционных)

### Готовность:
- ✅ Backend API с многоарендностью (изоляция ферм на всех операциях с данными)
- ✅ Полнофункциональное mobile приложение
- ✅ Безопасность (JWT, bcrypt, валидация, tenancy-хук)
- ✅ Push-уведомления (FCM) — Android; iOS код готов, доставка не настроена (нет APNs)
- ✅ Автоматизация бизнес-процессов

---

**Architecture Version**: 2.5
**Last Updated**: 2026-09-07
**Project Status**: Активная разработка — базовый функционал, многоарендность, передача хозяйства фермы и push-уведомления готовы

**Аудит устаревших сведений (2026-09-07, первый проход):** документ писался
частично как шаблон до того, как код был написан, и часть разделов с тех пор
разошлась с реальностью — offline/sync, дерево `lib/`, примеры
Riverpod/GoRouter, Authorization, часть структуры backend, Golden-тесты,
Redis/Sentry/ClamAV. Все такие разделы выше приведены в соответствие с кодом
по состоянию на эту дату; разделы «Многоарендность» и «Push-уведомления» уже
были точными и не менялись.

**Аудит устаревших сведений (2026-09-07, второй проход):** первый проход сам
пропустил часть неточностей — второй, сделанный двумя параллельными агентами
по конкретным пунктам (не «на глаз»), нашёл и поправил ещё: JWT-алгоритм
(было RS256, на деле HS256), второй экземпляр того же примера с
`authorize(['manager','owner'])` на удалении кролика (реально — `['owner']`,
первый экземпляр в разделе Authorization уже был исправлен отдельно, этот
пропустили), «файлы вне веб-рута» (на деле отдаются через
`express.static('/uploads')`, то есть внутри), раздел индексов БД (три
несуществующих индекса и вымышленный FULLTEXT — заменены реальным списком из
миграции), число маршрутов GoRouter (52 → 56). Заодно нашлись и настоящие
баги, не только неточности в тексте: `docker-compose.yml` не пробрасывал
`ALLOW_REGISTRATION`/`FIREBASE_*` в контейнер `api` (из-за этого локальный
стенд по умолчанию держал регистрацию открытой, а не закрытой, как
предполагает `.env.example`) — исправлено; и в мобильном приложении право
«удалять записи» было одним булевым капабилити на все типы записей, хотя
сервер разрешает удаление кормления/заметок/задач менеджеру, а не только
владельцу, и наоборот — на нескольких экранах (кролики, клетки, окролы,
породы, случки) кнопка удаления или вовсе не проверяла роль, или проверяла
не ту — на семи экранах пользователь видел действие, которое сервер бы
отклонил 403. Разошлось с кодом даже то, что уже однажды «актуализировали»:
второй проход стоит повторять, а не считать разовой процедурой.
