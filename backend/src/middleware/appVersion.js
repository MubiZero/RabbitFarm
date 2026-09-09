const semver = require('semver');

const logger = require('../utils/logger');
const ApiResponse = require('../utils/apiResponse');

/**
 * Проверка минимальной поддерживаемой версии мобильного приложения.
 *
 * Сервер выкатывается по нескольку раз в день, а обновление из App Store и
 * Google Play доезжает до части пользователей днями. Когда старая сборка
 * перестаёт понимать ответы API, она ломается непредсказуемо — лучше один
 * честный экран «обновитесь», чем случайные ошибки на каждом втором экране.
 *
 * Это не многоверсионная маршрутизация: живёт одна версия API, а здесь только
 * нижняя граница клиента.
 */

const APP_VERSION_HEADER = 'X-App-Version';
const DEFAULT_MIN_APP_VERSION = '1.0.0';

// Про неверный MIN_APP_VERSION говорим один раз, а не на каждый запрос.
let invalidMinVersionReported = false;

/**
 * Минимальная версия из окружения. Значение, которое не разбирается как
 * семвер, отключает проверку: опечатка в переменной не должна запирать вход
 * всем пользователям сразу.
 */
function getMinSupportedVersion() {
  const raw = process.env.MIN_APP_VERSION || DEFAULT_MIN_APP_VERSION;
  const parsed = semver.valid(semver.coerce(raw));

  if (!parsed) {
    if (!invalidMinVersionReported) {
      logger.warn('MIN_APP_VERSION не разбирается как версия — проверка версии приложения отключена', { value: raw });
      invalidMinVersionReported = true;
    }
    return null;
  }

  return parsed;
}

/**
 * Пропускает запрос, если клиент не назвал свою версию или она не ниже
 * минимальной. Иначе отвечает 426 Upgrade Required с кодом UPGRADE_REQUIRED.
 */
const checkAppVersion = (req, res, next) => {
  const rawVersion = req.get(APP_VERSION_HEADER);

  // Заголовка нет — это веб-клиент или сборка, выпущенная до появления
  // проверки. Такие запросы пропускаем: иначе выкладка заперла бы вход всем,
  // кто ещё не обновился, вместо того чтобы отсечь заведомо несовместимые.
  if (!rawVersion) {
    return next();
  }

  // Версия приложения приходит в виде «1.2.3» или «1.2.3+45» (номер сборки);
  // coerce отбрасывает метаданные сборки и терпит лишние пробелы.
  const clientVersion = semver.valid(semver.coerce(rawVersion));

  if (!clientVersion) {
    logger.warn('Не удалось разобрать версию клиента', { value: rawVersion, path: req.path });
    return next();
  }

  const minVersion = getMinSupportedVersion();

  if (!minVersion || !semver.lt(clientVersion, minVersion)) {
    return next();
  }

  logger.info('Запрос от устаревшей версии приложения', {
    clientVersion,
    minVersion,
    path: req.path
  });

  return ApiResponse.error(
    res,
    `Эта версия приложения больше не поддерживается. Обновитесь до ${minVersion} или новее.`,
    426,
    'UPGRADE_REQUIRED'
  );
};

module.exports = {
  checkAppVersion,
  APP_VERSION_HEADER,
  DEFAULT_MIN_APP_VERSION
};
