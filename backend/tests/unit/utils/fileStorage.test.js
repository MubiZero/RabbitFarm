/**
 * Unit tests for fileStorage utility
 */
jest.mock('../../../src/config/minio', () => ({
  client: {
    putObject: jest.fn(),
    removeObject: jest.fn(),
    statObject: jest.fn(),
    getObject: jest.fn()
  },
  bucket: 'test-bucket'
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { client, bucket } = require('../../../src/config/minio');
const { buildObjectKey, uploadFile, deleteFile, serveFile } = require('../../../src/utils/fileStorage');

describe('fileStorage', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('buildObjectKey', () => {
    it('builds a key under the given folder with the extension for the mime type', () => {
      const key = buildObjectKey('rabbits', 'photo', 'image/png');
      expect(key).toMatch(/^rabbits\/photo-\d+-\d+\.png$/);
    });

    it('falls back to .bin for an unknown mime type', () => {
      const key = buildObjectKey('rabbits', 'photo', 'application/x-unknown');
      expect(key).toMatch(/^rabbits\/photo-\d+-\d+\.bin$/);
    });
  });

  describe('uploadFile', () => {
    it('uploads the buffer to the bucket and returns a /uploads/ relative URL', async () => {
      client.putObject.mockResolvedValue(undefined);
      const file = { fieldname: 'photo', mimetype: 'image/jpeg', buffer: Buffer.from('x'), size: 1 };

      const url = await uploadFile('rabbits', file);

      expect(client.putObject).toHaveBeenCalledWith(
        bucket,
        expect.stringMatching(/^rabbits\/photo-\d+-\d+\.jpg$/),
        file.buffer,
        file.size,
        { 'Content-Type': 'image/jpeg' }
      );
      expect(url).toMatch(/^\/uploads\/rabbits\/photo-\d+-\d+\.jpg$/);
    });
  });

  describe('deleteFile', () => {
    it('does nothing if relativeUrl is null', async () => {
      await deleteFile(null);
      expect(client.removeObject).not.toHaveBeenCalled();
    });

    it('does nothing if relativeUrl is undefined', async () => {
      await deleteFile(undefined);
      expect(client.removeObject).not.toHaveBeenCalled();
    });

    it('does nothing if relativeUrl is empty string', async () => {
      await deleteFile('');
      expect(client.removeObject).not.toHaveBeenCalled();
    });

    it('removes the object for a /uploads/... URL', async () => {
      client.removeObject.mockResolvedValue(undefined);

      await deleteFile('/uploads/rabbits/test.jpg');

      expect(client.removeObject).toHaveBeenCalledWith(bucket, 'rabbits/test.jpg');
    });

    it('catches and logs errors during file deletion, without throwing', async () => {
      const logger = require('../../../src/utils/logger');
      client.removeObject.mockRejectedValue(new Error('bucket unreachable'));

      await expect(deleteFile('/uploads/rabbits/test.jpg')).resolves.toBeUndefined();
      expect(logger.error).toHaveBeenCalled();
    });
  });

  describe('serveFile', () => {
    it('sets Content-Type from object metadata and pipes the stream to the response', async () => {
      client.statObject.mockResolvedValue({ metaData: { 'content-type': 'image/png' } });
      const stream = { pipe: jest.fn() };
      client.getObject.mockResolvedValue(stream);
      const res = { set: jest.fn() };

      await serveFile('rabbits/test.png', res);

      expect(res.set).toHaveBeenCalledWith('Content-Type', 'image/png');
      expect(res.set).toHaveBeenCalledWith('Cache-Control', expect.stringContaining('immutable'));
      expect(stream.pipe).toHaveBeenCalledWith(res);
    });

    it('falls back to application/octet-stream when metadata has no content-type', async () => {
      client.statObject.mockResolvedValue({ metaData: {} });
      const stream = { pipe: jest.fn() };
      client.getObject.mockResolvedValue(stream);
      const res = { set: jest.fn() };

      await serveFile('rabbits/test.bin', res);

      expect(res.set).toHaveBeenCalledWith('Content-Type', 'application/octet-stream');
    });

    it('propagates a statObject error (object not found) to the caller', async () => {
      client.statObject.mockRejectedValue(new Error('NotFound'));
      const res = { set: jest.fn() };

      await expect(serveFile('rabbits/missing.png', res)).rejects.toThrow('NotFound');
    });
  });
});
