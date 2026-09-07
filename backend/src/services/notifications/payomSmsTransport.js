const config = require('../../config/payom');
const logger = require('../../utils/logger');

// Кириллица уходит как UCS-2: 70 символов в сегмент, дальше — второе
// сообщение и двойной счёт. Фиксированная часть шаблона кода вместе с
// шестизначным кодом съедает около 28 символов, на подставляемое значение
// остаётся примерно 40 — обрезаем на своей стороне, а не полагаемся на то,
// что шлюз молча разобьёт длинное сообщение на два платных.
const MAX_VARIABLE_LENGTH = 40;

function truncate(value, max = MAX_VARIABLE_LENGTH) {
  const str = String(value);
  return str.length > max ? str.slice(0, max) : str;
}

/**
 * Отправить SMS по шаблону.
 *
 * Шлюз не принимает свободный текст — только заранее одобренный шаблон и
 * значения его плейсхолдеров. `templateKey` — наш внутренний ключ
 * («user.verification_code» и т.п.), реальный `templateId` шлюза достаётся
 * из конфига: правка формулировки в кабинете payom меняет templateId, и
 * это не должно требовать выкладки кода.
 *
 * @throws {Error} с `error.permanent = true`, если повтор не поможет
 *   (не настроено, неверный токен/имя отправителя, шаблон/тип плейсхолдера
 *   не подходит) — и `false`/`undefined`, если стоит повторить.
 */
async function sendTemplateSms({ templateKey, telephone, variables = {} }) {
  if (!config.isConfigured) {
    const error = new Error('SMS_NOT_CONFIGURED');
    error.permanent = true;
    throw error;
  }

  const templateId = config.templateIds[templateKey];
  if (!templateId) {
    const error = new Error(`SMS_TEMPLATE_NOT_CONFIGURED: ${templateKey}`);
    error.permanent = true;
    throw error;
  }

  const safeVariables = Object.fromEntries(
    Object.entries(variables).map(([key, value]) => [key, truncate(value)])
  );

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), config.timeoutSeconds * 1000);

  let response;
  try {
    response = await fetch(`${config.baseUrl}/api/message`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${config.apiToken}`
      },
      body: JSON.stringify({
        telephone,
        senderName: config.senderName,
        type: 'SMS',
        templateMessage: { templateId, variables: safeVariables }
      }),
      signal: controller.signal
    });
  } finally {
    clearTimeout(timeout);
  }

  const bodyText = await response.text();
  let body = null;
  try {
    body = JSON.parse(bodyText);
  } catch {
    body = null;
  }

  // 201 без id неотличим от проглоченного сообщения — считаем временным
  // сбоем и оставляем вызывающему коду решать про повтор, как и для 5xx.
  if (response.status === 201 && body && body.id) {
    return body;
  }

  const detail = (body && (body.detail || body.message || body.error)) || bodyText.slice(0, 300);
  const error = new Error(detail || `SMS_SEND_FAILED_${response.status}`);
  error.status = response.status;
  error.permanent = [401, 403, 422].includes(response.status);

  logger.error('SMS send failed', { status: response.status, detail, templateKey });
  throw error;
}

module.exports = { sendTemplateSms, truncate, MAX_VARIABLE_LENGTH };
