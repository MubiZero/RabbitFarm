jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    Cage: {
      findOne: jest.fn(),
      findByPk: jest.fn(),
      create: jest.fn(),
      findAll: jest.fn(),
      findAndCountAll: jest.fn()
    },
    Rabbit: { findOne: jest.fn(), findByPk: jest.fn() },
    sequelize: mockSequelize
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const { Cage, Rabbit } = require('../../../src/models');
const cageService = require('../../../src/services/cageService');

const createMockCage = (overrides = {}) => ({
  id: 1,
  number: 'A-01',
  type: 'single',
  condition: 'good',
  capacity: 2,
  location: 'Building A',
  notes: null,
  user_id: 1,
  last_cleaned_at: null,
  rabbits: [],
  toJSON: function () { return { ...this }; },
  update: jest.fn().mockResolvedValue(true),
  destroy: jest.fn().mockResolvedValue(true),
  ...overrides
});

describe('CageService', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── createCage ───────────────────────────────────────────────────────────

  describe('createCage', () => {
    it('should create a cage successfully', async () => {
      const mockCage = createMockCage();
      Cage.create.mockResolvedValue(mockCage);

      const result = await cageService.createCage({ number: 'A-01', type: 'single', capacity: 2, user_id: 1 });

      expect(Cage.create).toHaveBeenCalled();
      expect(result).toBe(mockCage);
    });

    it('should propagate errors from Cage.create', async () => {
      Cage.create.mockRejectedValue(new Error('DB_ERROR'));

      await expect(cageService.createCage({ number: 'A-01', user_id: 1 })).rejects.toThrow('DB_ERROR');
    });
  });

  // ─── getCageById ──────────────────────────────────────────────────────────

  describe('getCageById', () => {
    it('should return cage with occupancy data when found', async () => {
      const mockCage = createMockCage({ rabbits: [{ id: 1 }] });
      Cage.findOne.mockResolvedValue(mockCage);

      const result = await cageService.getCageById(1, 1);

      expect(result.current_occupancy).toBe(1);
      expect(result.is_full).toBe(false);   // capacity=2, 1 rabbit
      expect(result.is_available).toBe(true);
    });

    it('should return is_full=true when cage is at capacity', async () => {
      const mockCage = createMockCage({ capacity: 2, rabbits: [{ id: 1 }, { id: 2 }] });
      Cage.findOne.mockResolvedValue(mockCage);

      const result = await cageService.getCageById(1, 1);

      expect(result.is_full).toBe(true);
      expect(result.is_available).toBe(false);
    });

    it('should return is_available=false when cage condition is not good', async () => {
      const mockCage = createMockCage({ condition: 'needs_repair', rabbits: [] });
      Cage.findOne.mockResolvedValue(mockCage);

      const result = await cageService.getCageById(1, 1);

      expect(result.is_available).toBe(false);
    });

    it('should throw CAGE_NOT_FOUND when cage does not exist', async () => {
      Cage.findOne.mockResolvedValue(null);

      await expect(cageService.getCageById(999, 1)).rejects.toThrow('CAGE_NOT_FOUND');
    });
  });

  // ─── listCages ────────────────────────────────────────────────────────────

  describe('listCages', () => {
    it('should return list of cages with occupancy data', async () => {
      const mockCages = [
        createMockCage({ rabbits: [] }),
        createMockCage({ id: 2, number: 'B-01', rabbits: [{ id: 1 }] })
      ];
      Cage.findAndCountAll.mockResolvedValue({ count: 2, rows: mockCages });

      const result = await cageService.listCages(1);

      expect(result.items).toHaveLength(2);
      expect(result.total).toBe(2);
      expect(result.items[0].current_occupancy).toBe(0);
      expect(result.items[1].current_occupancy).toBe(1);
    });

    it('should filter by only_available', async () => {
      const available = createMockCage({ rabbits: [], condition: 'good', capacity: 2 });
      const unavailable = createMockCage({ id: 2, rabbits: [{ id: 1 }, { id: 2 }], capacity: 2, condition: 'good' });
      Cage.findAndCountAll.mockResolvedValue({ count: 2, rows: [available, unavailable] });

      const result = await cageService.listCages(1, { only_available: 'true' });

      expect(result.items.every(c => c.is_available)).toBe(true);
    });

    it('should pass condition=good in SQL WHERE when only_available is true', async () => {
      Cage.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await cageService.listCages(1, { only_available: 'true' });

      const callArg = Cage.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.condition).toBe('good');
    });

    it('should paginate correctly when only_available is true', async () => {
      // 3 cages with condition=good, but only 2 are actually available (not full)
      const cages = [
        createMockCage({ id: 1, rabbits: [], condition: 'good', capacity: 2 }),
        createMockCage({ id: 2, rabbits: [{ id: 1 }, { id: 2 }], condition: 'good', capacity: 2 }), // full
        createMockCage({ id: 3, rabbits: [], condition: 'good', capacity: 3 })
      ];
      Cage.findAndCountAll.mockResolvedValue({ count: 3, rows: cages });

      // Request page 1 with limit 1
      const result = await cageService.listCages(1, { only_available: 'true' }, { page: 1, limit: 1 });

      // Total should be 2 (only available cages), not 3
      expect(result.total).toBe(2);
      // Should return only 1 item (limit=1)
      expect(result.items).toHaveLength(1);
      expect(result.items[0].id).toBe(1);

      // Page 2 should return the second available cage
      Cage.findAndCountAll.mockResolvedValue({ count: 3, rows: cages });
      const page2 = await cageService.listCages(1, { only_available: 'true' }, { page: 2, limit: 1 });

      expect(page2.total).toBe(2);
      expect(page2.items).toHaveLength(1);
      expect(page2.items[0].id).toBe(3);
    });

    it('should apply type and condition filters in where clause', async () => {
      Cage.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await cageService.listCages(1, { type: 'group', condition: 'good' });

      const callArg = Cage.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.type).toBe('group');
      expect(callArg.where.condition).toBe('good');
    });

    it('should apply search filter using Op.or symbol key', async () => {
      Cage.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await cageService.listCages(1, { search: 'A-01' });

      const callArg = Cage.findAndCountAll.mock.calls[0][0];
      // sequelize Op.or is a Symbol, so Object.keys won't find it - use getOwnPropertySymbols
      const symbolKeys = Object.getOwnPropertySymbols(callArg.where);
      expect(symbolKeys.length).toBeGreaterThan(0);
    });
  });

  // ─── updateCage ───────────────────────────────────────────────────────────

  describe('updateCage', () => {
    it('should update cage successfully', async () => {
      const mockCage = createMockCage();
      Cage.findOne.mockResolvedValue(mockCage);

      const result = await cageService.updateCage(1, 1, { condition: 'needs_repair' });

      expect(mockCage.update).toHaveBeenCalledWith({ condition: 'needs_repair' });
      expect(result).toBe(mockCage);
    });

    it('should throw CAGE_NOT_FOUND when cage does not exist', async () => {
      Cage.findOne.mockResolvedValue(null);

      await expect(cageService.updateCage(999, 1, {})).rejects.toThrow('CAGE_NOT_FOUND');
    });
  });

  // ─── deleteCage ───────────────────────────────────────────────────────────

  describe('deleteCage', () => {
    it('should delete cage successfully when no rabbits inside', async () => {
      const mockCage = createMockCage({ rabbits: [] });
      Cage.findOne.mockResolvedValue(mockCage);

      const result = await cageService.deleteCage(1, 1);

      expect(mockCage.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('should throw CAGE_NOT_FOUND when cage does not exist', async () => {
      Cage.findOne.mockResolvedValue(null);

      await expect(cageService.deleteCage(999, 1)).rejects.toThrow('CAGE_NOT_FOUND');
    });

    it('should throw CAGE_HAS_RABBITS when cage has rabbits', async () => {
      const mockCage = createMockCage({ rabbits: [{ id: 1 }, { id: 2 }] });
      Cage.findOne.mockResolvedValue(mockCage);

      await expect(cageService.deleteCage(1, 1)).rejects.toThrow('CAGE_HAS_RABBITS');
      expect(mockCage.destroy).not.toHaveBeenCalled();
    });
  });

  // ─── getStatistics ────────────────────────────────────────────────────────

  describe('getStatistics', () => {
    it('should return accurate statistics for multiple cages', async () => {
      const cages = [
        createMockCage({ type: 'single', condition: 'good', capacity: 2, rabbits: [] }),
        createMockCage({ id: 2, type: 'group', condition: 'needs_repair', capacity: 5, rabbits: [{ id: 1 }, { id: 2 }] }),
        createMockCage({ id: 3, type: 'maternity', condition: 'good', capacity: 3, rabbits: [{ id: 3 }, { id: 4 }, { id: 5 }] })
      ];
      Cage.findAll.mockResolvedValue(cages);

      const result = await cageService.getStatistics(1);

      expect(result.total_cages).toBe(3);
      expect(result.by_type.single).toBe(1);
      expect(result.by_type.group).toBe(1);
      expect(result.by_type.maternity).toBe(1);
      expect(result.by_condition.good).toBe(2);
      expect(result.by_condition.needs_repair).toBe(1);
      expect(result.occupancy.total_capacity).toBe(10);
      expect(result.occupancy.current_occupancy).toBe(5);
      expect(result.occupancy.available_spaces).toBe(5);
      expect(result.occupancy.occupancy_rate).toBe(50);
      expect(result.occupancy.full_cages).toBe(1);   // maternity is full (3/3)
      expect(result.occupancy.empty_cages).toBe(1);  // single is empty
    });

    it('should return zero occupancy_rate when there are no cages', async () => {
      Cage.findAll.mockResolvedValue([]);

      const result = await cageService.getStatistics(1);

      expect(result.total_cages).toBe(0);
      expect(result.occupancy.occupancy_rate).toBe(0);
    });
  });

  // ─── markCleaned ─────────────────────────────────────────────────────────

  describe('markCleaned', () => {
    it('should update last_cleaned_at timestamp', async () => {
      const mockCage = createMockCage();
      Cage.findOne.mockResolvedValue(mockCage);

      const result = await cageService.markCleaned(1, 1);

      expect(mockCage.update).toHaveBeenCalledWith({ last_cleaned_at: expect.any(Date) });
      expect(result).toBe(mockCage);
    });

    it('should throw CAGE_NOT_FOUND when cage does not exist', async () => {
      Cage.findOne.mockResolvedValue(null);

      await expect(cageService.markCleaned(999, 1)).rejects.toThrow('CAGE_NOT_FOUND');
    });
  });

  // ─── getLayout ────────────────────────────────────────────────────────────

  describe('getLayout', () => {
    it('should group cages by location', async () => {
      const cages = [
        createMockCage({ location: 'Building A', rabbits: [] }),
        createMockCage({ id: 2, location: 'Building A', rabbits: [] }),
        createMockCage({ id: 3, location: 'Building B', rabbits: [] })
      ];
      Cage.findAll.mockResolvedValue(cages);

      const result = await cageService.getLayout(1);

      expect(Object.keys(result)).toContain('Building A');
      expect(Object.keys(result)).toContain('Building B');
      expect(result['Building A']).toHaveLength(2);
      expect(result['Building B']).toHaveLength(1);
    });

    it('should use "Без локации" as fallback when location is null', async () => {
      const cages = [
        createMockCage({ location: null, rabbits: [] })
      ];
      Cage.findAll.mockResolvedValue(cages);

      const result = await cageService.getLayout(1);

      expect(Object.keys(result)).toContain('Без локации');
    });

    it('should return empty layout when user has no cages', async () => {
      Cage.findAll.mockResolvedValue([]);

      const result = await cageService.getLayout(1);

      expect(result).toEqual({});
    });
  });
});
