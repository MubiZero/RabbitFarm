# 🐰 RabbitFarm - Rabbit Farm Management System

Complete farm management solution: a Flutter app (Android, iOS and web) and a REST API backend.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Development](#development)
- [API Documentation](#api-documentation)
- [License](#license)

## ✨ Features

### Core Features (MVP)
- ✅ User authentication (JWT)
- ✅ Rabbit management (CRUD with photos)
- ✅ Breed management
- ✅ Cage/housing management
- ✅ Breeding tracking (matings, pregnancies, births)
- ✅ Pedigree tracking
- ✅ Weight tracking with history
- ✅ Health management (vaccinations, treatments)
- ✅ Task management with reminders
- ✅ Feeding schedule and inventory
- ✅ Financial tracking (income/expenses)
- ✅ Reports and analytics

### Advanced Features
- 📱 Offline mode with sync
- 📊 Advanced analytics and charts
- 📄 PDF/Excel export
- 🔔 Push notifications
- 👥 Multi-user support with roles
- 📸 Photo gallery
- 🔍 Advanced search and filters

## 🛠️ Tech Stack

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: MySQL 8.0
- **ORM**: Sequelize
- **Authentication**: JWT

### Frontend (Mobile)
- **Framework**: Flutter 3.16+
- **Target**: Android (min SDK 21)
- **State Management**: Riverpod
- **Local DB**: SQLite + Hive
- **Architecture**: Clean Architecture

## 📁 Project Structure

```
RabbitFarm/
├── backend/              # Backend API (Node.js/Express)
├── mobile/               # Flutter mobile app
├── docs/                 # Documentation (Architecture, API, etc.)
├── docker-compose.yml    # Docker orchestration
└── README.md             # This file
```

## 🚀 Getting Started

### Prerequisites

- **Docker** and **Docker Compose**
- **Flutter** (for mobile app development)

### Quick Start (Docker)

The easiest way to run the entire backend system (API + Database) is using Docker:

```bash
cp backend/.env.example .env   # секретов в репозитории нет — заполните их
docker-compose up -d
```

Заполните в `.env` как минимум `DB_PASSWORD`, `DB_ROOT_PASSWORD`, `JWT_SECRET`
и `JWT_REFRESH_SECRET` — например, `openssl rand -base64 32` на каждое.
Без них compose не запустится: это защита от развёртывания со значениями
по умолчанию.

#### 🛡️ Port Configuration
- **Backend API**: `http://localhost:4567` (External access)
- **MySQL Database**: `localhost:3307` (Mapped to 3306 internally to avoid conflicts with local MySQL)
- **Adminer (DB Web UI)**: `http://localhost:8080`

**Note:** If you get an error that a port is already in use, you can change the host port in `docker-compose.yml`.

### 📱 Connecting the Mobile App

To connect the Flutter app to your local Docker backend:

1. **Android Emulator**: Use `http://10.0.2.2:4567/api/v1`
2. **iOS Simulator**: Use `http://localhost:4567/api/v1`
3. **Real Device**: Use your computer's local IP (e.g., `http://192.168.1.50:4567/api/v1`)

You can run the app with the specific API URL using:
```bash
flutter run --dart-define=API_URL=http://YOUR_IP:4567/api/v1
```

### 🛠️ Troubleshooting

- **DB Connection Issues**: If the API fails to connect to the DB, check `docker logs rabbitfarm-api`. The API automatically waits for the DB to be ready.
- **Data Persistence**: Database data is stored in a Docker volume `rabbitfarm_mysql_data`.
- **CORS Issues**: The backend is configured to accept all origins in development mode for easier mobile testing.

## 🚀 Развёртывание

Как поднять всё это на своём сервере (Coolify, отдельная база, домены,
сертификаты, бэкапы) — в [docs/DEPLOY.md](docs/DEPLOY.md).

## 📚 Documentation

Detailed documentation available in the `docs` folder:

- **[ROADMAP.md](ROADMAP.md)** - Complete development roadmap and features
- **[PROGRESS.md](PROGRESS.md)** - Current development progress
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture and design
- **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Complete database schema

## 💻 Development

### Backend Commands

```bash
# Development server with hot reload
npm run dev

# Production server
npm start

# Run database migrations
npm run migrate

# Rollback last migration
npm run migrate:undo

# Seed database
npm run seed

# Run tests
npm test

# Run tests with coverage
npm run test:coverage

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix
```

### Database Migrations

Create a new migration:
```bash
npx sequelize-cli migration:generate --name migration-name
```

### Project Status

**Current Phase**: Phase 1 - Foundation ✅
**Progress**: ~30% (Backend structure complete, models done)

**Next Steps**:
1. Create database migrations
2. Implement authentication endpoints
3. Create rabbits CRUD API
4. Initialize Flutter project
5. Build authentication UI

## 📡 API Documentation

### Base URL
```
http://localhost:4567/api/v1
```

### Endpoints (Planned)

#### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login
- `POST /auth/refresh` - Refresh access token
- `POST /auth/logout` - Logout

#### Rabbits
- `GET /rabbits` - Get all rabbits (with filters)
- `GET /rabbits/:id` - Get rabbit by ID
- `POST /rabbits` - Create new rabbit
- `PUT /rabbits/:id` - Update rabbit
- `DELETE /rabbits/:id` - Delete rabbit
- `POST /rabbits/:id/photo` - Upload rabbit photo

#### Breeding
- `GET /breeding` - Get all breedings
- `POST /breeding` - Create mating record
- `GET /breeding/:id` - Get breeding details
- `POST /breeding/:id/birth` - Register birth

#### Health
- `GET /rabbits/:id/vaccinations` - Get vaccinations
- `POST /rabbits/:id/vaccinations` - Add vaccination
- `GET /rabbits/:id/medical-records` - Get medical records
- `POST /rabbits/:id/medical-records` - Add medical record

...and many more!

Full API documentation will be available at `/api-docs` (Swagger).

## 🔧 Configuration

### Environment Variables

See `.env.example` for all available configuration options.

Key variables:
- `NODE_ENV` - Environment (development/production)
- `PORT` - Server port (default: 3000)
- `DB_*` - Database configuration
- `JWT_SECRET` - JWT signing secret
- `CORS_ORIGIN` - Allowed CORS origins

## 🧪 Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm run test:coverage
```

## 📊 Database

### Backup
```bash
# Manual backup
mysqldump -u root -p rabbitfarm > backup.sql

# Restore
mysql -u root -p rabbitfarm < backup.sql
```

### Access MySQL
```bash
mysql -u root -p
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT — see [LICENSE](LICENSE).

## 👥 Team

- **Developer**: Claude AI Assistant
- **Product Owner**: You

## 📞 Support

For issues and questions:
- Create an issue in the repository
- Check the [documentation](./docs/)

## 🗺️ Roadmap

See [ROADMAP.md](ROADMAP.md) for detailed development plans.

**Current Sprint**: Foundation Setup
**Next Sprint**: Authentication & Core Features

---

**Built with ❤️ for rabbit farmers**
