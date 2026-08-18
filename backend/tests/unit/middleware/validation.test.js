const Joi = require('joi');
const validate = require('../../../src/middleware/validation');

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};

const run = (schema, body) => {
  const req = { body };
  const res = mockRes();
  const next = jest.fn();
  validate(schema)(req, res, next);
  return { req, res, next, details: res.json.mock.calls[0]?.[0]?.error?.details };
};

describe('validate middleware', () => {
  it('пропускает валидные данные и подставляет очищенное значение', () => {
    const schema = Joi.object({ name: Joi.string().required() });
    const { req, next, res } = run(schema, { name: 'Белка', lishnee: 1 });

    expect(next).toHaveBeenCalled();
    expect(res.status).not.toHaveBeenCalled();
    expect(req.body).toEqual({ name: 'Белка' });
  });

  it('отвечает 422 и собирает все ошибки, а не только первую', () => {
    const schema = Joi.object({
      name: Joi.string().required(),
      age: Joi.number().required()
    });
    const { res, details, next } = run(schema, {});

    expect(res.status).toHaveBeenCalledWith(422);
    expect(next).not.toHaveBeenCalled();
    expect(details).toHaveLength(2);
  });

  it('сообщает по-русски даже без .messages() в схеме', () => {
    const schema = Joi.object({
      email: Joi.string().email().required(),
      count: Joi.number().integer().min(1),
      born_at: Joi.date()
    });
    const { details } = run(schema, { email: 'не-почта', count: 0.5, born_at: 'вчера' });
    const messages = details.map(d => d.message);

    expect(messages).toContain('email должно быть корректным email');
    expect(messages).toContain('count должно быть целым числом');
    expect(messages).toContain('born_at должно быть датой');
    // Ни одна формулировка не должна остаться английской.
    messages.forEach(m => expect(m).not.toMatch(/must be|is required|is not allowed/));
  });

  it('обязательное поле называется по-русски', () => {
    const schema = Joi.object({ tag_id: Joi.string().required() });
    const { details } = run(schema, {});

    expect(details[0].message).toBe('tag_id — обязательное поле');
  });

  it('не перебивает собственное сообщение схемы', () => {
    const schema = Joi.object({
      name: Joi.string().max(3).messages({ 'string.max': 'Слишком длинное имя' })
    });
    const { details } = run(schema, { name: 'Длинное' });

    expect(details[0].message).toBe('Слишком длинное имя');
  });
});
