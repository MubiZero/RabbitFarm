const config = require('../config/telegram');

// Не долбить один и тот же алерт: упавшая cron-джоба или лежащая база иначе
// шлют сообщение на каждую ошибку подряд, а не один раз с фактом проблемы.
const THROTTLE_MS = 5 * 60 * 1000;
const lastSentAt = new Map();

function shouldThrottle(key) {
  const now = Date.now();
  const last = lastSentAt.get(key);
  if (last && now - last < THROTTLE_MS) return true;
  lastSentAt.set(key, now);
  return false;
}

/**
 * Отправить алерт в Telegram-чат. Без токена/chat_id — no-op, как остальные
 * опциональные интеграции (SMTP, Sentry). Сбой самой отправки только
 * пишется в консоль напрямую: звать сюда `logger.error` означало бы
 * рекурсию через тот же транспорт, который это и вызвал.
 */
async function sendAlert(text) {
  if (!config.isConfigured) return;
  if (shouldThrottle(text.slice(0, 200))) return;

  try {
    const response = await fetch(
      `https://api.telegram.org/bot${config.botToken}/sendMessage`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ chat_id: config.chatId, text })
      }
    );
    if (!response.ok) {
      console.error('Telegram alert failed', response.status, await response.text());
    }
  } catch (error) {
    console.error('Telegram alert failed', error.message);
  }
}

module.exports = { sendAlert };
