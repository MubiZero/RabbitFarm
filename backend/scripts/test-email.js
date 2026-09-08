/**
 * Ручная проверка отправки письма через собственный SMTP (Stalwart).
 * Не часть автотестов — одноразовый прогон, чтобы подтвердить доставку
 * и что SPF/DKIM/DMARC проходят на стороне получателя.
 *
 * Перед запуском заполни в backend/.env:
 *   SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD, SMTP_FROM_ADDRESS
 * и передай адрес получателя через переменную окружения запуска:
 *
 *   EMAIL_TEST_TO=you@example.com node scripts/test-email.js
 */
require('dotenv').config();
const { sendPasswordResetEmail } = require('../src/services/notifications/emailTransport');

const to = process.env.EMAIL_TEST_TO;

if (!to) {
  console.error('Задай EMAIL_TEST_TO перед запуском.');
  process.exit(1);
}

sendPasswordResetEmail({ to, code: '123456' })
  .then((info) => {
    console.log('OK', info);
  })
  .catch((err) => {
    console.error('FAIL', { message: err.message, code: err.code, permanent: err.permanent });
    process.exit(1);
  });
