const nodemailer = require('nodemailer');
const config = require('../../config/mailer');
const logger = require('../../utils/logger');

/**
 * Отправить код сброса пароля по email через SMTP.
 *
 * @throws {Error} с `error.permanent = true`, если повтор не поможет
 *   (не настроено, неверные креды — EAUTH) — и `false`/`undefined`,
 *   если стоит повторить (сеть, временный отказ шлюза 4xx).
 */
async function sendPasswordResetEmail({ to, code }) {
  if (!config.isConfigured) {
    const error = new Error('EMAIL_NOT_CONFIGURED');
    error.permanent = true;
    throw error;
  }

  const transporter = nodemailer.createTransport({
    host: config.host,
    port: config.port,
    secure: config.secure,
    requireTLS: config.useStartTls,
    auth: { user: config.username, pass: config.password }
  });

  try {
    return await transporter.sendMail({
      from: `"${config.fromName}" <${config.fromAddress}>`,
      to,
      subject: 'Код для сброса пароля RabbitFarm',
      text: `Ваш код для сброса пароля: ${code}. Действует 15 минут.`
    });
  } catch (err) {
    err.permanent = err.code === 'EAUTH' || (err.responseCode != null && err.responseCode >= 500);
    logger.error('Email send failed', { code: err.code, responseCode: err.responseCode });
    throw err;
  }
}

module.exports = { sendPasswordResetEmail };
