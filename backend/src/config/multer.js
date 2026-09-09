const multer = require('multer');
const { EXTENSION_BY_MIME } = require('../utils/fileStorage');
const { detectMimeType } = require('../utils/fileSignature');

// Файл держим в памяти, а не на диске: следующий шаг — загрузка в MinIO,
// а не в локальную файловую систему контейнера.
const storage = multer.memoryStorage();

// SVG браузер исполняет как документ со скриптами, а санитайзера для него в
// проекте нет — поэтому запрет живёт в коде и не снимается через .env.
const FORBIDDEN_MIME_TYPES = new Set(['image/svg+xml']);

// image/jpg — не настоящий MIME, но он есть и в ALLOWED_FILE_TYPES, и в
// запросах клиентов; по содержимому это тот же image/jpeg.
const MIME_ALIASES = { 'image/jpg': 'image/jpeg' };

const normalizeMime = (mime) => MIME_ALIASES[mime] || mime;

/**
 * Типы, разрешённые к загрузке: конфигурация минус то, что запрещено в коде,
 * и минус то, для чего сервер не знает расширения (EXTENSION_BY_MIME).
 */
function allowedMimeTypes() {
  const configured = (process.env.ALLOWED_FILE_TYPES || 'image/jpeg,image/png,image/jpg')
    .split(',')
    .map(mime => mime.trim())
    .filter(Boolean);

  return configured.filter(mime =>
    !FORBIDDEN_MIME_TYPES.has(mime) && Object.hasOwn(EXTENSION_BY_MIME, mime)
  );
}

function isAllowedMime(mime) {
  const normalized = normalizeMime(mime);
  if (FORBIDDEN_MIME_TYPES.has(mime) || FORBIDDEN_MIME_TYPES.has(normalized)) return false;
  return allowedMimeTypes().some(allowed => normalizeMime(allowed) === normalized);
}

// MulterError, а не обычный Error: обработчик ошибок различает их по имени
// и только для MulterError отвечает понятным 400 вместо общего 500.
function rejection(fieldname, userMessage) {
  const error = new multer.MulterError('LIMIT_UNEXPECTED_FILE', fieldname);
  error.userMessage = userMessage;
  return error;
}

// Первый, дешёвый рубеж: отсекаем заведомо чужой тип ещё до того, как тело
// файла прочитано. Заявленному значению тут не верят — его перепроверяет
// verifyFileContent; здесь оно нужно, чтобы не тянуть в память мусор.
const fileFilter = (req, file, cb) => {
  if (isAllowedMime(file.mimetype)) {
    cb(null, true);
  } else {
    cb(rejection(file.fieldname, `Недопустимый тип файла. Разрешены: ${allowedMimeTypes().join(', ')}`), false);
  }
};

const multerUpload = multer({
  storage: storage,
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 5 * 1024 * 1024 // 5MB default
  },
  fileFilter: fileFilter
});

function uploadedFiles(req) {
  if (req.file) return [req.file];
  if (Array.isArray(req.files)) return req.files;
  if (req.files) return Object.values(req.files).flat();
  return [];
}

/**
 * Второй рубеж: тип по содержимому.
 *
 * `file.mimetype` — это строка, которую клиент написал сам, и назвать
 * исполняемый файл «image/png» ему ничто не мешает. Поэтому после того, как
 * файл прочитан в память, тип определяется по сигнатуре, а дальше по цепочке
 * (имя объекта, Content-Type в хранилище) уходит уже он. В fileFilter это
 * сделать нельзя: он вызывается до чтения тела файла.
 */
function verifyFileContent(req, res, next) {
  for (const file of uploadedFiles(req)) {
    const declared = normalizeMime(file.mimetype);
    const detected = detectMimeType(file.buffer);

    if (!detected) {
      return next(rejection(
        file.fieldname,
        `Содержимое файла не похоже ни на один разрешённый формат. Разрешены: ${allowedMimeTypes().join(', ')}`
      ));
    }

    if (!isAllowedMime(detected)) {
      return next(rejection(
        file.fieldname,
        `Файл на самом деле имеет тип ${detected}. Разрешены: ${allowedMimeTypes().join(', ')}`
      ));
    }

    if (detected !== declared) {
      return next(rejection(
        file.fieldname,
        `Содержимое файла не соответствует заявленному типу: заявлен ${file.mimetype}, фактически ${detected}`
      ));
    }

    file.mimetype = detected;
  }

  next();
}

// Обёртка, а не голый multer: так маршрут не может подключить загрузку и
// забыть про проверку содержимого — она едет вместе с ней.
const upload = {
  single: (fieldName) => [multerUpload.single(fieldName), verifyFileContent],
  array: (fieldName, maxCount) => [multerUpload.array(fieldName, maxCount), verifyFileContent],
  fields: (spec) => [multerUpload.fields(spec), verifyFileContent],
  allowedMimeTypes
};

module.exports = upload;
