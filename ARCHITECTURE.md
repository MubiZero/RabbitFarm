# RabbitFarm - System Architecture

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                       │
│                      (Android Primary)                       │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────┐   │
│  │ Presentation│  │  Business   │  │  Data Layer      │   │
│  │   Layer     │◄─┤   Logic     │◄─┤  (Local + Remote)│   │
│  │  (Widgets)  │  │  (Riverpod) │  │                  │   │
│  └─────────────┘  └─────────────┘  └──────────────────┘   │
│                                            │                 │
│                                            │                 │
└────────────────────────────────────────────┼─────────────────┘
                                             │
                                             │ HTTPS/REST
                                             │
                        ┌────────────────────▼──────────────────────┐
                        │        Backend API (Express.js)           │
                        │  ┌──────────┐  ┌──────────┐  ┌────────┐ │
                        │  │  Routes  │─►│ Services │─►│ Models │ │
                        │  └──────────┘  └──────────┘  └────────┘ │
                        │       │              │            │       │
                        │       ▼              ▼            ▼       │
                        │  ┌──────────────────────────────────┐   │
                        │  │      Middleware (Auth, etc)      │   │
                        │  └──────────────────────────────────┘   │
                        └───────────────────┬───────────────────────┘
                                            │
                                            │ SQL
                                            │
                        ┌───────────────────▼────────────────────┐
                        │         MySQL Database                 │
                        │    ┌────────────────────────────┐     │
                        │    │  Tables (normalized)       │     │
                        │    │  - users, rabbits, etc     │     │
                        │    └────────────────────────────┘     │
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
├── features/                       # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/             # JSON models
│   │   │   ├── repositories/       # Repository implementations
│   │   │   └── datasources/        # Remote/Local data sources
│   │   ├── domain/
│   │   │   ├── entities/           # Business entities
│   │   │   ├── repositories/       # Repository interfaces
│   │   │   └── usecases/           # Business logic
│   │   └── presentation/
│   │       ├── providers/          # Riverpod providers
│   │       ├── screens/            # Screen widgets
│   │       └── widgets/            # Feature widgets
│   │
│   ├── rabbits/                    # Same structure as auth
│   ├── breeding/
│   ├── health/
│   ├── feeding/
│   ├── finance/
│   ├── farm/
│   ├── tasks/
│   └── reports/
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
│   ├── models/
│   │   ├── index.js                # Sequelize init & associations
│   │   ├── User.js
│   │   ├── Rabbit.js
│   │   ├── Breed.js
│   │   ├── Cage.js
│   │   ├── Breeding.js
│   │   ├── Birth.js
│   │   ├── Vaccination.js
│   │   ├── MedicalRecord.js
│   │   ├── Feed.js
│   │   ├── FeedingRecord.js
│   │   ├── Transaction.js
│   │   ├── Task.js
│   │   ├── Note.js
│   │   └── Photo.js
│   │
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── rabbitController.js
│   │   ├── breedingController.js
│   │   ├── healthController.js
│   │   ├── feedingController.js
│   │   ├── financeController.js
│   │   ├── farmController.js
│   │   ├── taskController.js
│   │   └── reportController.js
│   │
│   ├── services/
│   │   ├── authService.js          # Business logic
│   │   ├── rabbitService.js
│   │   ├── breedingService.js
│   │   ├── pedigreeService.js      # Pedigree calculations
│   │   ├── notificationService.js  # Notifications logic
│   │   └── reportService.js        # Report generation
│   │
│   ├── routes/
│   │   ├── index.js                # Main router
│   │   ├── auth.routes.js
│   │   ├── rabbit.routes.js
│   │   ├── breeding.routes.js
│   │   ├── health.routes.js
│   │   ├── feeding.routes.js
│   │   ├── finance.routes.js
│   │   ├── farm.routes.js
│   │   ├── task.routes.js
│   │   └── report.routes.js
│   │
│   ├── validators/
│   │   ├── authValidator.js
│   │   ├── rabbitValidator.js
│   │   └── ...
│   │
│   └── utils/
│       ├── jwt.js                  # JWT helpers
│       ├── password.js             # Password hashing
│       ├── dateUtils.js
│       ├── fileUtils.js
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
├── docker-compose.yml
├── Dockerfile
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
CREATE INDEX idx_tasks_user_date ON tasks(user_id, due_date);
CREATE INDEX idx_transactions_type_date ON transactions(type, transaction_date);

-- Full-text search
CREATE FULLTEXT INDEX idx_rabbits_search ON rabbits(name, tag_id);
```

### Data Integrity
- Foreign key constraints with CASCADE/RESTRICT
- NOT NULL for required fields
- CHECK constraints for valid values
- UNIQUE constraints where needed

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

## 🐳 Docker Setup

### docker-compose.yml
```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped

  backend:
    build: .
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      DB_HOST: mysql
      DB_PORT: 3306
      DB_NAME: ${DB_NAME}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - mysql
    restart: unless-stopped
    volumes:
      - ./uploads:/app/uploads

volumes:
  mysql_data:
```

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

**Architecture Version**: 1.0
**Last Updated**: 2025-10-15
