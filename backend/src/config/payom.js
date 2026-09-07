require('dotenv').config();

/**
 * Payom SMS (gateway.payom.tj) — опциональная интеграция, как Firebase:
 * сервис стартует и без неё, просто не уходят SMS.
 *
 * Карта «ключ уведомления → templateId» — JSON в одной переменной, а не
 * россыпь `SMS_TEMPLATE_IDS__<key>`, как в исходном .NET-примере: в Node
 * россыпь пришлось бы парсить руками из process.env по префиксу, а один
 * JSON и читается, и валидируется проще.
 */
const baseUrl = process.env.SMS_BASE_URL || 'https://gateway.payom.tj';
const apiToken = process.env.SMS_API_TOKEN;
const senderName = process.env.SMS_SENDER_NAME;
const timeoutSeconds = Number(process.env.SMS_TIMEOUT_SECONDS) || 15;

// Ломать require() из-за опечатки в JSON — тот же класс ошибки, что и
// падение сервиса из-за отсутствующего FIREBASE_PROJECT_ID: недоступна
// станет только отправка конкретного уведомления, а не всё приложение.
// Отправка без нужного шаблона сама откажет понятной ошибкой.
let templateIds = {};
try {
  templateIds = JSON.parse(process.env.SMS_TEMPLATE_IDS || '{}');
} catch {
  templateIds = {};
}

module.exports = {
  baseUrl,
  apiToken,
  senderName,
  timeoutSeconds,
  templateIds,
  isConfigured: Boolean(apiToken && senderName)
};
