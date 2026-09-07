# RabbitFarm - System Architecture

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                      │
│                      (Android Primary)                      │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────┐     │
│  │ Presentation│  │  Business   │  │  Data Layer      │     │
│  │   Layer     │◄─┤   Logic     │◄─┤  (Local + Remote)│     │
│  │  (Widgets)  │  │  (Riverpod) │  │                  │     │
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

### Clean Architecture Layers

```
lib/
├── core/                           # Core functionality
│   ├── api/
│   │   ├── api_client.dart         # Dio HTTP client
│   │   ├── api_interceptor.dart    # JWT interceptor
│   │   ├── api_exception.dart      # Custom exceptions
│   │   └── endpoints.dart          # API endpoints constants
│   ├── database/
│   │   ├── app_database.dart       # SQLite database
│   │   ├── dao/                    # Data Access Objects
│   │   └── entities/               # Local entities
│   ├── theme/
│   │   ├── app_theme.dart          # Material 3 theme
│   │   ├── colors.dart             # Color palette
│   │   └── text_styles.dart        # Typography
│   ├── router/
│   │   ├── app_router.dart         # GoRouter configuration
│   │   └── route_guards.dart       # Auth guards
│   ├── utils/
│   │   ├── date_utils.dart         # Date helpers
│   │   ├── validators.dart         # Form validators
│   │   ├── image_utils.dart        # Image compression
│   │   └── constants.dart          # App constants
│   └── errors/
│       ├── failures.dart           # Failure types
│       └── error_handler.dart      # Global error handling
│
├── features/                       # Feature modules (13 модулей)
│   ├── auth/                       # ✅ Аутентификация, регистрация фермы
│   │   ├── data/
│   │   │   ├── models/             # Freezed JSON models
│   │   │   └── repositories/       # Repository implementations
│   │   └── presentation/
│   │       ├── providers/          # Riverpod providers
│   │       └── screens/            # Login, Register
│   │
│   ├── rabbits/                    # ✅ Управление кроликами
│   │   ├── data/
│   │   │   ├── models/             # RabbitModel, BreedModel, Pedigree
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       └── screens/            # List, Detail, Form, Pedigree
│   │
│   ├── cages/                      # ✅ Клетки
│   │   ├── data/
│   │   │   ├── models/             # CageModel
│   │   │   └── repositories/
│   │   └── presentation/
│   │       └── screens/            # List, Detail, Form
│   │
│   ├── breeding/                   # ✅ Разведение (Случки и Рождения)
│   │   ├── data/
│   │   │   ├── models/             # BreedingModel, BirthModel
│   │   │   └── repositories/
│   │   └── presentation/
│   │       └── screens/            # BreedingPlanner, BirthsList, Forms
│   │
│   ├── health/                     # ✅ Здоровье (Вакцинация + Медкарты)
│   │   ├── data/
│   │   │   ├── models/             # Vaccination, MedicalRecord
│   │   │   └── repositories/
│   │   └── presentation/
│   │       └── screens/            # VaccinationsList, MedicalRecordsList, Forms
│   │
│   ├── feeding/                    # ✅ Корма и кормление
│   │   ├── data/
│   │   │   ├── models/             # Feed, FeedingRecord
│   │   │   └── repositories/
│   │   └── presentation/
│   │       └── screens/            # FeedsList, FeedingRecordsList, Forms
│   │
│   ├── finance/                    # ✅ Финансы (Транзакции)
│   │   ├── data/
│   │   │   ├── models/             # Transaction, Statistics
│   │   │   └── repositories/
│   │   └── presentation/
│   │       └── screens/            # TransactionsList, Form
│   │
│   ├── tasks/                      # ✅ Задачи
│   │   ├── data/
│   │   │   ├── models/             # Task, TaskStatistics
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/          # tasksProvider, taskActionsProvider
│   │       └── screens/            # TasksList, TaskForm
│   │
│   ├── reports/                    # ✅ Отчеты и Dashboard
│   │   ├── data/
│   │   │   ├── models/             # DashboardReport, FarmReport, HealthReport, FinancialReport
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/          # dashboardReportProvider
│   │       └── screens/            # DashboardScreen
│   │
│   ├── staff/                      # ✅ Работники, приглашения, передача хозяйства
│   ├── home/                       # ✅ Дневник фермы, сегодня, быстрая запись
│   ├── onboarding/                 # ✅ Регистрация фермы, первый вход
│   └── settings/                   # ✅ Настройки приложения
│
├── shared/                         # Shared across features
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_view.dart
│   │   ├── empty_state.dart
│   │   ├── image_picker_widget.dart
│   │   └── date_picker_field.dart
│   ├── models/
│   │   └── paginated_response.dart
│   └── providers/
│       ├── connectivity_provider.dart
│       └── sync_provider.dart
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

**Example Structure:**
```dart
// Domain Entity
class Rabbit {
  final String id;
  final String name;
  final String breed;
  // ...
}

