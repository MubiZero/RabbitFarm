/**
 * Unit tests for auth middleware
 */
jest.mock('../../../src/utils/jwt', () => ({
  verifyAccessToken: jest.fn()
}));

jest.mock('../../../src/models', () => ({
  User: { findByPk: jest.fn() },
  TokenBlacklist: { findOne: jest.fn() },
  // Farm нужен только как модель для include — запросов к нему middleware
  // не делает, ферма приезжает вместе с пользователем.
  Farm: {}
}));

const JWTUtil = require('../../../src/utils/jwt');
const { User, TokenBlacklist } = require('../../../src/models');
const { authenticate, authorize, requirePlatformAdmin, optionalAuth } = require('../../../src/middleware/auth');

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('authenticate middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  // Смена пароля увеличивает поколение токенов, и все выданные раньше
  // перестают приниматься — иначе сброс пароля не отбирал уже выданный доступ.
  it('отклоняет токен прошлого поколения', async () => {
    JWTUtil.verifyAccessToken.mockReturnValue({ id: 1, jti: null, tv: 0 });
    User.findByPk.mockResolvedValue({ id: 1, is_active: true, token_version: 1 });

    const req = { headers: { authorization: 'Bearer stale-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(mockNext).not.toHaveBeenCalled();
  });

  it('принимает токен текущего поколения', async () => {
    JWTUtil.verifyAccessToken.mockReturnValue({ id: 1, jti: null, tv: 2 });
    User.findByPk.mockResolvedValue({ id: 1, is_active: true, token_version: 2 });

    const req = { headers: { authorization: 'Bearer fresh-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(mockNext).toHaveBeenCalledWith();
  });

  it('should call next() for valid token with active user', async () => {
    const decoded = { id: 1, jti: 'test-jti' };
    const user = { id: 1, is_active: true, token_version: 0 };

    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    TokenBlacklist.findOne.mockResolvedValue(null);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer valid-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(req.user).toEqual(user);
    expect(mockNext).toHaveBeenCalledWith();
  });

  it('should return 401 if no authorization header', async () => {
    const req = { headers: {} };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should return 401 if authorization does not start with Bearer', async () => {
    const req = { headers: { authorization: 'Basic sometoken' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should return 401 if token is blacklisted', async () => {
    const decoded = { id: 1, jti: 'blacklisted-jti' };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    TokenBlacklist.findOne.mockResolvedValue({ jti: 'blacklisted-jti' });

    const req = { headers: { authorization: 'Bearer blacklisted-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should return 401 if user not found', async () => {
    const decoded = { id: 999, jti: null };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(null);

    const req = { headers: { authorization: 'Bearer valid-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should return 403 if user is inactive', async () => {
    const decoded = { id: 1, jti: null };
    const user = { id: 1, is_active: false, token_version: 0 };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer valid-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(403);
    expect(res.json.mock.calls[0][0].error.message).toBe('Аккаунт отключён. Обратитесь к владельцу фермы.');
  });

  it('should return 401 when token error contains "token"', async () => {
    JWTUtil.verifyAccessToken.mockImplementation(() => {
      throw new Error('invalid token signature');
    });

    const req = { headers: { authorization: 'Bearer bad-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should call next(error) for non-token errors', async () => {
    JWTUtil.verifyAccessToken.mockImplementation(() => {
      throw new Error('database connection failed');
    });

    const req = { headers: { authorization: 'Bearer some-token' } };
    const res = mockRes();
    const next = jest.fn();

    await authenticate(req, res, next);

    expect(next).toHaveBeenCalledWith(expect.any(Error));
  });

  // Статус хозяйства (см. docs/plans/PLATFORM-ADMIN.md, 2.2) проверяется
  // здесь — единственная точка, через которую проходит каждый запрос.
  describe('гейт по статусу фермы', () => {
    const authenticateWith = async ({ farm, isPlatformAdmin = false, method = 'GET' }) => {
      JWTUtil.verifyAccessToken.mockReturnValue({ id: 1, jti: null, tv: 0 });
      User.findByPk.mockResolvedValue({
        id: 1,
        is_active: true,
        token_version: 0,
        farm_id: farm ? farm.id : null,
        is_platform_admin: isPlatformAdmin,
        farm
      });

      const req = { headers: { authorization: 'Bearer valid-token' }, method };
      const res = mockRes();
      await authenticate(req, res, mockNext);
      return { req, res };
    };

    it('приостановленное хозяйство не пускает вовсе — 403 FARM_SUSPENDED', async () => {
      const { res } = await authenticateWith({ farm: { id: 5, status: 'suspended' } });

      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json.mock.calls[0][0].error.code).toBe('FARM_SUSPENDED');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('приостановленное хозяйство не пускает и на чтение', async () => {
      const { res } = await authenticateWith({ farm: { id: 5, status: 'suspended' }, method: 'GET' });

      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json.mock.calls[0][0].error.code).toBe('FARM_SUSPENDED');
    });

    it('режим чтения пропускает GET', async () => {
      const { res } = await authenticateWith({ farm: { id: 5, status: 'read_only' }, method: 'GET' });

      expect(res.status).not.toHaveBeenCalled();
      expect(mockNext).toHaveBeenCalledWith();
    });

    it.each(['POST', 'PATCH', 'PUT', 'DELETE'])(
      'режим чтения отклоняет %s с кодом FARM_READ_ONLY',
      async (method) => {
        const { res } = await authenticateWith({ farm: { id: 5, status: 'read_only' }, method });

        expect(res.status).toHaveBeenCalledWith(403);
        expect(res.json.mock.calls[0][0].error.code).toBe('FARM_READ_ONLY');
        expect(mockNext).not.toHaveBeenCalled();
      }
    );

    it('пропускает платформенного админа несмотря на статус его собственной фермы', async () => {
      const { res } = await authenticateWith({
        farm: { id: 5, status: 'suspended' },
        isPlatformAdmin: true,
        method: 'POST'
      });

      expect(res.status).not.toHaveBeenCalled();
      expect(mockNext).toHaveBeenCalledWith();
    });

    it('активное хозяйство пропускает как раньше', async () => {
      const { req, res } = await authenticateWith({ farm: { id: 5, status: 'active' }, method: 'POST' });

      expect(res.status).not.toHaveBeenCalled();
      expect(req.farmId).toBe(5);
      expect(mockNext).toHaveBeenCalledWith();
    });

    // Мягко удалённая ферма (см. 2.4): доступ закрывается сразу, не дожидаясь
    // физической зачистки через 30 дней.
    it('удалённое хозяйство не пускает вовсе — 403 FARM_DELETED', async () => {
      const { res } = await authenticateWith({
        farm: { id: 5, status: 'active', deleted_at: '2026-09-09T00:00:00.000Z' }
      });

      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json.mock.calls[0][0].error.code).toBe('FARM_DELETED');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('удаление сильнее статуса — FARM_DELETED, а не FARM_READ_ONLY', async () => {
      const { res } = await authenticateWith({
        farm: { id: 5, status: 'read_only', deleted_at: '2026-09-09T00:00:00.000Z' },
        method: 'GET'
      });

      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json.mock.calls[0][0].error.code).toBe('FARM_DELETED');
    });

    it('пропускает платформенного админа несмотря на удаление его собственной фермы', async () => {
      const { res } = await authenticateWith({
        farm: { id: 5, status: 'active', deleted_at: '2026-09-09T00:00:00.000Z' },
        isPlatformAdmin: true,
        method: 'POST'
      });

      expect(res.status).not.toHaveBeenCalled();
      expect(mockNext).toHaveBeenCalledWith();
    });

    it('пользователь без фермы проходит — гейту нечего проверять', async () => {
      const { res } = await authenticateWith({ farm: null, method: 'POST' });

      expect(res.status).not.toHaveBeenCalled();
      expect(mockNext).toHaveBeenCalledWith();
    });
  });

  // Вход под клиентом (см. docs/plans/PLATFORM-ADMIN.md, 3.2): токен несёт
  // read_only, а фермой запроса становится ферма владельца, на которого
  // выписан токен, — тот же farm_id, что был бы при его собственном логине.
  describe('read_only токен входа под клиентом', () => {
    const authenticateAsImpersonation = async ({ method = 'GET' } = {}) => {
      JWTUtil.verifyAccessToken.mockReturnValue({
        id: 42, jti: null, tv: 3, read_only: true, impersonated_by: 7
      });
      User.findByPk.mockResolvedValue({
        id: 42,
        is_active: true,
        token_version: 3,
        farm_id: 5,
        is_platform_admin: false,
        farm: { id: 5, status: 'suspended', deleted_at: null }
      });

      const req = { headers: { authorization: 'Bearer impersonation-token' }, method };
      const res = mockRes();
      await authenticate(req, res, mockNext);
      return { req, res };
    };

    it('пропускает GET даже для приостановленной фермы — в этом весь смысл просмотра', async () => {
      const { req, res } = await authenticateAsImpersonation({ method: 'GET' });

      expect(res.status).not.toHaveBeenCalled();
      expect(req.farmId).toBe(5);
      expect(req.impersonatedBy).toBe(7);
      expect(mockNext).toHaveBeenCalledWith();
    });

    it.each(['POST', 'PATCH', 'PUT', 'DELETE'])(
      'отклоняет %s с кодом IMPERSONATION_READ_ONLY',
      async (method) => {
        const { res } = await authenticateAsImpersonation({ method });

        expect(res.status).toHaveBeenCalledWith(403);
        expect(res.json.mock.calls[0][0].error.code).toBe('IMPERSONATION_READ_ONLY');
        expect(mockNext).not.toHaveBeenCalled();
      }
    );
  });

  it('should skip blacklist check when jti is not present', async () => {
    const decoded = { id: 1 }; // no jti
    const user = { id: 1, is_active: true, token_version: 0 };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer valid-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(TokenBlacklist.findOne).not.toHaveBeenCalled();
    expect(mockNext).toHaveBeenCalled();
  });
});

describe('authorize middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  it('should return 401 if no user attached', () => {
    const middleware = authorize(['admin']);
    const req = { user: null };
    const res = mockRes();

    middleware(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should call next() for owner role regardless of allowedRoles', () => {
    const middleware = authorize(['admin']);
    const req = { user: { role: 'owner' } };
    const res = mockRes();

    middleware(req, res, mockNext);

    expect(mockNext).toHaveBeenCalledWith();
  });

  it('should call next() if user role is in allowedRoles', () => {
    const middleware = authorize(['admin', 'worker']);
    const req = { user: { role: 'admin' } };
    const res = mockRes();

    middleware(req, res, mockNext);

    expect(mockNext).toHaveBeenCalledWith();
  });

  it('should return 403 if user role is not in allowedRoles', () => {
    const middleware = authorize(['admin']);
    const req = { user: { role: 'guest' } };
    const res = mockRes();

    middleware(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(403);
  });
});

describe('requirePlatformAdmin middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  it('should return 401 if no user attached', () => {
    const req = { user: null };
    const res = mockRes();

    requirePlatformAdmin(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(mockNext).not.toHaveBeenCalled();
  });

  it('should return 403 for a regular farm user (owner included — это не роль фермы)', () => {
    const req = { user: { role: 'owner', is_platform_admin: false } };
    const res = mockRes();

    requirePlatformAdmin(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(403);
    expect(mockNext).not.toHaveBeenCalled();
  });

  it('should call next() for a platform admin', () => {
    const req = { user: { role: 'worker', is_platform_admin: true } };
    const res = mockRes();

    requirePlatformAdmin(req, res, mockNext);

    expect(mockNext).toHaveBeenCalledWith();
  });
});

describe('optionalAuth middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  it('should attach user if valid token provided', async () => {
    const decoded = { id: 1 };
    const user = { id: 1, is_active: true, token_version: 0 };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer valid-token' } };
    const res = mockRes();

    await optionalAuth(req, res, mockNext);

    expect(req.user).toEqual(user);
    expect(mockNext).toHaveBeenCalled();
  });

  it('should call next() without user if no authorization header', async () => {
    const req = { headers: {} };
    const res = mockRes();

    await optionalAuth(req, res, mockNext);

    expect(req.user).toBeUndefined();
    expect(mockNext).toHaveBeenCalled();
  });

  it('should call next() without user if token is invalid', async () => {
    JWTUtil.verifyAccessToken.mockImplementation(() => { throw new Error('invalid'); });

    const req = { headers: { authorization: 'Bearer bad-token' } };
    const res = mockRes();

    await optionalAuth(req, res, mockNext);

    expect(req.user).toBeUndefined();
    expect(mockNext).toHaveBeenCalled();
  });

  it('should not attach user if user is inactive', async () => {
    const decoded = { id: 1 };
    const user = { id: 1, is_active: false, token_version: 0 };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer token' } };
    const res = mockRes();

    await optionalAuth(req, res, mockNext);

    expect(req.user).toBeUndefined();
    expect(mockNext).toHaveBeenCalled();
  });
});
