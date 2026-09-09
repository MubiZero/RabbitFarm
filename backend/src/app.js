const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');

const logger = require('./utils/logger');
const { errorHandler, notFoundHandler } = require('./middleware/errorHandler');
const { generalLimiter } = require('./middleware/rateLimiter');
const { checkAppVersion } = require('./middleware/appVersion');
const routes = require('./routes');
const filesRoutes = require('./routes/files.routes');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');

// Create Express app
const app = express();

// Trust proxy (for rate limiting behind reverse proxy)
app.set('trust proxy', 1);

// Security middleware
app.use(helmet());

// CORS. Мобильные клиенты ходят без Origin, поэтому запросы без него
// пропускаем; для браузеров список разрешённых источников задаёт CORS_ORIGIN.
// Пустой список означает «только не-браузерные клиенты»: раньше здесь стоял
// origin: true, то есть любой сайт мог обращаться к API от имени вошедшего
// владельца, несмотря на аккуратно настроенный CORS_ORIGIN в compose-файле.
const allowedOrigins = (process.env.CORS_ORIGIN || '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);

const allowAnyOrigin = allowedOrigins.includes('*');

if (allowAnyOrigin && process.env.NODE_ENV === 'production') {
  logger.warn(
    'CORS_ORIGIN=* вместе с cookie-аутентификацией разрешает запросы к API ' +
    'с любого сайта от имени вошедшего пользователя. Укажите адрес веб-клиента.'
  );
}

const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowAnyOrigin || allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error('Источник не разрешён политикой CORS'));
  },
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With'],
  exposedHeaders: ['Content-Length', 'X-Total-Count']
};
app.use(cors(corsOptions));

// Compression middleware
app.use(compression());

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// HTTP request logging
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));

  // CORS debugging middleware
  app.use((req, res, next) => {
    logger.info('CORS Request', {
      origin: req.headers.origin || 'no-origin',
      method: req.method,
      path: req.path,
      headers: {
        authorization: req.headers.authorization ? 'Bearer ***' : 'none',
        'content-type': req.headers['content-type'] || 'none'
      }
    });
    next();
  });
} else {
  app.use(morgan('combined', {
    stream: {
      write: (message) => logger.info(message.trim())
    }
  }));
}

// Загруженные файлы — из MinIO, не с локального диска (см. files.routes.js).
app.use('/uploads', filesRoutes);

// Rate limiting (disabled in test environment)
if (process.env.NODE_ENV !== 'test') {
  app.use('/api/', generalLimiter);
}

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await require('./models').sequelize.authenticate();
    const dbStatus = 'connected';

    res.status(200).json({
      status: 'healthy',
      database: dbStatus,
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV,
      version: process.env.API_VERSION || 'v1'
    });
  } catch (error) {
    // Подробности только в лог: сообщение MySQL раскрывает хост, порт и имя
    // пользователя любому, кто дёрнет /health.
    logger.error('Health check failed', { error: error.message });

    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV,
      version: process.env.API_VERSION || 'v1'
    });
  }
});

// Swagger UI
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  customSiteTitle: 'RabbitFarm API Docs'
}));
app.get('/api-docs.json', (req, res) => res.json(swaggerSpec));

// Минимальная поддерживаемая версия мобильного приложения. Стоит перед
// маршрутами, но после /health: наблюдение за сервисом не должно зависеть от
// версии клиента, который в него постучался.
app.use('/api/', checkAppVersion);

// API routes
app.use(`/api/${process.env.API_VERSION || 'v1'}`, routes);

// 404 handler
app.use(notFoundHandler);

// Global error handler (must be last)
app.use(errorHandler);

module.exports = app;
