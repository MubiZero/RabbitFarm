# RabbitFarm - Backend & Frontend Setup Guide

## Последнее обновление: 2025-12-08

## 🎯 Быстрый старт

### Backend (Node.js)

#### 1. Установка зависимостей
```bash
cd backend
npm install
```

#### 2. Настройка базы данных
Убедитесь, что MySQL запущен и доступен на порту 3306.

```bash
# Создать базу данных (если еще не создана)
npm run db:create

# Запустить миграции
npm run db:migrate

# (Опционально) Заполнить тестовыми данными
npm run db:seed
```

#### 3. Проверка файла .env
Убедитесь, что файл `.env` существует и содержит правильные настройки:

```env
# Server Configuration
NODE_ENV=development
PORT=4567
API_VERSION=v1

# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=rabbitfarm
DB_USER=rabbitfarm_user
DB_PASSWORD=your_secure_password

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=15m
JWT_REFRESH_SECRET=your_super_secret_refresh_key_change_this_in_production
JWT_REFRESH_EXPIRE=7d

# Upload Configuration
MAX_FILE_SIZE=5242880
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/jpg

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS (не используется, так как CORS настроен на прием всех источников)
CORS_ORIGIN=*

# Logging
LOG_LEVEL=info
```

#### 4. Запуск сервера

**Development режим с auto-reload:**
```bash
npm run dev
```

**Production режим:**
```bash
npm start
```

**Проверка статуса:**
- Health check: http://localhost:4567/health
- API Info: http://localhost:4567/api/v1

### Frontend (Flutter)

#### 1. Установка зависимостей
```bash
cd mobile
flutter pub get
```

#### 2. Настройка API URL

##### Вариант 1: Использование production URL (по умолчанию)
Текущий URL: `http://108.181.167.236:4567/api/v1`

```bash
flutter run
```

##### Вариант 2: Использование локального сервера
```bash
# Для Android эмулятора
flutter run --dart-define=API_URL=http://10.0.2.2:4567/api/v1

# Для физического устройства (замените на IP вашего компьютера)
flutter run --dart-define=API_URL=http://192.168.1.XXX:4567/api/v1

# Для iOS симулятора или веб
flutter run --dart-define=API_URL=http://localhost:4567/api/v1
```

#### 3. Сборка APK для production

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK с production URL:**
```bash
flutter build apk --release --dart-define=API_URL=http://108.181.167.236:4567/api/v1
```

**Release APK с custom URL:**
```bash
flutter build apk --release --dart-define=API_URL=http://YOUR_SERVER_IP:4567/api/v1
```

Готовый APK будет в: `build/app/outputs/flutter-apk/app-release.apk`

## 🔧 Исправленные проблемы

### ✅ CORS Configuration
- **Проблема**: Сложная конфигурация могла блокировать запросы от мобильного приложения
- **Решение**: Упрощена конфигурация CORS для приема всех источников с нужными headers
- **Файл**: `backend/src/app.js`

### ✅ CORS Debugging
- **Добавлено**: Логирование всех CORS запросов в development режиме
- **Польза**: Легче отлаживать проблемы с подключением
- **Файл**: `backend/src/app.js`

### ✅ Health Check
- **Добавлено**: Проверка статуса подключения к базе данных
- **Польза**: Можно быстро диагностировать проблемы с БД
- **Файл**: `backend/src/app.js`

### ✅ Environment-based Configuration
- **Добавлено**: Поддержка переменных окружения для API URL на фронтенде
- **Польза**: Легко переключаться между development и production
- **Файл**: `mobile/lib/core/api/api_endpoints.dart`

## 📋 Проверка работоспособности

### 1. Backend Health Check
```bash
curl http://localhost:4567/health
```

**Ожидаемый ответ:**
```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2025-12-08T10:19:27.000Z",
  "uptime": 123.456,
  "environment": "development",
  "version": "v1"
}
```

### 2. Test API Endpoints

**Регистрация:**
```bash
curl -X POST http://localhost:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123!",
    "full_name": "Test User",
    "role": "owner"
  }'
```

**Логин:**
```bash
curl -X POST http://localhost:4567/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123!"
  }'
```

### 3. Frontend Testing

После запуска приложения:
1. Откройте экран регистрации
2. Создайте нового пользователя
3. Войдите в систему
4. Проверьте, что токены сохранены
5. Попробуйте выполнить операции с кроликами

## 🐛 Отладка

### Backend не запускается
1. **Проверьте порт 4567:**
   ```bash
   netstat -ano | findstr :4567
   ```
   
2. **Проверьте подключение к MySQL:**
   ```bash
   mysql -u rabbitfarm_user -p -h localhost
   ```

3. **Проверьте логи:**
   ```bash
   tail -f backend/logs/combined.log
   ```

### Frontend не подключается к API

1. **Проверьте, что backend запущен:**
   ```bash
   curl http://localhost:4567/health
   ```

2. **Для Android эмулятора используйте:**
   ```
   http://10.0.2.2:4567/api/v1
   ```

3. **Для физического устройства:**
   - Убедитесь, что устройство в той же WiFi сети
   - Используйте IP адрес компьютера, а не localhost
   - Проверьте firewall на компьютере

4. **Проверьте логи Flutter:**
   ```bash
   flutter logs
   ```

### CORS ошибки

В файле `backend/src/app.js` уже настроен правильный CORS.
Если все еще есть проблемы:

1. Проверьте логи в development режиме (они покажут все CORS запросы)
2. Убедитесь, что headers правильно установлены в запросах
3. Проверьте, что используете правильный baseUrl

## 🔐 Безопасность

### Production Checklist:
- [ ] Изменить JWT_SECRET в .env
- [ ] Изменить JWT_REFRESH_SECRET в .env
- [ ] Установить сложные пароли для БД
- [ ] Настроить HTTPS (если возможно)
- [ ] Ограничить CORS только для нужных доменов (опционально)
- [ ] Настроить rate limiting по необходимости
- [ ] Убедиться, что .env не коммитится в git

## 📚 Дополнительные ресурсы

- **API Documentation**: `backend/API_TESTING.md`
- **Architecture**: `ARCHITECTURE.md`
- **Deployment Guide**: `DEPLOYMENT_GUIDE.md`
- **Project Summary**: `PROJECT_SUMMARY.md`
- **Review & Fixes**: `REVIEW_AND_FIXES.md`

## 🚀 Production Deployment

### Backend на удаленном сервере (PM2):
```bash
# На сервере
cd backend
npm install --production
pm2 start ecosystem.config.js
pm2 save
```

### Frontend для production:
```bash
flutter build apk --release --dart-define=API_URL=http://your-production-server.com:4567/api/v1
```

## ⚙️ Настройки по умолчанию

| Параметр | Значение |
|----------|----------|
| Backend Port | 4567 |
| API Version | v1 |
| Database Port | 3306 |
| JWT Access Token Expiry | 15 minutes |
| JWT Refresh Token Expiry | 7 days |
| Max File Upload Size | 5MB |
| Rate Limit | 100 requests per 15 minutes |

## 🎉 Готово!

После выполнения всех шагов:
- ✅ Backend работает на http://localhost:4567
- ✅ API доступен на http://localhost:4567/api/v1
- ✅ База данных подключена
- ✅ CORS настроен корректно
- ✅ Frontend может подключаться к API
- ✅ Аутентификация работает

Теперь можно начинать работу с приложением! 🐰
