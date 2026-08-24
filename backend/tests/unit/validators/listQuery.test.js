const { listTasksQuerySchema } = require('../../../src/validators/taskValidator');

const validateQuery = (query) =>
  listTasksQuerySchema.validate(query, { abortEarly: false, stripUnknown: true });

describe('list query date range', () => {
  it('should accept to_date without from_date', () => {
    const { error, value } = validateQuery({ to_date: '2026-08-01' });

    expect(error).toBeUndefined();
    expect(value.from_date).toBeUndefined();
    expect(value.to_date).toBeInstanceOf(Date);
  });

  it('should accept from_date without to_date', () => {
    const { error, value } = validateQuery({ from_date: '2026-08-01' });

    expect(error).toBeUndefined();
    expect(value.from_date).toBeInstanceOf(Date);
  });

  it('should accept a range where to_date is after from_date', () => {
    const { error } = validateQuery({ from_date: '2026-08-01', to_date: '2026-08-10' });

    expect(error).toBeUndefined();
  });

  it('should accept a range where both dates are equal', () => {
    const { error } = validateQuery({ from_date: '2026-08-01', to_date: '2026-08-01' });

    expect(error).toBeUndefined();
  });

  it('should reject to_date earlier than from_date', () => {
    const { error } = validateQuery({ from_date: '2026-08-10', to_date: '2026-08-01' });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('date.min');
  });

  it('should reject a malformed to_date', () => {
    const { error } = validateQuery({ to_date: 'не дата' });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('date.base');
  });
});

describe('list query boolean flags', () => {
  // Сервис получает именно результат Joi, поэтому тип флага здесь важен:
  // на строке 'true' сравнение в taskService не срабатывало.
  it('should coerce overdue_only and today_only to real booleans', () => {
    const { error, value } = validateQuery({ overdue_only: 'true', today_only: 'true' });

    expect(error).toBeUndefined();
    expect(value.overdue_only).toBe(true);
    expect(value.today_only).toBe(true);
  });

  it('should coerce the string false to boolean false', () => {
    const { value } = validateQuery({ overdue_only: 'false' });

    expect(value.overdue_only).toBe(false);
  });
});
