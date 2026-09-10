require('dotenv').config();

/**
 * Бот для алертов в Telegram — свободный вариант вместо платного
 * PagerDuty/Opsgenie: чат один, событий на старте мало, а сообщение долетает
 * мгновенно на телефон, который и так открыт. Опционально, как SMTP и Sentry.
 */
const botToken = process.env.TELEGRAM_ALERT_BOT_TOKEN;
const chatId = process.env.TELEGRAM_ALERT_CHAT_ID;

module.exports = {
  botToken,
  chatId,
  isConfigured: Boolean(botToken && chatId)
};