// Repository Interface
abstract class RabbitRepository {
  Future<List<Rabbit>> getRabbits();
  Future<Rabbit> getRabbitById(String id);
  Future<void> createRabbit(Rabbit rabbit);
}

// Use Case
class GetRabbitsUseCase {
  final RabbitRepository repository;

  Future<List<Rabbit>> call() => repository.getRabbits();
}

// Provider
final rabbitsProvider = StateNotifierProvider<RabbitsNotifier, AsyncValue<List<Rabbit>>>((ref) {
  return RabbitsNotifier(ref.watch(rabbitRepositoryProvider));
});

// State Notifier
class RabbitsNotifier extends StateNotifier<AsyncValue<List<Rabbit>>> {
  final RabbitRepository _repository;

  RabbitsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRabbits();
  }

  Future<void> loadRabbits() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getRabbits());
  }
}
```

### Navigation (GoRouter)

```dart
final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    final isAuthRoute = state.location.startsWith('/auth');

    if (!isAuthenticated && !isAuthRoute) return '/auth/login';
    if (isAuthenticated && isAuthRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => SplashScreen()),
    GoRoute(
      path: '/auth',
      builder: (_, __) => AuthWrapper(),
      routes: [
        GoRoute(path: 'login', builder: (_, __) => LoginScreen()),
        GoRoute(path: 'register', builder: (_, __) => RegisterScreen()),
      ],
    ),
    ShellRoute(
      builder: (_, __, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => DashboardScreen()),
        GoRoute(
          path: '/rabbits',
          builder: (_, __) => RabbitsListScreen(),
          routes: [
            GoRoute(path: ':id', builder: (_, state) => RabbitDetailScreen(id: state.params['id']!)),
            GoRoute(path: 'add', builder: (_, __) => AddRabbitScreen()),
          ],
        ),
        // More routes...
      ],
    ),
  ],
);
```

### Offline Strategy

**Three-Layer Approach:**
1. **Remote Data Source** - API calls
2. **Local Data Source** - SQLite cache
3. **Repository** - Orchestrates both

```dart
class RabbitRepositoryImpl implements RabbitRepository {
  final RabbitRemoteDataSource remoteDataSource;
  final RabbitLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<List<Rabbit>> getRabbits() async {
    if (await networkInfo.isConnected) {
      try {
        final rabbits = await remoteDataSource.getRabbits();
        await localDataSource.cacheRabbits(rabbits); // Update cache
        return rabbits;
      } catch (e) {
        // Fallback to cache on error
        return await localDataSource.getCachedRabbits();
      }
    } else {
      // Offline: use cache
      return await localDataSource.getCachedRabbits();
    }
  }

  @override
  Future<void> createRabbit(Rabbit rabbit) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.createRabbit(rabbit);
      await localDataSource.cacheRabbit(rabbit);
    } else {
      // Save to pending sync queue
      await localDataSource.addToPendingSync(rabbit);
    }
  }
}
```

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
│   │   └── multer.js               # File upload config
│   │
│   ├── middleware/
│   │   ├── auth.js                 # JWT verification
│   │   ├── validation.js           # Request validation
│   │   ├── errorHandler.js         # Global error handler
│   │   ├── rateLimiter.js          # Rate limiting
│   │   └── upload.js               # File upload handler
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
│   ├── routes/                     # ✅ 16 роутов + index.js
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
│   │   └── device-token.routes.js  # /device-tokens - регистрация устройств для push
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
│       └── apiResponse.js          # Standardized responses
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

```javascript
app.use('/api/v1/rabbits', [
  auth,              // 1. Verify JWT
  rateLimiter,       // 2. Rate limiting
  validate(schema),  // 3. Request validation
  rabbitController   // 4. Handle request
]);
```

## 🗄️ Database Design Principles

### Normalization
- 3NF (Third Normal Form)
- Avoid data duplication
- Use foreign keys for relationships

### Indexing Strategy
```sql
-- Primary keys (automatic)
-- Foreign keys
CREATE INDEX idx_rabbits_cage_id ON rabbits(cage_id);
CREATE INDEX idx_breedings_male_id ON breedings(male_id);
CREATE INDEX idx_breedings_female_id ON breedings(female_id);

-- Frequently filtered fields
CREATE INDEX idx_rabbits_status ON rabbits(status);
CREATE INDEX idx_rabbits_breed_id ON rabbits(breed_id);

-- Composite indexes for common queries
-- Ферма идёт первой: с неё начинается любая выборка (см. «Многоарендность»).
CREATE INDEX idx_tasks_farm_status_due ON tasks(farm_id, status, due_date);
CREATE INDEX idx_transactions_farm_type_date ON transactions(farm_id, type, transaction_date);

