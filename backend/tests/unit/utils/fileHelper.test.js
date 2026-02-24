/**
 * Unit tests for fileHelper utility
 */
jest.mock('fs');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const fs = require('fs');
const { deleteFile } = require('../../../src/utils/fileHelper');

describe('fileHelper', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('deleteFile', () => {
    it('should do nothing if relativeUrl is null', () => {
      deleteFile(null);
      expect(fs.existsSync).not.toHaveBeenCalled();
    });

    it('should do nothing if relativeUrl is undefined', () => {
      deleteFile(undefined);
      expect(fs.existsSync).not.toHaveBeenCalled();
    });

    it('should do nothing if relativeUrl is empty string', () => {
      deleteFile('');
      expect(fs.existsSync).not.toHaveBeenCalled();
    });

    it('should delete file if it exists', () => {
      fs.existsSync.mockReturnValue(true);
      fs.unlinkSync.mockReturnValue(undefined);

      deleteFile('/uploads/rabbits/test.jpg');

      expect(fs.existsSync).toHaveBeenCalled();
      expect(fs.unlinkSync).toHaveBeenCalled();
    });

    it('should not call unlinkSync if file does not exist', () => {
      fs.existsSync.mockReturnValue(false);

      deleteFile('/uploads/rabbits/missing.jpg');

      expect(fs.existsSync).toHaveBeenCalled();
      expect(fs.unlinkSync).not.toHaveBeenCalled();
    });

    it('should catch and log errors during file deletion', () => {
      const logger = require('../../../src/utils/logger');
      fs.existsSync.mockReturnValue(true);
      fs.unlinkSync.mockImplementation(() => { throw new Error('Permission denied'); });

      expect(() => deleteFile('/uploads/test.jpg')).not.toThrow();
      expect(logger.error).toHaveBeenCalled();
    });
  });
});
