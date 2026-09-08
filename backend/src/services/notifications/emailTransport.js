const nodemailer = require('nodemailer');
const config = require('../../config/mailer');
const logger = require('../../utils/logger');

function createTransporter() {
  return nodemailer.createTransport({
    host: config.host,
    port: config.port,
    secure: config.secure,
    requireTLS: config.useStartTls,
    auth: { user: config.username, pass: config.password }
  });
}

/**
 * Отправить письмо через SMTP.
 *
 * @throws {Error} с `error.permanent = true`, если повтор не поможет
 *   (не настроено, неверные креды — EAUTH) — и `false`/`undefined`,
 *   если стоит повторить (сеть, временный отказ шлюза 4xx).
 */
async function sendEmail({ to, subject, text }) {
  if (!config.isConfigured) {
    const error = new Error('EMAIL_NOT_CONFIGURED');
    error.permanent = true;
    throw error;
  }

  try {
    return await createTransporter().sendMail({
      from: `"${config.fromName}" <${config.fromAddress}>`,
      to,
      subject,
      text
    });
  } catch (err) {
    err.permanent = err.code === 'EAUTH' || (err.responseCode != null && err.responseCode >= 500);
    logger.error('Email send failed', { code: err.code, responseCode: err.responseCode });
    throw err;
  }
}

/** Отправить код сброса пароля по email. */
async function sendPasswordResetEmail({ to, code }) {
  return sendEmail({
    to,
    subject: 'Код для сброса пароля RabbitFarm',
    text: `Ваш код для сброса пароля: ${code}. Действует 15 минут.`
  });
}

/** Отправить объявление платформенного админа одному получателю. */
async function sendAnnouncementEmail({ to, subject, text }) {
  return sendEmail({ to, subject, text });
}

module.exports = { sendPasswordResetEmail, sendAnnouncementEmail };
