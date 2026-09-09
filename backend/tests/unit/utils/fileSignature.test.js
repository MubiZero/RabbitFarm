const { detectMimeType, DETECTABLE_MIME_TYPES } = require('../../../src/utils/fileSignature');
const {
  PNG_1PX,
  JPEG_1PX,
  WEBP_1PX,
  PDF_MINIMAL,
  WINDOWS_EXECUTABLE,
  SVG_WITH_SCRIPT
} = require('../../helpers/fileFixtures');

describe('detectMimeType', () => {
  it('узнаёт PNG', () => {
    expect(detectMimeType(PNG_1PX)).toBe('image/png');
  });

  it('узнаёт JPEG', () => {
    expect(detectMimeType(JPEG_1PX)).toBe('image/jpeg');
  });

  it('узнаёт WebP (тип лежит за полем размера RIFF)', () => {
    expect(detectMimeType(WEBP_1PX)).toBe('image/webp');
  });

  it('узнаёт PDF', () => {
    expect(detectMimeType(PDF_MINIMAL)).toBe('application/pdf');
  });

  it('не узнаёт исполняемый файл', () => {
    expect(detectMimeType(WINDOWS_EXECUTABLE)).toBeNull();
  });

  it('не узнаёт SVG — у текстового формата сигнатуры нет', () => {
    expect(detectMimeType(SVG_WITH_SCRIPT)).toBeNull();
  });

  it('RIFF без метки WEBP — не WebP', () => {
    const riffWave = Buffer.concat([
      Buffer.from('RIFF', 'latin1'),
      Buffer.alloc(4),
      Buffer.from('WAVEfmt ', 'latin1')
    ]);
    expect(detectMimeType(riffWave)).toBeNull();
  });

  it('обрезанная сигнатура не проходит', () => {
    expect(detectMimeType(PNG_1PX.subarray(0, 4))).toBeNull();
    expect(detectMimeType(WEBP_1PX.subarray(0, 6))).toBeNull();
  });

  it('пустой буфер и не-буфер дают null', () => {
    expect(detectMimeType(Buffer.alloc(0))).toBeNull();
    expect(detectMimeType(null)).toBeNull();
    expect(detectMimeType(undefined)).toBeNull();
    expect(detectMimeType('iVBORw0KGgo=')).toBeNull();
  });

  it('список распознаваемых типов покрывает всё, что разрешает .env.example', () => {
    expect(DETECTABLE_MIME_TYPES).toEqual(
      expect.arrayContaining(['image/jpeg', 'image/png', 'image/webp', 'application/pdf'])
    );
  });
});
