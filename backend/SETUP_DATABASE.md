# Database Setup Guide

## Option 1: Using Docker (Recommended)

### Prerequisites
- Docker Desktop installed and running

### Steps
```bash
cd backend

# Start MySQL container
docker-compose up -d

# Check if running
docker-compose ps

# View logs
docker-compose logs mysql
```

---

## Option 2: Manual MySQL Installation

### Prerequisites
- MySQL 8.0+ installed on your system

### Steps

#### Windows

1. **Install MySQL**
   - Download from: https://dev.mysql.com/downloads/mysql/
   - Or use Chocolatey: `choco install mysql`

2. **Start MySQL Service**
   ```cmd
   net start MySQL80
   ```

3. **Create Database**
   ```cmd
   mysql -u root -p < init.sql
   ```
   Enter your MySQL root password when prompted.

#### Linux/Mac

1. **Install MySQL**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install mysql-server

   # MacOS (Homebrew)
   brew install mysql
   ```

2. **Start MySQL**
   ```bash
   # Ubuntu/Debian
   sudo systemctl start mysql

   # MacOS
   brew services start mysql
   ```

3. **Create Database**
   ```bash
   mysql -u root -p < init.sql
   ```

### Manual Setup (Alternative)

If the script doesn't work, run these commands manually:

```sql
-- Connect to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'rabbitfarm_user'@'localhost' IDENTIFIED BY 'RabbitFarm2024!';

-- Grant privileges
GRANT ALL PRIVILEGES ON rabbitfarm.* TO 'rabbitfarm_user'@'localhost';
FLUSH PRIVILEGES;

-- Exit
EXIT;
```

---

## Verify Database Connection

### Test Connection
```bash
# From backend directory
cd backend

# Test with Node.js
node -e "const { Sequelize } = require('sequelize'); const config = require('./src/config/database')['development']; const seq = new Sequelize(config); seq.authenticate().then(() => console.log('✅ Connection successful!')).catch(err => console.error('❌ Connection failed:', err.message));"
```

### Or test directly with MySQL
```bash
mysql -u rabbitfarm_user -p rabbitfarm
# Enter password: RabbitFarm2024!
```

If connected successfully, you should see:
```
mysql>
```

---

## Run Migrations

Once database is ready:

```bash
cd backend

# Run migrations (create tables)
npm run migrate

# Seed database (add test data)
npm run seed
```

---

## Troubleshooting

### "Access denied for user"
- Check username/password in `.env` file
- Verify user was created: `SELECT user FROM mysql.user WHERE user='rabbitfarm_user';`
- Recreate user with correct password

### "Database does not exist"
```bash
mysql -u root -p -e "CREATE DATABASE rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### "Can't connect to MySQL server"
- Check if MySQL is running
  - Windows: `sc query MySQL80`
  - Linux: `sudo systemctl status mysql`
  - Mac: `brew services list`
- Check port 3306 is not in use
- Check firewall settings

### Docker issues
- Ensure Docker Desktop is running
- Check Docker status: `docker ps`
- Restart Docker Desktop
- Remove old containers: `docker-compose down -v`
- Start fresh: `docker-compose up -d --force-recreate`

---

## Alternative: Using Online MySQL

If you can't install MySQL locally, you can use a free online MySQL service:

1. **FreeMySQLHosting.net**
2. **db4free.net**
3. **RemoteMySQL.com**

Update your `.env` file with the provided credentials:
```env
DB_HOST=your-remote-host.com
DB_PORT=3306
DB_NAME=your_database
DB_USER=your_username
DB_PASSWORD=your_password
```

---

## Next Steps

After database is ready:
1. ✅ Database created
2. ✅ User created with permissions
3. ⏳ Run migrations: `npm run migrate`
4. ⏳ Seed data: `npm run seed`
5. ⏳ Start server: `npm run dev`
