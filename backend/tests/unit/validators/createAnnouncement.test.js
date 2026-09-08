const { createAnnouncementSchema } = require('../../../src/validators/planValidator');

const validateBody = (body) =>
  createAnnouncementSchema.validate(body, { abortEarly: false, stripUnknown: true });

const baseBody = {
  title: 'Плановые работы',
  body: 'В субботу сервис будет недоступен с 2:00 до 4:00.',
  channels: ['push'],
  target_type: 'all'
};

describe('createAnnouncementSchema — текст и каналы', () => {
  it('принимает объявление всем фермам', () => {
    const { error } = validateBody(baseBody);

    expect(error).toBeUndefined();
  });

  it('отклоняет объявление без заголовка', () => {
    const { error } = validateBody({ ...baseBody, title: undefined });

    expect(error).toBeDefined();
    expect(error.details[0].path).toEqual(['title']);
  });

  it('отклоняет пустой текст', () => {
    const { error } = validateBody({ ...baseBody, body: '' });

    expect(error).toBeDefined();
    expect(error.details[0].path).toEqual(['body']);
  });

  it('отклоняет заголовок длиннее 255 символов', () => {
    const { error } = validateBody({ ...baseBody, title: 'я'.repeat(256) });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('string.max');
  });

  it('отклоняет текст длиннее 4000 символов', () => {
    const { error } = validateBody({ ...baseBody, body: 'я'.repeat(4001) });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('string.max');
  });

  it('принимает оба канала сразу', () => {
    const { error } = validateBody({ ...baseBody, channels: ['push', 'email'] });

    expect(error).toBeUndefined();
  });

  it('отклоняет пустой список каналов — отправлять было бы некуда', () => {
    const { error } = validateBody({ ...baseBody, channels: [] });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('array.min');
  });

  // SMS не поддержан сознательно: шлюз принимает только одобренные шаблоны.
  it('отклоняет канал sms', () => {
    const { error } = validateBody({ ...baseBody, channels: ['sms'] });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('any.only');
  });
});

describe('createAnnouncementSchema — адресат', () => {
  it('отклоняет неизвестный target_type', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'everyone' });

    expect(error).toBeDefined();
    expect(error.details[0].path).toEqual(['target_type']);
  });

  it('требует target_farm_id при target_type=farm', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'farm' });

    expect(error).toBeDefined();
    expect(error.details[0].path).toEqual(['target_farm_id']);
    expect(error.details[0].type).toBe('any.required');
  });

  it('принимает адресное объявление одной ферме', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'farm', target_farm_id: 7 });

    expect(error).toBeUndefined();
  });

  it('запрещает target_farm_id, если адресат не одна ферма', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'all', target_farm_id: 7 });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('any.unknown');
  });

  it('требует target_filter при target_type=filter', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'filter' });

    expect(error).toBeDefined();
    expect(error.details[0].path).toEqual(['target_filter']);
    expect(error.details[0].type).toBe('any.required');
  });

  it.each(['no_plan', 'at_limit', 'suspended', 'expired', 'inactive_days'])(
    'принимает фильтр получателей %s',
    (filter) => {
      const { error } = validateBody({ ...baseBody, target_type: 'filter', target_filter: filter });

      expect(error).toBeUndefined();
    }
  );

  it('отклоняет неизвестный фильтр получателей', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'filter', target_filter: 'rich' });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('any.only');
  });

  it('запрещает target_filter, если адресат не фильтр', () => {
    const { error } = validateBody({ ...baseBody, target_type: 'all', target_filter: 'no_plan' });

    expect(error).toBeDefined();
    expect(error.details[0].type).toBe('any.unknown');
  });
});
