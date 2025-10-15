# 🚀 RabbitFarm - Quick Start Guide

## Current Status

✅ **Backend Structure**: 100% Complete
✅ **Database Schema**: Ready
⏳ **API Endpoints**: In Progress
⏳ **Mobile App**: Not Started

**Total Files Created**: 42 files (5 docs + 37 backend)

---

## 📦 What's Ready

### Documentation
- ✅ Complete project roadmap
- ✅ System architecture
- ✅ Database schema (16 tables)
- ✅ Setup instructions

### Backend
- ✅ Express.js server setup
- ✅ 16 Sequelize models with associations
- ✅ Complete database migration
- ✅ Authentication middleware (JWT)
- ✅ Error handling & validation
- ✅ File upload support
- ✅ Rate limiting
- ✅ Logger (Winston)
- ✅ Docker setup

---

## 🏃 Quick Start (3 Steps)

### Option 1: Docker (Easiest)

```bash
# 1. Navigate to backend
cd backend

# 2. Create environment file
cp .env.example .env
# Edit .env and set your passwords

# 3. Start everything
docker-compose up -d

# 4. Run migrations
docker-compose exec backend npm run migrate

# 5. Access API
# http://localhost:3000/health
```

### Option 2: Manual Setup

```bash
# 1. Install dependencies
cd backend
npm install

# 2. Setup MySQL
mysql -u root -p
CREATE DATABASE rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'rabbitfarm_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON rabbitfarm.* TO 'rabbitfarm_user'@'localhost';
EXIT;

# 3. Configure environment
cp .env.example .env
# Edit .env with your database credentials

# 4. Run migrations
npm run migrate

# 5. Start server
npm run dev

# 6. Access API
# http://localhost:3000/health
```

---

## 📋 Next Steps (For Development Continuation)

### 1. Create Seed Data
Create file: `backend/seeders/20251015000001-initial-data.js`
- Add default breeds (Калифорнийская, Новозеландская, etc.)
- Add test user (admin@example.com)
- Add sample cages

### 2. Implement Authentication
Create files:
- `backend/src/validators/authValidator.js` - Validation schemas
- `backend/src/services/authService.js` - Auth business logic
- `backend/src/controllers/authController.js` - Auth endpoints
- `backend/src/routes/auth.routes.js` - Auth routes

Endpoints to implement:
- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`

### 3. Implement Rabbits CRUD
Create files:
- `backend/src/validators/rabbitValidator.js`
- `backend/src/services/rabbitService.js`
- `backend/src/controllers/rabbitController.js`
- `backend/src/routes/rabbit.routes.js`

Endpoints to implement:
- `GET /api/v1/rabbits` - List with filters
- `GET /api/v1/rabbits/:id` - Get by ID
- `POST /api/v1/rabbits` - Create
- `PUT /api/v1/rabbits/:id` - Update
- `DELETE /api/v1/rabbits/:id` - Delete
- `POST /api/v1/rabbits/:id/photo` - Upload photo

### 4. Test Backend
- Test database connection
- Test authentication flow
- Test CRUD operations
- Verify error handling

### 5. Initialize Flutter App
```bash
flutter create mobile
cd mobile
# Add dependencies to pubspec.yaml
# Setup folder structure (Clean Architecture)
```

---

## 🔍 Verify Installation

### Health Check
```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2025-10-15T...",
  "uptime": 123.45,
  "environment": "development"
}
```

### API Info
```bash
curl http://localhost:3000/api/v1
```

Expected response:
```json
{
  "message": "RabbitFarm API",
  "version": "v1",
  "endpoints": {
    "auth": "/auth",
    "rabbits": "/rabbits",
    ...
  }
}
```

---

## 📁 Project Structure

```
RabbitFarm/
├── backend/              ← 37 files created
│   ├── src/
│   │   ├── config/      ← 3 config files
│   │   ├── utils/       ← 4 utility classes
│   │   ├── middleware/  ← 4 middleware
│   │   ├── models/      ← 17 models (16 + index)
│   │   ├── routes/      ← 1 route (more to add)
│   │   ├── controllers/ ← Empty (to be created)
│   │   ├── services/    ← Empty (to be created)
│   │   └── validators/  ← Empty (to be created)
│   ├── migrations/      ← 1 migration (complete schema)
│   ├── seeders/         ← Empty (to be created)
│   └── package.json
│
├── mobile/              ← Not created yet
│
├── docs/                ← 5 documentation files
│   ├── ROADMAP.md
│   ├── PROGRESS.md
│   ├── ARCHITECTURE.md
│   ├── DATABASE_SCHEMA.md
│   └── QUICKSTART.md (this file)
│
└── README.md
```

---

## 🗄️ Database Schema

**16 Tables Ready:**
1. users (with roles)
2. refresh_tokens
3. breeds
4. cages
5. rabbits (with pedigree)
6. rabbit_weights
7. breedings
8. births
9. vaccinations
10. medical_records
11. feeds
12. feeding_records
13. transactions
14. tasks
15. photos
16. notes

---

## 🛠️ Available Scripts

```bash
# Development
npm run dev          # Start with hot reload

