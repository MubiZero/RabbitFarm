import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/json/date_time_converter.dart';

void main() {
  group('Момент времени', () {
    // Регрессия: сервер отдаёт время в UTC, а toLocal() в проекте не
    // встречался ни разу — кормление, записанное в 09:00 по Москве,
    // показывалось как 06:00.
    test('читается в местном поясе', () {
      final parsed =
          const DateTimeConverter().fromJson('2026-03-15T06:00:00.000Z');

      expect(parsed.isUtc, isFalse);
      expect(parsed, DateTime.utc(2026, 3, 15, 6).toLocal());
    });

    test('отправляется в UTC, а не наивной местной строкой', () {
      final local = DateTime.utc(2026, 3, 15, 6).toLocal();

      final json = const DateTimeConverter().toJson(local);

      expect(json, endsWith('Z'));
      expect(DateTime.parse(json), DateTime.utc(2026, 3, 15, 6));
    });

    test('туда и обратно даёт тот же момент', () {
      const converter = DateTimeConverter();
      final original = DateTime.utc(2026, 7, 1, 21, 30).toLocal();

      final restored = converter.fromJson(converter.toJson(original));

      expect(restored.isAtSameMomentAs(original), isTrue);
    });

    test('null остаётся null', () {
      expect(const NullableDateTimeConverter().fromJson(null), isNull);
      expect(const NullableDateTimeConverter().toJson(null), isNull);
    });
  });

  group('Календарная дата', () {
    // Дату рождения сдвигать нельзя: в поясе восточнее UTC перевод в UTC
    // отбрасывал бы её на день назад.
    test('не сдвигается часовым поясом', () {
      final parsed = const DateOnlyConverter().fromJson('2026-03-01');

      expect(parsed.year, 2026);
      expect(parsed.month, 3);
      expect(parsed.day, 1);
    });

    test('дата, пришедшая моментом в UTC, читается по календарю', () {
      final parsed =
          const DateOnlyConverter().fromJson('2026-03-01T00:00:00.000Z');

      expect(parsed.day, 1);
      expect(parsed.month, 3);
    });

    test('отправляется без времени', () {
      final json = const DateOnlyConverter().toJson(DateTime(2026, 3, 1));

      expect(json, '2026-03-01');
    });

    test('однозначная дата дополняется нулями', () {
      expect(const DateOnlyConverter().toJson(DateTime(2026, 1, 5)),
          '2026-01-05');
    });
  });
}
