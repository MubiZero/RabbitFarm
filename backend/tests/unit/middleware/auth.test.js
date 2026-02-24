/**
 * Unit tests for auth middleware
 */
jest.mock('../../../src/utils/jwt', () => ({
  verifyAccessToken: jest.fn()
}));

jest.mock('../../../src/models', () => ({
  User: { findByPk: jest.fn() },
  TokenBlacklist: { findOne: jest.fn() }
}));

const JWTUtil = require('../../../src/utils/jwt');
const { User, TokenBlacklist } = require('../../../src/models');
const { authenticate, authorize, optionalAuth } = require('../../../src/middleware/auth');

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('authenticate middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  it('should call next() for valid token with active user', async () => {
    const decoded = { id: 1, jti: 'test-jti' };
    const user = { id: 1, is_active: true };

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
    const user = { id: 1, is_active: false };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer valid-token' } };
    const res = mockRes();

    await authenticate(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(403);
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

  it('should skip blacklist check when jti is not present', async () => {
    const decoded = { id: 1 }; // no jti
    const user = { id: 1, is_active: true };
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

describe('optionalAuth middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  it('should attach user if valid token provided', async () => {
    const decoded = { id: 1 };
    const user = { id: 1, is_active: true };
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
    const user = { id: 1, is_active: false };
    JWTUtil.verifyAccessToken.mockReturnValue(decoded);
    User.findByPk.mockResolvedValue(user);

    const req = { headers: { authorization: 'Bearer token' } };
    const res = mockRes();

    await optionalAuth(req, res, mockNext);

    expect(req.user).toBeUndefined();
    expect(mockNext).toHaveBeenCalled();
  });
});
