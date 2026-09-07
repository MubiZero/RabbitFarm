const multer = require('multer');
const { EXTENSION_BY_MIME } = require('../utils/fileStorage');

// Файл держим в памяти, а не на диске: следующий шаг — загрузка в MinIO,
// а не в локальную файловую систему контейнера.
const storage = multer.memoryStorage();

// File filter
const fileFilter = (req, file, cb) => {
  const allowedMimes = (process.env.ALLOWED_FILE_TYPES || 'image/jpeg,image/png,image/jpg').split(',');

  if (allowedMimes.includes(file.mimetype) && Object.hasOwn(EXTENSION_BY_MIME, file.mimetype)) {
    cb(null, true);
  } else {
    // MulterError, а не обычный Error: обработчик ошибок различает их по имени
    // и только для MulterError отвечает понятным 400 вместо общего 500.
    const error = new multer.MulterError('LIMIT_UNEXPECTED_FILE', file.fieldname);
    error.userMessage = `Недопустимый тип файла. Разрешены: ${allowedMimes.join(', ')}`;
    cb(error, false);
  }
};

// Multer configuration
const upload = multer({
  storage: storage,
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 5 * 1024 * 1024 // 5MB default
  },
  fileFilter: fileFilter
});

module.exports = upload;