# Production
npm start            # Start production server

# Database
npm run migrate      # Run migrations
npm run migrate:undo # Rollback migration
npm run seed         # Seed database
npm run seed:undo    # Undo seeds

# Testing
npm test             # Run tests
npm run test:watch   # Watch mode

# Code Quality
npm run lint         # Lint code
npm run lint:fix     # Fix linting issues
```

---

## 🐳 Docker Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f backend

# Restart backend
docker-compose restart backend

# Rebuild
docker-compose up -d --build

# Execute commands in backend
docker-compose exec backend npm run migrate
docker-compose exec backend npm run seed

# Access MySQL
docker-compose exec mysql mysql -u root -p
```

---

## 🔧 Environment Variables

Key variables in `.env`:

```env
# Server
NODE_ENV=development
PORT=3000

# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=rabbitfarm
DB_USER=rabbitfarm_user
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your_secret_key
JWT_EXPIRE=15m
JWT_REFRESH_SECRET=your_refresh_secret
JWT_REFRESH_EXPIRE=7d

# Upload
MAX_FILE_SIZE=5242880
ALLOWED_FILE_TYPES=image/jpeg,image/png
```

---

## 📊 Progress Overview

**Phase 1: Foundation** - 40% Complete

✅ Completed:
- Project planning & documentation
- Backend structure
- Database design
- Models & migrations
- Middleware & utilities
- Docker setup

⏳ In Progress:
- Seed data

🔜 Next:
- Authentication endpoints
- Rabbits CRUD
- Testing
- Flutter app

---

## 🆘 Troubleshooting

### Database connection failed
```bash
# Check MySQL is running
docker-compose ps

# Check credentials in .env
cat .env | grep DB_

# Restart MySQL
docker-compose restart mysql
```

### Port 3000 already in use
```bash
# Change PORT in .env
# Or kill process on port 3000
# Windows: netstat -ano | findstr :3000
# Linux/Mac: lsof -i :3000
```

### Migration error
```bash
# Check database exists
mysql -u root -p -e "SHOW DATABASES;"

# Rollback and retry
npm run migrate:undo
npm run migrate
```

---

## 📞 Need Help?

1. Check [README.md](README.md) for detailed setup
2. Check [PROGRESS.md](PROGRESS.md) for current status
3. Check [ARCHITECTURE.md](ARCHITECTURE.md) for system design
4. Check [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) for DB structure

---

## 🎯 Development Roadmap

**Week 1**: Foundation ← YOU ARE HERE
**Week 2**: Core Features (Auth + Rabbits CRUD)
**Week 3**: Breeding Module
**Week 4**: Health & Tasks
**Week 5**: Feeding & Finance
**Week 6-7**: Reports & Analytics
**Week 8-9**: Offline Mode
**Week 10**: Testing & Deploy

---

**Last Updated**: 2025-10-15
**Progress**: 40% (Backend structure complete)
**Next Goal**: Implement authentication & rabbits CRUD
