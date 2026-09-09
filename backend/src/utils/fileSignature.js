/**
 * Определение типа файла по сигнатуре — первым байтам самого содержимого.
 *
 * Свой маленький справочник вместо пакета file-type: все его сборки с
 * CommonJS (<19) подпадают под GHSA-5v7r-6r5c-r473 — зацикливание парсера на
 * подделанном ASF-заголовке, то есть отказ в обслуживании ровно на том же
 * пути загрузки, который эта проверка и защищает (воспроизводится на буфере
 * в 1 КБ). Версии с исправлением — только ESM, а бэкенд и тесты на CommonJS.
 * Форматов в allowlist четыре, их сигнатуры зафиксированы стандартами, и
 * разбирать ради них сотню чужих контейнеров не нужно.
 */

const SIGNATURES = [
  { mime: 'image/png', parts: [{ offset: 0, bytes: [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a] }] },
  { mime: 'image/jpeg', parts: [{ offset: 0, bytes: [0xff, 0xd8, 0xff] }] },
  // WebP — контейнер RIFF: тип лежит не в начале, а через поле размера.
  {
    mime: 'image/webp',
    parts: [
      { offset: 0, bytes: [0x52, 0x49, 0x46, 0x46] },
      { offset: 8, bytes: [0x57, 0x45, 0x42, 0x50] }
    ]
  },
  { mime: 'application/pdf', parts: [{ offset: 0, bytes: [0x25, 0x50, 0x44, 0x46, 0x2d] }] }
];

function matchesPart(buffer, { offset, bytes }) {
  if (buffer.length < offset + bytes.length) return false;
  return bytes.every((byte, index) => buffer[offset + index] === byte);
}

/**
 * Реальный MIME-тип содержимого либо null, если формат не из списка выше.
 * Текстовые форматы (в том числе SVG) сигнатуры не имеют и всегда дают null.
 */
function detectMimeType(buffer) {
  if (!Buffer.isBuffer(buffer) || buffer.length === 0) return null;

  const signature = SIGNATURES.find(({ parts }) => parts.every(part => matchesPart(buffer, part)));
  return signature ? signature.mime : null;
}

module.exports = {
  detectMimeType,
  DETECTABLE_MIME_TYPES: SIGNATURES.map(({ mime }) => mime)
};
