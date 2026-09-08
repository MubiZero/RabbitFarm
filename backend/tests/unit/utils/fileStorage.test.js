/**
 * Unit tests for fileStorage utility
 */
jest.mock('../../../src/config/minio', () => ({
  client: {
    putObject: jest.fn(),
    removeObject: jest.fn(),
    statObject: jest.fn(),
    getObject: jest.fn(),
    listObjectsV2: jest.fn(),
    removeObjects: jest.fn()
  },
  bucket: 'test-bucket'
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { client, bucket } = require('../../../src/config/minio');
const {
  buildObjectKey, uploadFile, deleteFile, deleteByPrefix, serveFile
} = require('../../../src/utils/fileStorage');

/** Мини-эмуляция потока MinIO: data* → end, либо error. */
const mockObjectStream = (objects, error = null) => ({
  on(event, handler) {
    if (error) {
      if (event === 'error') setImmediate(() => handler(error));
      return this;
    }
    if (event === 'data') objects.forEach((obj) => setImmediate(() => handler(obj)));
    if (event === 'end') setImmediate(() => handler());
    return this;
  }
});

describe('fileStorage', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('buildObjectKey', () => {
    it('builds a key under the given farm and folder with the extension for the mime type', () => {
      const key = buildObjectKey(42, 'rabbits', 'photo', 'image/png');
      expect(key).toMatch(/^farm-42\/rabbits\/photo-\d+-\d+\.png$/);
    });

    it('falls back to .bin for an unknown mime type', () => {
      const key = buildObjectKey(42, 'rabbits', 'photo', 'application/x-unknown');
      expect(key).toMatch(/^farm-42\/rabbits\/photo-\d+-\d+\.bin$/);
    });

    it('keeps different farms in different prefixes', () => {
      const keyA = buildObjectKey(1, 'rabbits', 'photo', 'image/jpeg');
      const keyB = buildObjectKey(2, 'rabbits', 'photo', 'image/jpeg');
      expect(keyA).toMatch(/^farm-1\//);
      expect(keyB).toMatch(/^farm-2\//);
    });
  });

  describe('uploadFile', () => {
    it('uploads the buffer to the bucket and returns a /uploads/ relative URL prefixed with the farm', async () => {
      client.putObject.mockResolvedValue(undefined);
      const file = { fieldname: 'photo', mimetype: 'image/jpeg', buffer: Buffer.from('x'), size: 1 };

      const url = await uploadFile(42, 'rabbits', file);

      expect(client.putObject).toHaveBeenCalledWith(
        bucket,
        expect.stringMatching(/^farm-42\/rabbits\/photo-\d+-\d+\.jpg$/),
        file.buffer,
        file.size,
        { 'Content-Type': 'image/jpeg' }
      );
      expect(url).toMatch(/^\/uploads\/farm-42\/rabbits\/photo-\d+-\d+\.jpg$/);
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

  describe('deleteByPrefix', () => {
    it('removes every object under the farm prefix in one call', async () => {
      client.listObjectsV2.mockReturnValue(mockObjectStream([
        { name: 'farm-42/rabbits/photo-1.jpg' },
        { name: 'farm-42/gallery/photo-2.jpg' }
      ]));
      client.removeObjects.mockResolvedValue(undefined);

      await deleteByPrefix('farm-42/');

      expect(client.listObjectsV2).toHaveBeenCalledWith(bucket, 'farm-42/', true);
      expect(client.removeObjects).toHaveBeenCalledWith(bucket, [
        'farm-42/rabbits/photo-1.jpg',
        'farm-42/gallery/photo-2.jpg'
      ]);
    });

    it('does not call removeObjects when the prefix is empty', async () => {
      client.listObjectsV2.mockReturnValue(mockObjectStream([]));

      await deleteByPrefix('farm-42/');

      expect(client.removeObjects).not.toHaveBeenCalled();
    });

    it('catches and logs a listing error, without throwing — deleting a farm must not stall', async () => {
      const logger = require('../../../src/utils/logger');
      client.listObjectsV2.mockReturnValue(mockObjectStream([], new Error('bucket unreachable')));

      await expect(deleteByPrefix('farm-42/')).resolves.toBeUndefined();
      expect(logger.error).toHaveBeenCalled();
      expect(client.removeObjects).not.toHaveBeenCalled();
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
