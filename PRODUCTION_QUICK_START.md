# ⚡ БЫСТРЫЙ ЗАПУСК В PRODUCTION

## 🎯 Что нужно сделать:

### 1️⃣ НА PRODUCTION СЕРВЕРЕ (108.181.167.236)

#### A. Установить необходимое ПО (если еще не установлено):
```bash
# Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# PM2
sudo npm install -g pm2

# MySQL (если не установлен)
sudo apt install -y mysql-server
```

#### B. Создать базу данных:
```bash
mysql -u root -p
```
```sql
CREATE DATABASE rabbitfarm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'rabbitfarm_user'@'localhost' IDENTIFIED BY 'СЛОЖНЫЙ_ПАРОЛЬ';
GRANT ALL PRIVILEGES ON rabbitfarm.* TO 'rabbitfarm_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### C. Загрузить код backend:
```bash
# Создать папку
mkdir -p /var/www/rabbitfarm
cd /var/www/rabbitfarm

# Загрузить код (через git, scp, ftp - на ваш выбор)
# Папка backend должна быть в /var/www/rabbitfarm/backend
```

#### D. Настроить .env:
```bash
cd /var/www/rabbitfarm/backend
nano .env
```

Вставить (ИЗМЕНИТЬ ПАРОЛИ И СЕКРЕТЫ!):
```env
NODE_ENV=production
PORT=4567
API_VERSION=v1

DB_HOST=localhost
DB_PORT=3306
DB_NAME=rabbitfarm
DB_USER=rabbitfarm_user
DB_PASSWORD=ВАШ_ПАРОЛЬ_БД

# Сгенерировать: node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
JWT_SECRET=СЛУЧАЙНАЯ_СТРОКА_64_СИМВОЛА
JWT_REFRESH_SECRET=ДРУГАЯ_СЛУЧАЙНАЯ_СТРОКА_64_СИМВОЛА
JWT_EXPIRE=15m
JWT_REFRESH_EXPIRE=7d

MAX_FILE_SIZE=5242880
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/jpg
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
CORS_ORIGIN=*
LOG_LEVEL=info
```

#### E. Установить зависимости и запустить:
```bash
# Установить
npm install --production

# Миграции
npm run db:migrate

# Запустить
pm2 start ecosystem.config.js --env production

# Автозапуск при перезагрузке
pm2 startup
# ВЫПОЛНИТЕ КОМАНДУ, КОТОРУЮ ВЫДАСТ PM2!
pm2 save

# Проверить
pm2 status
curl http://localhost:4567/health
```

---

### 2️⃣ НА ВАШЕМ КОМПЬЮТЕРЕ (Windows)

#### A. Собрать APK одной командой:

**Вариант 1: Используйте готовый скрипт**
```cmd
deploy-mobile.bat
```

**Вариант 2: Вручную**
```cmd
cd mobile
flutter clean
flutter pub get
flutter build apk --release --dart-define=API_URL=http://108.181.167.236:4567/api/v1
```

APK будет здесь: `mobile\build\app\outputs\flutter-apk\app-release.apk`

#### B. Установить APK на телефон:

1. Скопируйте `app-release.apk` на телефон
2. Откройте файл на телефоне
3. Разрешите установку из неизвестных источников (если спросит)
4. Установите

---

## ✅ ПРОВЕРКА

### Backend:
```bash
# Health check
curl http://108.181.167.236:4567/health

# API info  
curl http://108.181.167.236:4567/api/v1

# Регистрация
curl -X POST http://108.181.167.236:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test123!","full_name":"Test","role":"owner"}'
```

### Frontend:
1. Откройте приложение на телефоне
2. Зарегистрируйтесь
3. Войдите
4. Проверьте все функции

---

## 🔧 ПОЛЕЗНЫЕ КОМАНДЫ

### На сервере:
```bash
# Логи
pm2 logs rabbitfarm-api

# Перезапуск
pm2 restart rabbitfarm-api

# Статус
pm2 status

# Остановить
pm2 stop rabbitfarm-api
```

---

## 📚 ПОЛНАЯ ДОКУМЕНТАЦИЯ

Для деталей смотрите: **PRODUCTION_DEPLOYMENT.md**

---

## 🎉 ГОТОВО!

После этих шагов:
- ✅ Backend работает на http://108.181.167.236:4567
- ✅ APK готов для установки
- ✅ Всё настроено для production

**Начинайте использовать! 🐰**
