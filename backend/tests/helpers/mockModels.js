const createMockUser = (overrides = {}) => ({
  id: 1,
  email: 'test@example.com',
  password_hash: '$2b$10$hashedpassword',
  full_name: 'Test User',
  role: 'owner',
  is_active: true,
  last_login_at: null,
  toJSON: function() { return { ...this }; },
  update: jest.fn().mockResolvedValue(true),
  ...overrides
});

const createMockRabbit = (overrides = {}) => ({
  id: 1,
  name: 'Буся',
  user_id: 1,
  breed_id: 1,
  sex: 'female',
  birth_date: '2024-01-01',
  status: 'healthy',
  cage_id: null,
  tag_id: 'TAG001',
  toJSON: function() { return { ...this }; },
  update: jest.fn().mockResolvedValue(true),
  destroy: jest.fn().mockResolvedValue(true),
  ...overrides
});

module.exports = { createMockUser, createMockRabbit };
