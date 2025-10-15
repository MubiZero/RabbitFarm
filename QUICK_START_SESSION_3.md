# 🚀 Quick Start - Session 3

## What We Have Now

✅ **Backend API** - 75% Complete
- 18 API endpoints (7 auth + 11 rabbits)
- Full authentication system
- Complete rabbits CRUD
- Seed data ready
- All documented

✅ **Files Created**: 60 files (~6,500 lines of code)

---

## Quick Test Before Continuing

### 1. Start Backend

```bash
cd backend

# Create .env if not exists
cp .env.example .env
# Edit .env: set DB_PASSWORD, JWT_SECRET, etc.

# Install dependencies (if not done)
npm install

# Start MySQL (Docker)
docker-compose up -d mysql

# Run migrations
npm run migrate

# Seed database
npm run seed

# Start server
npm run dev
```

Server should start at `http://localhost:3000`

### 2. Quick Test

```bash
# Health check
curl http://localhost:3000/health

# Login (get token)
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@rabbitfarm.com","password":"admin123"}'

# Save token and test rabbits endpoint
export TOKEN="your_token_here"
curl http://localhost:3000/api/v1/rabbits/statistics \
  -H "Authorization: Bearer $TOKEN"
```

---

## Session 3 Goals

### Priority 1: Complete Testing (30 min)
1. Test all auth endpoints
2. Test all rabbit endpoints
3. Test file upload
4. Test role-based access
5. Document any bugs

### Priority 2: Initialize Flutter (60 min)
1. Create Flutter project
2. Setup folder structure (Clean Architecture)
3. Add dependencies (riverpod, dio, etc.)
4. Create API client
5. Setup routing (go_router)

### Priority 3: Flutter Auth UI (60 min)
1. Create auth provider (Riverpod)
2. Create login screen
3. Create register screen
4. Implement auth flow
5. Test authentication

---

## Test Accounts

| Email | Password | Role |
|-------|----------|------|
| admin@rabbitfarm.com | admin123 | owner |
| manager@rabbitfarm.com | manager123 | manager |
| worker@rabbitfarm.com | worker123 | worker |

---

## API Endpoints Ready

### Auth
- POST /api/v1/auth/register
- POST /api/v1/auth/login
- POST /api/v1/auth/refresh
- POST /api/v1/auth/logout
- GET /api/v1/auth/me
- PUT /api/v1/auth/profile
- POST /api/v1/auth/change-password

### Rabbits
- GET /api/v1/rabbits/statistics
- GET /api/v1/rabbits (with filters)
- POST /api/v1/rabbits
- GET /api/v1/rabbits/:id
- PUT /api/v1/rabbits/:id
- DELETE /api/v1/rabbits/:id
- GET /api/v1/rabbits/:id/weights
- POST /api/v1/rabbits/:id/weights
- GET /api/v1/rabbits/:id/pedigree
- POST /api/v1/rabbits/:id/photo

---

## Flutter Project Structure (To Create)

```
mobile/
├── lib/
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart
│   │   │   └── endpoints.dart
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       └── constants.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   └── register_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   └── rabbits/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │
│   ├── shared/
│   │   └── widgets/
│   │
│   └── main.dart
│
└── pubspec.yaml
```

---

## Dependencies to Add (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Networking
  dio: ^5.4.0
  retrofit: ^4.0.3
  json_annotation: ^4.8.1

  # Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0

  # Routing
  go_router: ^12.1.3

  # UI
  flutter_hooks: ^0.20.3
  cached_network_image: ^3.3.0

  # Utils
  freezed_annotation: ^2.4.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  retrofit_generator: ^8.0.6
```

---

## Next Actions Checklist

### Before Starting Flutter
- [ ] Backend running successfully
- [ ] Database seeded
- [ ] All endpoints tested
- [ ] Token authentication working
- [ ] File upload working

### Flutter Setup
- [ ] Flutter SDK installed
- [ ] Android emulator ready (or physical device)
- [ ] Create new Flutter project
- [ ] Add dependencies
- [ ] Setup folder structure
- [ ] Create API client
- [ ] Create auth provider

### First Flutter Features
- [ ] Login screen
- [ ] Register screen
- [ ] Auth flow
- [ ] Token storage
- [ ] Rabbits list screen

---

## Useful Commands

### Backend
```bash
# Start dev server
npm run dev

# Run migrations
npm run migrate

# Seed data
npm run seed

# View logs
docker-compose logs -f
```

### Flutter (when ready)
```bash
# Create project
flutter create mobile

# Get dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Hot reload: press 'r'
# Hot restart: press 'R'
```

---

## Resources

- **API Testing**: See `backend/API_TESTING.md`
- **Progress**: See `PROGRESS.md`
- **Architecture**: See `ARCHITECTURE.md`
- **Session 2 Summary**: See `SESSION_2_SUMMARY.md`

---

## Expected Session 3 Outcome

By end of session:
- ✅ Backend fully tested
- ✅ Flutter project created
- ✅ Auth screens working
- ✅ User can login from mobile
- ✅ Token stored securely
- ✅ Ready to build rabbits UI

---

**Good luck! 🚀**
