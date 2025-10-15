# RabbitFarm - Roadmap

## 🎯 Цель проекта
Система учёта кроликов для фермы с Flutter-приложением (Android) и Backend API на Ubuntu VPS + MySQL.

## 🏗️ Технологический стек

### Backend
- **Platform**: Ubuntu VPS
- **Runtime**: Node.js 18+ LTS
- **Framework**: Express.js
- **Database**: MySQL 8.0
- **ORM**: Sequelize
- **Authentication**: JWT (jsonwebtoken)
- **File Upload**: Multer
- **Validation**: Joi
- **Deployment**: Docker + Docker Compose
- **API Documentation**: Swagger/OpenAPI

### Frontend (Flutter)
- **Framework**: Flutter 3.16+
- **Target**: Android (min SDK 21)
- **State Management**: Riverpod 2.x
- **Navigation**: go_router
- **HTTP Client**: dio
- **Local DB**: sqflite + hive
- **Models**: freezed + json_serializable
- **Charts**: fl_chart
- **Images**: image_picker, cached_network_image
- **Notifications**: flutter_local_notifications
- **PDF**: pdf, printing
- **Architecture**: Clean Architecture

## 📦 Структура проекта

```
RabbitFarm/
├── backend/                    # Backend API
│   ├── src/
│   │   ├── controllers/       # Route controllers
│   │   ├── models/            # Sequelize models
│   │   ├── services/          # Business logic
│   │   ├── middleware/        # Auth, validation, error handling
│   │   ├── routes/            # API routes
│   │   ├── config/            # Configuration
│   │   └── utils/             # Helpers
│   ├── migrations/            # DB migrations
│   ├── seeders/              # Seed data
│   ├── uploads/              # Uploaded files
│   ├── tests/                # Backend tests
│   ├── .env.example
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── package.json
│
├── mobile/                    # Flutter app
│   ├── lib/
│   │   ├── core/
│   │   │   ├── api/          # API client
│   │   │   ├── database/     # Local database
│   │   │   ├── theme/        # App theme
│   │   │   ├── router/       # Navigation
│   │   │   └── utils/        # Helpers
│   │   ├── features/
│   │   │   ├── auth/         # Authentication
│   │   │   ├── rabbits/      # Rabbit management
│   │   │   ├── breeding/     # Breeding management
│   │   │   ├── health/       # Health & veterinary
│   │   │   ├── feeding/      # Feeding management
│   │   │   ├── finance/      # Finance tracking
│   │   │   ├── farm/         # Farm infrastructure
│   │   │   ├── tasks/        # Tasks & calendar
│   │   │   └── reports/      # Reports & analytics
│   │   ├── shared/
│   │   │   ├── widgets/      # Reusable widgets
│   │   │   ├── models/       # Shared models
│   │   │   └── providers/    # Global providers
│   │   └── main.dart
│   ├── assets/
│   ├── test/
│   └── pubspec.yaml
│
├── docs/                      # Documentation
│   ├── api/                  # API documentation
│   └── setup/                # Setup guides
│
├── ROADMAP.md                # This file
├── PROGRESS.md               # Current progress tracker
├── ARCHITECTURE.md           # System architecture
└── DATABASE_SCHEMA.md        # Database schema
```

## 🚀 План разработки

### Phase 1: MVP (Weeks 1-3)
**Цель**: Базовый функционал для учёта поголовья и разведения

#### Week 1: Foundation
- [ ] Project initialization
  - [ ] Create backend structure
  - [ ] Create Flutter project
  - [ ] Setup Docker environment
  - [ ] Configure MySQL database
- [ ] Database schema design
  - [ ] Core tables (users, rabbits, breeds, cages)
  - [ ] Breeding tables (breedings, births)
  - [ ] Create migrations
- [ ] Authentication
  - [ ] JWT auth backend
  - [ ] Login/Register API
  - [ ] Flutter auth screens
  - [ ] Token storage

#### Week 2: Core Features
- [ ] Rabbits Management (Backend)
  - [ ] CRUD API endpoints
  - [ ] Photo upload
  - [ ] Filtering & search
- [ ] Rabbits Management (Frontend)
  - [ ] List view with filters
  - [ ] Rabbit card/detail screen
  - [ ] Add/Edit rabbit form
  - [ ] Photo capture/upload
- [ ] Cages Management
  - [ ] Backend API
  - [ ] Frontend UI
  - [ ] Assign rabbits to cages

#### Week 3: Breeding
- [ ] Breeding Management (Backend)
  - [ ] Matings API
  - [ ] Births/litters API
  - [ ] Pedigree calculation
- [ ] Breeding Management (Frontend)
  - [ ] Plan mating screen
  - [ ] Pregnancy tracking
  - [ ] Register birth
  - [ ] Pedigree viewer

### Phase 2: Health & Tasks (Weeks 4-5)
**Цель**: Ветеринария и задачи

#### Week 4: Health Module
- [ ] Vaccinations
  - [ ] Backend API
  - [ ] Vaccination schedule
  - [ ] Reminders
- [ ] Medical Records
  - [ ] Symptoms & diagnoses
  - [ ] Treatments
  - [ ] Medication tracking

