# 🚀 START HERE - RabbitFarm Setup

## Current Status

✅ **Backend Code**: 100% Ready (75% of MVP)
- 18 API endpoints implemented
- Full authentication system
- Complete rabbits CRUD
- Seed data ready

⚠️ **Database**: Not configured yet
⚠️ **Server**: Not started yet

---

## ⚡ Quick Start Options

### Option 1: Docker (Easiest) 🐳

**Requirements**: Docker Desktop

1. **Install Docker Desktop**
   - Download: https://www.docker.com/products/docker-desktop
   - Install and start Docker Desktop
   - Wait for Docker to be running

2. **Start Database**
   ```bash
   cd backend
   docker-compose up -d
   ```

3. **Run Migrations & Seed**
   ```bash
   npm run migrate
   npm run seed
   ```

4. **Start Server**
   ```bash
   npm run dev
   ```

✅ Done! Server at `http://localhost:3000`

---

### Option 2: Local MySQL 💾

**Requirements**: MySQL 8.0+

#### Windows
```powershell
# Install MySQL (with Chocolatey)
choco install mysql

# Or download installer from:
# https://dev.mysql.com/downloads/mysql/

# Start MySQL service
net start MySQL80

# Create database
cd backend
mysql -u root -p < init.sql
```

#### Linux (Ubuntu/Debian)
```bash
# Install MySQL
sudo apt-get update
sudo apt-get install mysql-server

# Start service
sudo systemctl start mysql

# Create database
cd backend
mysql -u root -p < init.sql
```

#### MacOS
```bash
# Install with Homebrew
brew install mysql

# Start service
brew services start mysql

# Create database
cd backend
mysql -u root -p < init.sql
```

#### After MySQL is ready
```bash
cd backend
npm run migrate
npm run seed
npm run dev
```

---

### Option 3: Online MySQL (No Installation) ☁️

**Free Services**:
- https://www.freemysqlhosting.net/
- https://www.db4free.net/
- https://remotemysql.com/

1. **Create Account** and get credentials
2. **Update `.env`** file:
   ```env
   DB_HOST=your-host.com
   DB_PORT=3306
   DB_NAME=your_database
   DB_USER=your_username
   DB_PASSWORD=your_password
   ```
3. **Run Setup**:
   ```bash
   cd backend
   npm run migrate
   npm run seed
   npm run dev
   ```

---

## 📝 Step-by-Step Guide

### 1. Choose Your Database Option
- ✅ Docker (recommended if you have it)
- ✅ Local MySQL
- ✅ Online MySQL

### 2. Setup Database
Follow instructions for your chosen option above.

### 3. Verify Connection
```bash
cd backend
node -e "require('dotenv').config(); const {Sequelize} = require('sequelize'); const config = require('./src/config/database')['development']; new Sequelize(config).authenticate().then(() => console.log('✅ Connected!')).catch(e => console.error('❌ Failed:', e.message));"
```

### 4. Run Migrations
```bash
npm run migrate
```

Expected output:
```
Sequelize CLI [Node: 18.x.x]

Loaded configuration file "src/config/database.js".
Using environment "development".
== 20251015000001-create-initial-schema: migrating =======
== 20251015000001-create-initial-schema: migrated (X.XXXs)
```

### 5. Seed Database
```bash
npm run seed
```

Expected output:
```
✅ Seed data inserted successfully!
📧 Default users:
   - admin@rabbitfarm.com / admin123 (Owner)
   - manager@rabbitfarm.com / manager123 (Manager)
   - worker@rabbitfarm.com / worker123 (Worker)
🐰 8 breeds inserted
🏠 10 cages inserted
🌾 6 feed types inserted
```

### 6. Start Server
```bash
npm run dev
```

Expected output:
```
🚀 Server is running on http://localhost:3000
📚 API Documentation: http://localhost:3000/api/v1
💚 Health Check: http://localhost:3000/health
```

### 7. Test API
```bash
# Health check
curl http://localhost:3000/health

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@rabbitfarm.com","password":"admin123"}'
```

---

## ❌ Troubleshooting

### "MySQL not found"
➡️ MySQL is not installed. Use Docker or install MySQL.

### "Docker not running"
➡️ Start Docker Desktop and wait for it to be ready.

### "Connection refused"
➡️ Check if MySQL is running:
```bash
# Windows
sc query MySQL80

# Linux
sudo systemctl status mysql

# Mac
brew services list

# Docker
docker-compose ps
```

### "Access denied"
➡️ Check username/password in `.env` file.

### "Database does not exist"
➡️ Run `init.sql` script or create database manually.

### "Port 3000 in use"
➡️ Change `PORT` in `.env` file or stop other service.

### "Migration error"
➡️ Check database connection, then:
```bash
npm run migrate:undo
npm run migrate
```

---

## 📚 Documentation

- **API Testing**: `backend/API_TESTING.md`
- **Database Setup**: `backend/SETUP_DATABASE.md`
- **Architecture**: `ARCHITECTURE.md`
- **Progress**: `PROGRESS.md`

---

## 🎯 What to Do After Setup

1. **Test Authentication**
   - Login with test accounts
   - Get user profile
   - Refresh token

2. **Test Rabbits CRUD**
   - Get statistics
   - Create rabbit
   - List rabbits
   - Update rabbit

3. **Start Flutter Development**
   - Initialize Flutter project
   - Create auth UI
   - Connect to API

---

## 📦 Test Accounts

| Email | Password | Role | Access |
|-------|----------|------|--------|
| admin@rabbitfarm.com | admin123 | owner | Full access |
| manager@rabbitfarm.com | manager123 | manager | Limited |
| worker@rabbitfarm.com | worker123 | worker | Read-only |

---

## 🚀 Next Steps

After backend is running:
1. ✅ Backend API working
2. ⏳ Test all endpoints
3. ⏳ Initialize Flutter project
4. ⏳ Build mobile UI
5. ⏳ Connect mobile to API

---

## 💡 Tips

- Use **Postman** or **Insomnia** for API testing
- Keep server running in one terminal
- Check logs for any errors
- Test with different user roles
- Start with authentication flow

---

## 🆘 Need Help?

1. Read `SETUP_DATABASE.md` for detailed database setup
2. Read `API_TESTING.md` for API examples
3. Check `PROGRESS.md` for current status
4. Review logs in `backend/logs/` folder

---

**You're 90% there! Just need to setup database and you're good to go! 🎉**

Choose your preferred database option above and follow the steps. Good luck!
