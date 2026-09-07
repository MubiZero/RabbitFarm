require('dotenv').config();

/**
 * Firebase Cloud Messaging — опциональная интеграция.
 *
 * В отличие от JWT-секретов, эта конфигурация не обязательна: сервис должен
 * запускаться и на стенде, где Firebase-проект ещё не заведён. Отсутствие
 * переменных не валится в validateEnv — notificationService сам проверяет
 * `isConfigured` и молча не отправляет, вместо падения при старте.
 */
const projectId = process.env.FIREBASE_PROJECT_ID;
const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
// В .env приватный ключ хранится в одну строку с литеральными `\n` —
// переносы восстанавливаем перед передачей в firebase-admin.
const privateKey = process.env.FIREBASE_PRIVATE_KEY
  ? process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')
  : undefined;

module.exports = {
  projectId,
  clientEmail,
  privateKey,
  isConfigured: Boolean(projectId && clientEmail && privateKey)
};
