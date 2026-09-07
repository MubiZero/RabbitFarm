/**
 * Диплинк в приложение банка строится из invoiceUrl — берётся последний
 * сегмент пути. Приложения на телефоне может не быть: вызывающий код
 * обязан держать invoiceUrl как запасной вариант (страницей), а не только
 * диплинк.
 *
 * invoiceUrl: https://…/invoices/77.4368.<guid> → eskhata://pay/77.4368.<guid>
 */
function buildDeepLink(invoiceUrl) {
  const segments = invoiceUrl.split('/').filter(Boolean);
  const lastSegment = segments[segments.length - 1];
  return `eskhata://pay/${lastSegment}`;
}

module.exports = { buildDeepLink };
