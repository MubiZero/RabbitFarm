require('dotenv').config();
require('./instrument'); // Sentry — до всех остальных require, см. комментарий в файле
const validateEnv = require('./config/validateEnv');

// Validate environment variables before anything else
if (process.env.NODE_ENV !== 'test') {
  validateEnv();
}

const app = require('./app');
const logger = require('./utils/logger');
const { sequelize } = require('./models');
const { ensureBucket } = require('./config/minio');
const { startTokenCleanupJob } = require('./jobs/tokenCleanup');
const { startNotificationDigestJob } = require('./jobs/notificationDigestJob');
const { startFarmPurgeJob } = require('./jobs/farmPurgeJob');
const { startPlanExpiryReminderJob } = require('./jobs/planExpiryReminderJob');
const { startInactivityWinbackJob } = require('./jobs/inactivityWinbackJob');

const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Test database connection
async function testDatabaseConnection() {
  try {
    await sequelize.authenticate();
    logger.info('Database connection established successfully');
    return true;
  } catch (error) {
    logger.error('Unable to connect to database', { error: error.message });
    return false;
  }
}

// Start server
async function startServer() {
  try {
    // Test database connection
    const dbConnected = await testDatabaseConnection();

    if (!dbConnected) {
      logger.error('Failed to connect to database. Exiting...');
      process.exit(1);
    }

    // Бакет для загрузок. В отличие от БД не роняем старт: сам сервис не
    // зависит от MinIO целиком, недоступен окажется только аплоад фото —
    // это должно упасть понятной ошибкой на конкретном запросе, а не
    // положить весь сервер.
    try {
      await ensureBucket();
    } catch (error) {
      logger.error('MinIO недоступен при старте — загрузка файлов не будет работать', {
        error: error.message
      });
    }

    // Start background jobs
    if (process.env.NODE_ENV !== 'test') {
      startTokenCleanupJob();
      startNotificationDigestJob();
      startFarmPurgeJob();
      startPlanExpiryReminderJob();
      startInactivityWinbackJob();
    }

    // Start listening
    const server = app.listen(PORT, () => {
      logger.info(`Server started successfully`, {
        port: PORT,
        environment: NODE_ENV,
        pid: process.pid
      });
      console.log(`\n🚀 Server is running on http://localhost:${PORT}`);
      console.log(`📚 API Documentation: http://localhost:${PORT}/api/${process.env.API_VERSION || 'v1'}`);
      console.log(`💚 Health Check: http://localhost:${PORT}/health\n`);
    });

    // Graceful shutdown
    const gracefulShutdown = async (signal) => {
      logger.info(`${signal} received, starting graceful shutdown`);

      server.close(async () => {
        logger.info('HTTP server closed');

        try {
          await sequelize.close();
          logger.info('Database connection closed');
          process.exit(0);
        } catch (error) {
          logger.error('Error during shutdown', { error: error.message });
          process.exit(1);
        }
      });

      // Force shutdown after 10 seconds
      setTimeout(() => {
        logger.error('Forced shutdown after timeout');
        process.exit(1);
      }, 10000);
    };

    // Handle shutdown signals
    process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
    process.on('SIGINT', () => gracefulShutdown('SIGINT'));

    // Handle uncaught errors
    process.on('uncaughtException', (error) => {
      logger.error('Uncaught Exception', { error: error.message, stack: error.stack });
      process.exit(1);
    });

    process.on('unhandledRejection', (reason, promise) => {
      logger.error('Unhandled Rejection', { reason, promise });
      process.exit(1);
    });

  } catch (error) {
    logger.error('Failed to start server', { error: error.message });
    process.exit(1);
  }
}

// Start the server
startServer();