#### Week 5: Tasks & Calendar
- [ ] Task Management
  - [ ] Create/assign tasks
  - [ ] Task templates
  - [ ] Recurring tasks
- [ ] Calendar & Notifications
  - [ ] Event calendar
  - [ ] Push notifications
  - [ ] Reminder system

### Phase 3: Feeding & Finance (Weeks 6-7)
**Цель**: Управление кормлением и финансами

#### Week 6: Feeding
- [ ] Feed Inventory
  - [ ] Feed types
  - [ ] Stock management
  - [ ] Low stock alerts
- [ ] Feeding Schedule
  - [ ] Feeding norms
  - [ ] Feeding records
  - [ ] Consumption tracking

#### Week 7: Finance
- [ ] Income Tracking
  - [ ] Sales records
  - [ ] Income categories
- [ ] Expense Tracking
  - [ ] Expense categories
  - [ ] Receipts/photos
- [ ] Financial Reports
  - [ ] Profit/loss
  - [ ] ROI per rabbit
  - [ ] Charts & graphs

### Phase 4: Analytics & Offline (Weeks 8-9)
**Цель**: Аналитика и оффлайн-режим

#### Week 8: Reports & Analytics
- [ ] Statistics Dashboard
  - [ ] Population stats
  - [ ] Mortality rates
  - [ ] Feed conversion
- [ ] Advanced Reports
  - [ ] Custom date ranges
  - [ ] Export to PDF/Excel
  - [ ] Breeding performance

#### Week 9: Offline Mode
- [ ] Local Database
  - [ ] SQLite schema
  - [ ] Data sync strategy
- [ ] Sync Implementation
  - [ ] Conflict resolution
  - [ ] Background sync
  - [ ] Offline indicators

### Phase 5: Polish & Deploy (Week 10)
**Цель**: Тестирование и деплой

- [ ] Testing
  - [ ] Backend unit tests
  - [ ] Integration tests
  - [ ] Flutter widget tests
- [ ] Performance Optimization
  - [ ] Query optimization
  - [ ] Image compression
  - [ ] Lazy loading
- [ ] Deployment
  - [ ] VPS setup
  - [ ] SSL certificate
  - [ ] CI/CD pipeline
  - [ ] Backup strategy
- [ ] Documentation
  - [ ] API documentation
  - [ ] User manual
  - [ ] Admin guide

## 🎨 UI/UX Features

### Key Screens
1. **Dashboard** - Overview of farm status
2. **Rabbits List** - Filterable list with quick actions
3. **Rabbit Detail** - Full info, photo gallery, history
4. **Add/Edit Rabbit** - Form with validation
5. **Breeding** - Matings, pregnancies, births
6. **Health** - Vaccinations, treatments, medical records
7. **Calendar** - Tasks, events, reminders
8. **Feeding** - Schedule, inventory, records
9. **Finance** - Income, expenses, analytics
10. **Reports** - Statistics, charts, exports

### UX Principles
- **Material Design 3** with dynamic theming
- **Fast Navigation** - Bottom nav + side drawer
- **Quick Actions** - FAB, swipe gestures, long-press
- **Visual Feedback** - Loading states, success/error messages
- **Search & Filter** - Everywhere with saved filters
- **Offline First** - Works without internet
- **Accessibility** - Screen reader support, large text

## 🔐 Security Considerations

- JWT token with refresh mechanism
- Password hashing (bcrypt)
- Input validation (backend + frontend)
- SQL injection prevention (parameterized queries)
- File upload validation
- Rate limiting on API
- HTTPS only in production
- Secure headers (helmet.js)

## 📱 Android Optimizations

- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Proguard/R8 code shrinking
- Image optimization
- APK size optimization
- Battery optimization (background tasks)
- Permissions handling (camera, storage, notifications)

## 🗄️ Database Strategy

### Backup
- Daily automated backups
- 30-day retention
- Export to external storage

### Performance
- Indexes on frequently queried fields
- Pagination for large datasets
- Query optimization
- Connection pooling

## 📊 Success Metrics

### MVP Success Criteria
- [ ] User can register/login
- [ ] User can add/edit/delete rabbits
- [ ] User can manage cages
- [ ] User can record matings and births
- [ ] User can view pedigree
- [ ] App works offline (basic features)

### Full Product Success
- [ ] Multi-user support
- [ ] Complete health tracking
- [ ] Financial analytics
- [ ] Automated reports
- [ ] Performance: <2s page load
- [ ] 99% uptime
- [ ] <50MB APK size

## 🔄 Future Enhancements (Post-MVP)

- iOS app support
- Web dashboard
- Multi-farm management
- QR code/RFID integration
- AI-powered insights (breeding recommendations)
- Weather integration
- Market price tracking
- Supplier/customer management
- Automated feeding systems integration
- Community features (breeding marketplace)

## 📝 Notes

- All dates in ISO 8601 format
- Use UTC timezone on backend
- Support Russian language primarily
- Use metric system (kg, cm)
- Photo max size: 5MB, auto-compress to 1920px
- API versioning: /api/v1/...
