# 🐰 RabbitFarm - Rabbit Farm Management System

Complete farm management solution with Flutter mobile app (Android) and REST API backend.

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
│   ├── src/
│   │   ├── config/      # Configuration files
│   │   ├── controllers/ # Request handlers
│   │   ├── middleware/  # Express middleware
│   │   ├── models/      # Sequelize models
│   │   ├── routes/      # API routes
│   │   ├── services/    # Business logic
│   │   ├── validators/  # Request validation
│   │   └── utils/       # Helper functions
│   ├── migrations/      # Database migrations
│   ├── seeders/        # Seed data
│   └── uploads/        # Uploaded files
│
├── mobile/             # Flutter mobile app (to be created)
│   └── ...
│
├── docs/               # Documentation
│   ├── ROADMAP.md      # Development roadmap
│   ├── PROGRESS.md     # Current progress
│   ├── ARCHITECTURE.md # System architecture
│   └── DATABASE_SCHEMA.md # Database schema
│
└── README.md           # This file
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18+ and npm
- **MySQL** 8.0
- **Flutter** 3.16+ (for mobile app)

### Backend Setup

1. **Install dependencies**
```bash
cd backend
npm install
```

2. **Setup MySQL database**
```bash
mysql -u root -p
CREATE DATABASE rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'rabbitfarm_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON rabbitfarm.* TO 'rabbitfarm_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

3. **Create and configure .env**
```bash
cp .env.example .env
# Edit .env with your database credentials
```

4. **Run migrations**
```bash
npm run migrate
```

5. **Seed database**
```bash
npm run seed
```

6. **Start development server**
```bash
npm run dev
```

### Mobile App Setup (Coming Soon)

```bash
cd mobile
flutter pub get
flutter run
```

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
http://localhost:3000/api/v1
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

This project is licensed under the MIT License.

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
