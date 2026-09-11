const JWTUtil = require('../utils/jwt');
const ApiResponse = require('../utils/apiResponse');
const { User, TokenBlacklist, Farm } = require('../models');

/**
 * Authentication middleware
 * Verifies JWT token and attaches user to request
 *
 * @param {Object} options
 * @param {Boolean} options.allowBlockedFarm — пропускать ферму, которой
 *   закрыт доступ (`suspended`, `read_only`, помечена на удаление). Нужно
 *   ровно одному маршруту — обращению в поддержку, см. ниже.
 */
const createAuthenticate = ({ allowBlockedFarm = false } = {}) => async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return ApiResponse.unauthorized(res, 'Токен не передан');
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token
    const decoded = JWTUtil.verifyAccessToken(token);

    // Check if token is blacklisted
    if (decoded.jti) {
      const blacklisted = await TokenBlacklist.findOne({ where: { jti: decoded.jti } });
      if (blacklisted) {
        return ApiResponse.unauthorized(res, 'Токен отозван');
      }
    }

    // Get user from database
    const user = await User.findByPk(decoded.id, {
      include: [{ model: Farm, as: 'farm', attributes: ['id', 'status', 'deleted_at'] }]
    });

    if (!user) {
      return ApiResponse.unauthorized(res, 'Пользователь не найден');
    }

    if (!user.is_active) {
      return ApiResponse.forbidden(res, 'Аккаунт отключён. Обратитесь к владельцу фермы.');
    }

    // Смена пароля отзывает все выданные до неё токены. Без этой проверки
    // access-токен продолжал работать до конца своего срока, и сброс пароля
    // не отбирал доступ у того, кто уже вошёл.
    if ((decoded.tv || 0) !== user.token_version) {
      return ApiResponse.unauthorized(res, 'Токен отозван, войдите заново');
    }

    // Вход под клиентом (см. docs/plans/PLATFORM-ADMIN.md, 3.2): токен
    // выдан не самому пользователю, а платформенным админом для просмотра
    // его фермы. Проверяется раньше статуса фермы и режет мутирующие
    // методы целиком — именно поэтому админ может открыть даже
    // приостановленную ферму (это и есть цель просмотра), а её собственный
    // статус read_only/suspended здесь уже ни на что не влияет.
    if (decoded.read_only) {
      if (!['GET', 'HEAD', 'OPTIONS'].includes(req.method)) {
        return ApiResponse.forbidden(
          res,
          'Режим просмотра под клиентом — только чтение.',
          'IMPERSONATION_READ_ONLY'
        );
      }
      req.user = user;
      req.farmId = user.farm_id;
      req.impersonatedBy = decoded.impersonated_by;
      return next();
    }

    // Статус хозяйства проверяется здесь, а не по контроллерам: это
    // единственная точка, через которую проходит каждый запрос.
    //
    // Платформенный админ не должен потерять доступ к своей же панели из-за
    // статуса собственной фермы — приостановка/read_only это рычаг для чужих
    // хозяйств, не для себя.
    if (user.farm && !user.is_platform_admin && !allowBlockedFarm) {
      // Удаление сильнее любого статуса: пока идут 30 дней до физической
      // зачистки (см. 2.4), данные ещё на месте, но работать с ними нельзя.
      if (user.farm.deleted_at) {
        return ApiResponse.forbidden(res, 'Хозяйство удалено. Обратитесь в поддержку.', 'FARM_DELETED');
      }
      if (user.farm.status === 'suspended') {
        return ApiResponse.forbidden(res, 'Хозяйство приостановлено. Обратитесь в поддержку.', 'FARM_SUSPENDED');
      }
      if (user.farm.status === 'read_only' && !['GET', 'HEAD', 'OPTIONS'].includes(req.method)) {
        return ApiResponse.forbidden(
          res,
          'Хозяйство доступно только для чтения — обратитесь в поддержку, чтобы возобновить полный доступ.',
          'FARM_READ_ONLY'
        );
      }
    }

    // Attach user to request
    req.user = user;
    // Ферма запроса. Раньше её вычисляли выражением `owner_id || id`:
    // формула жила в коде, и любая её копия мимо этого места давала другой
    // ответ. Теперь хозяйство записано у пользователя, и читать нечего.
    req.farmId = user.farm_id;
    next();
  } catch (error) {
    if (error.message.includes('token')) {
      return ApiResponse.unauthorized(res, error.message);
    }
    next(error);
  }
};

const authenticate = createAuthenticate();

/**
 * То же самое, но статус хозяйства не закрывает дорогу.
 *
 * Единственный потребитель — POST /support-requests. Все три отказа выше
 * («приостановлено», «только чтение», «удалено») советуют обратиться в
 * поддержку; под обычным `authenticate` форма обращения упиралась бы ровно
 * в тот отказ, из-за которого её и открыли. Проверка входа под клиентом
 * (`read_only` в токене) остаётся в силе: обращение пишет ферма, а не
 * заглянувший к ней админ.
 */
const authenticateEvenIfFarmBlocked = createAuthenticate({ allowBlockedFarm: true });

/**
 * Authorization middleware
 * Checks if user has required role
 * @param {Array<String>} allowedRoles - Array of allowed roles
 */
const authorize = (allowedRoles = []) => {
  return (req, res, next) => {
    if (!req.user) {
      return ApiResponse.unauthorized(res, 'Требуется авторизация');
    }

    // Owner has access to everything
    if (req.user.role === 'owner') {
      return next();
    }

    // Check if user's role is in allowed roles
    if (!allowedRoles.includes(req.user.role)) {
      return ApiResponse.forbidden(res, 'Недостаточно прав');
    }

    next();
  };
};

/**
 * Платформенный админ — не роль фермы, отдельный флаг на пользователе
 * (`users.is_platform_admin`). Проверяется поверх `authenticate`, отдельно
 * от `authorize`, у которого речь только про роль внутри одной фермы.
 */
const requirePlatformAdmin = (req, res, next) => {
  if (!req.user) {
    return ApiResponse.unauthorized(res, 'Требуется авторизация');
  }

  if (!req.user.is_platform_admin) {
    return ApiResponse.forbidden(res, 'Доступно только платформенному администратору');
  }

  next();
};

/**
 * Optional authentication
 * Attaches user if token is valid, but doesn't require it
 */
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const decoded = JWTUtil.verifyAccessToken(token);
      const user = await User.findByPk(decoded.id, {
      });

      if (user && user.is_active) {
        req.user = user;
      }
    }
  } catch (error) {
    // Ignore errors for optional auth
  }

  next();
};

module.exports = {
  authenticate,
  authenticateEvenIfFarmBlocked,
  authorize,
  requirePlatformAdmin,
  optionalAuth
};
