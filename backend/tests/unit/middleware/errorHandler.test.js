/**
 * Unit tests for errorHandler middleware
 */
jest.mock('../../../src/utils/logger', () => ({
  error: jest.fn(), info: jest.fn(), warn: jest.fn()
}));

const { errorHandler, notFoundHandler } = require('../../../src/middleware/errorHandler');

const mockReq = (overrides = {}) => ({
  path: '/test',
  method: 'GET',
  ip: '127.0.0.1',
  user: null,
  originalUrl: '/api/v1/test',
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('errorHandler middleware', () => {
  beforeEach(() => jest.clearAllMocks());

  it('should handle SequelizeValidationError with field details', () => {
    const err = {
      name: 'SequelizeValidationError',
      message: 'Validation error',
      stack: '',
      errors: [
        { path: 'email', message: 'Email is invalid' },
        { path: 'name', message: 'Name is required' }
      ]
    };
    const req = mockReq({ user: { id: 1 } });
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(422);
    expect(res.json).toHaveBeenCalled();
  });

  it('should handle SequelizeUniqueConstraintError', () => {
    const err = {
      name: 'SequelizeUniqueConstraintError',
      message: 'Unique constraint error',
      stack: '',
      errors: [{ path: 'email' }]
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(400);
  });

  it('should handle SequelizeForeignKeyConstraintError', () => {
    const err = {
      name: 'SequelizeForeignKeyConstraintError',
      message: 'Foreign key error',
      stack: ''
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(400);
  });

  it('should handle JsonWebTokenError', () => {
    const err = {
      name: 'JsonWebTokenError',
      message: 'jwt malformed',
      stack: ''
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should handle TokenExpiredError', () => {
    const err = {
      name: 'TokenExpiredError',
      message: 'jwt expired',
      stack: ''
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(401);
  });

  it('should handle MulterError with LIMIT_FILE_SIZE code', () => {
    const err = {
      name: 'MulterError',
      code: 'LIMIT_FILE_SIZE',
      message: 'File too large',
      stack: ''
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(400);
  });

  it('should handle MulterError with other codes', () => {
    const err = {
      name: 'MulterError',
      code: 'LIMIT_UNEXPECTED_FILE',
      message: 'Unexpected field',
      stack: ''
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(400);
  });

  it('should handle custom error with statusCode', () => {
    const err = {
      name: 'CustomError',
      message: 'Resource not found',
      statusCode: 404,
      code: 'NOT_FOUND',
      stack: ''
    };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(404);
  });

  it('should handle generic error as 500 server error', () => {
    const originalEnv = process.env.NODE_ENV;
    process.env.NODE_ENV = 'production';

    const err = { name: 'Error', message: 'Something went wrong', stack: '' };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(500);

    process.env.NODE_ENV = originalEnv;
  });

  it('should include error message in development mode', () => {
    const originalEnv = process.env.NODE_ENV;
    process.env.NODE_ENV = 'development';

    const err = { name: 'Error', message: 'Detailed error message', stack: '' };
    const req = mockReq();
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(500);
    const jsonArg = res.json.mock.calls[0][0];
    expect(JSON.stringify(jsonArg)).toContain('Detailed error message');

    process.env.NODE_ENV = originalEnv;
  });

  it('should handle request with user attached', () => {
    const err = { name: 'Error', message: 'Error', stack: '' };
    const req = mockReq({ user: { id: 42 } });
    const res = mockRes();

    errorHandler(err, req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(500);
  });
});

describe('notFoundHandler middleware', () => {
  it('should respond with 404 and route info', () => {
    const req = mockReq({ originalUrl: '/api/v1/nonexistent' });
    const res = mockRes();

    notFoundHandler(req, res, mockNext);

    expect(res.status).toHaveBeenCalledWith(404);
    const jsonArg = res.json.mock.calls[0][0];
    expect(JSON.stringify(jsonArg)).toContain('/api/v1/nonexistent');
  });
});
