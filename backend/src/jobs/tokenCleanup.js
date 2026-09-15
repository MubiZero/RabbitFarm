const { Op } = require('sequelize');
const { RefreshToken, TokenBlacklist } = require('../models');
const notificationFeedService = require('../services/notificationFeedService');
const logger = require('../utils/logger');

const CLEANUP_INTERVAL_MS = 60 * 60 * 1000; // Every hour

async function cleanExpiredTokens() {
  try {
    const now = new Date();

    const deletedRefresh = await RefreshToken.destroy({
      where: { expires_at: { [Op.lt]: now } }
    });

    const deletedBlacklist = await TokenBlacklist.destroy({
      where: { expires_at: { [Op.lt]: now } }
    });

    // Лента уведомлений — не архив: её смысл в том, чтобы не пропустить дело
    // на этой неделе, и вниз по ней никто не листает. Без ограничения
    // таблица растёт вечно.
    const deletedNotifications = await notificationFeedService.purgeOlderThan(90);
    if (deletedNotifications > 0) {
      logger.info('Old notifications purged', { count: deletedNotifications });
    }

    if (deletedRefresh > 0 || deletedBlacklist > 0) {
      logger.info('Token cleanup completed', {
        expiredRefreshTokens: deletedRefresh,
        expiredBlacklistEntries: deletedBlacklist
      });
    }
  } catch (error) {
    logger.error('Token cleanup failed', { error: error.message });
  }
}

function startTokenCleanupJob() {
  // Run immediately on startup, then on interval
  cleanExpiredTokens();
  const interval = setInterval(cleanExpiredTokens, CLEANUP_INTERVAL_MS);

  logger.info('Token cleanup job started', { intervalMs: CLEANUP_INTERVAL_MS });

  return interval;
}

module.exports = { startTokenCleanupJob, cleanExpiredTokens };