-- Full-text search
CREATE FULLTEXT INDEX idx_rabbits_search ON rabbits(name, tag_id);
```

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

**Тап по уведомлению** ведёт на список (`/vaccinations`, `/feeds`, `/tasks`,
`/today` для заметок), не на конкретную карточку: у vaccination/feed/note
нет маршрута по id в мобильном роутере — это ограничение существовало и до
push, чинить его отдельная задача.

**Android — основная платформа, iOS — код готов, доставка не настроена.**
`firebase_messaging` написан платформенно-независимо, но включение iOS
требует APNs-ключ и Apple Developer аккаунт — отдельный шаг, не блокирующий
Android. Web push не поддерживается вовсе (нужны VAPID-ключ и service
worker) — код опущен под `kIsWeb`.

## 🔐 Security Architecture

### Authentication
- **JWT** with RS256 algorithm
- **Access Token**: 15 minutes (short-lived)
- **Refresh Token**: 7 days (stored in httpOnly cookie or secure storage)
- **Password**: bcrypt with salt rounds 10

### Authorization
```javascript
// Role-based access control
const roles = {
  OWNER: ['all'],
  MANAGER: ['read:all', 'write:rabbits', 'write:health', 'write:tasks'],
  WORKER: ['read:rabbits', 'read:tasks', 'write:tasks']
};

// Middleware
const authorize = (permissions) => (req, res, next) => {
  const userRole = req.user.role;
  const hasPermission = roles[userRole].some(p =>
    p === 'all' || permissions.includes(p)
  );

  if (!hasPermission) return res.status(403).json({ error: 'Forbidden' });
  next();
};

// Usage
router.delete('/rabbits/:id', authorize(['write:rabbits']), deleteRabbit);
```

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
- Whitelist MIME types (image/jpeg, image/png)
- Max file size: 5MB
- Sanitize filenames
- Store outside web root
- Virus scanning (optional, using ClamAV)

## 📊 Performance Optimizations

### Backend
- **Connection Pooling**: MySQL pool size 10-20
- **Query Optimization**: Use indexes, avoid N+1 queries
- **Caching**: Redis for frequently accessed data (optional for MVP)
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

## 🔄 Sync Strategy (Offline Mode)

### Conflict Resolution
```
1. Last-Write-Wins (LWW)
   - Use updated_at timestamp
   - Server timestamp is source of truth

2. Pending Operations Queue
   - Store failed operations locally
   - Retry on reconnection
   - Show sync status to user

3. Sync Flow
   ├─► Device comes online
   ├─► Fetch server updates since last sync
   ├─► Apply server changes to local DB
   ├─► Upload pending local changes
   ├─► Resolve conflicts (if any)
   └─► Mark sync complete
```

## 📱 App Lifecycle

```
App Start
├─► Check authentication
├─► Initialize local database
├─► Check network connectivity
├─► Sync data (if online)
└─► Navigate to appropriate screen

Background
├─► Stop active operations
├─► Save state
└─► Listen for notifications

Foreground Resume
├─► Restore state
├─► Check for updates
└─► Sync if needed
```

## 🧪 Testing Strategy

### Backend Tests
- **Unit Tests**: Services, utils (Jest)
- **Integration Tests**: API endpoints (Supertest)
- **E2E Tests**: Complete workflows (optional)

### Flutter Tests
- **Unit Tests**: Business logic, utils
- **Widget Tests**: Individual widgets
- **Integration Tests**: Complete flows
- **Golden Tests**: UI snapshot testing

### Coverage Target
- Backend: 80%+
- Flutter: 70%+

## 📈 Monitoring & Logging

### Backend Logging
```javascript
// Winston logger
logger.info('User logged in', { userId: user.id });
logger.error('Database error', { error: err.message, stack: err.stack });
```

### Error Tracking
- **Sentry** (optional) for production error tracking
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

### Backend API - 115 эндпоинтов

**Статистика:**
- 16 контроллеров
- 21 модель БД
- 16 роутов + index.js
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
- 52 маршрута (`GoRoute` в `app_router.dart`)

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
- **API эндпоинты:** 115
- **Модели БД (backend):** 21
- **UI экраны:** 49
- **Backend-тесты:** 1151 (736 юнит + 415 интеграционных)

### Готовность:
- ✅ Backend API с многоарендностью (изоляция ферм на всех операциях с данными)
- ✅ Полнофункциональное mobile приложение
- ✅ Безопасность (JWT, bcrypt, валидация, tenancy-хук)
- ✅ Push-уведомления (FCM) — Android; iOS код готов, доставка не настроена (нет APNs)
- ✅ Автоматизация бизнес-процессов

---

**Architecture Version**: 2.3
**Last Updated**: 2026-09-07
**Project Status**: Активная разработка — базовый функционал, многоарендность, передача хозяйства фермы и push-уведомления готовы
