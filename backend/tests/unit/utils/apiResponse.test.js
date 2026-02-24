const ApiResponse = require('../../../src/utils/apiResponse');

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

describe('ApiResponse', () => {
  describe('noContent', () => {
    it('should return 204 with send()', () => {
      const res = mockRes();
      ApiResponse.noContent(res);
      expect(res.status).toHaveBeenCalledWith(204);
      expect(res.send).toHaveBeenCalled();
    });
  });

  describe('error — with details', () => {
    it('should include details in error response when provided', () => {
      const res = mockRes();
      ApiResponse.error(res, 'Validation failed', 422, 'VALIDATION_ERROR', [{ field: 'email' }]);
      const body = res.json.mock.calls[0][0];
      expect(body.error.details).toEqual([{ field: 'email' }]);
    });
  });
});
