const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure upload directories exist
const uploadDirs = {
  rabbits: path.join(__dirname, '../../uploads/rabbits'),
  receipts: path.join(__dirname, '../../uploads/receipts'),
  temp: path.join(__dirname, '../../uploads/temp')
};

Object.values(uploadDirs).forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// Расширение файла определяется сервером по типу содержимого: значение,
// присланное клиентом, доверия не заслуживает.
const EXTENSION_BY_MIME = {
  'image/jpeg': '.jpg',
  'image/jpg': '.jpg',
  'image/png': '.png',
  'image/webp': '.webp',
  'application/pdf': '.pdf'
};

// Storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Check if this is a rabbit photo upload from the route
    if (req.originalUrl && req.originalUrl.includes('/rabbits/') && req.originalUrl.includes('/photo')) {
      cb(null, uploadDirs.rabbits);
    } else {
      // hasOwn обязателен: req.body.type — строка от клиента, и обычный доступ
      // по ключу для '__proto__' возвращает объект из прототипа, а не каталог.
      const type = req.body.type;
      const dest = Object.hasOwn(uploadDirs, type) ? uploadDirs[type] : uploadDirs.temp;
      cb(null, dest);
    }
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    // Расширение берём из типа, который прошёл фильтр, а не из имени файла.
    // Каталог uploads отдаётся статикой, поэтому имя вроде photo.svg или
    // photo.html означало бы активное содержимое с адреса нашего API.
    const ext = Object.hasOwn(EXTENSION_BY_MIME, file.mimetype) ? EXTENSION_BY_MIME[file.mimetype] : '.bin';
    cb(null, file.fieldname + '-' + uniqueSuffix + ext);
  }
});

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
