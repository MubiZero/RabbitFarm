/**
 * Unit tests for the one-off photo size backfill script.
 */
jest.mock('dotenv', () => ({ config: jest.fn() }));
jest.mock('../../../src/models', () => ({
  Photo: { findAll: jest.fn() },
  Rabbit: { findAll: jest.fn() },
  sequelize: { close: jest.fn() }
}));
jest.mock('../../../src/config/minio', () => ({
  client: { statObject: jest.fn() },
  bucket: 'test-bucket'
}));

const { Photo, Rabbit, sequelize } = require('../../../src/models');
const { client, bucket } = require('../../../src/config/minio');
const { run, backfill, objectKeyFromUrl } = require('../../../scripts/backfillPhotoSizes');

describe('backfillPhotoSizes', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('objectKeyFromUrl', () => {
    it('strips the /uploads/ prefix', () => {
      expect(objectKeyFromUrl('/uploads/rabbits/photo.jpg')).toBe('rabbits/photo.jpg');
    });
  });

  describe('backfill', () => {
    it('writes stat.size onto matching records', async () => {
      const record = { url: '/uploads/rabbits/photo.jpg', update: jest.fn().mockResolvedValue(true) };
      client.statObject.mockResolvedValue({ size: 2048 });

      const result = await backfill([record], 'url', 'size_bytes');

      expect(client.statObject).toHaveBeenCalledWith(bucket, 'rabbits/photo.jpg');
      expect(record.update).toHaveBeenCalledWith({ size_bytes: 2048 });
      expect(result).toEqual({ updated: 1, missing: 0 });
    });

    it('skips a record whose object is missing in MinIO, without throwing', async () => {
      const record = { url: '/uploads/rabbits/gone.jpg', update: jest.fn() };
      client.statObject.mockRejectedValue(new Error('NotFound'));

      const result = await backfill([record], 'url', 'size_bytes');

      expect(record.update).not.toHaveBeenCalled();
      expect(result).toEqual({ updated: 0, missing: 1 });
    });

    it('keeps processing the rest of the batch after one failure', async () => {
      const ok = { url: '/uploads/rabbits/a.jpg', update: jest.fn().mockResolvedValue(true) };
      const missing = { url: '/uploads/rabbits/b.jpg', update: jest.fn() };
      client.statObject
        .mockRejectedValueOnce(new Error('NotFound'))
        .mockResolvedValueOnce({ size: 512 });

      const result = await backfill([missing, ok], 'url', 'size_bytes');

      expect(ok.update).toHaveBeenCalledWith({ size_bytes: 512 });
      expect(result).toEqual({ updated: 1, missing: 1 });
    });
  });

  describe('run', () => {
    it('backfills photos and rabbits missing their size field, then closes the connection', async () => {
      const photo = { url: '/uploads/rabbits/p.jpg', update: jest.fn().mockResolvedValue(true) };
      const rabbit = { photo_url: '/uploads/rabbits/r.jpg', update: jest.fn().mockResolvedValue(true) };
      Photo.findAll.mockResolvedValue([photo]);
      Rabbit.findAll.mockResolvedValue([rabbit]);
      client.statObject.mockResolvedValue({ size: 100 });

      await run();

      expect(Photo.findAll).toHaveBeenCalledWith({ where: { size_bytes: null } });
      expect(Rabbit.findAll).toHaveBeenCalledWith(expect.objectContaining({
        where: expect.objectContaining({ photo_size_bytes: null })
      }));
      expect(photo.update).toHaveBeenCalledWith({ size_bytes: 100 });
      expect(rabbit.update).toHaveBeenCalledWith({ photo_size_bytes: 100 });
      expect(sequelize.close).toHaveBeenCalled();
    });

    it('is idempotent: records already carrying a size are excluded by the query, not re-fetched', async () => {
      Photo.findAll.mockResolvedValue([]);
      Rabbit.findAll.mockResolvedValue([]);

      await run();

      expect(client.statObject).not.toHaveBeenCalled();
      expect(sequelize.close).toHaveBeenCalled();
    });
  });
});
