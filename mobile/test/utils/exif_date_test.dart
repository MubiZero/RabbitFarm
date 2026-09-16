import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/exif_date.dart';

/// Галерея кролика показывает «когда снято», и сервер такую дату принимает —
/// а брать её было неоткуда. Формат в EXIF свой, с двоеточиями и в дате.
void main() {
  group('parseExifDate', () {
    test('разбирает формат EXIF', () {
      expect(
        parseExifDate('2026:09:15 10:20:30'),
        DateTime(2026, 9, 15, 10, 20, 30),
      );
    });

    test('мусор и пустое не превращаются в дату', () {
      expect(parseExifDate(null), isNull);
      expect(parseExifDate(''), isNull);
      expect(parseExifDate('не дата'), isNull);
      // Частый случай у камер без настроенных часов: нули вместо даты.
      expect(parseExifDate('0000:00:00 00:00:00'), isNull);
    });

    test('дата из будущего не показывается', () {
      // Сбитые часы камеры дают снимки «из следующего года»; такая подпись
      // в ленте хуже, чем её отсутствие.
      final future = DateTime.now().add(const Duration(days: 400));
      final raw = '${future.year}:01:01 12:00:00';
      expect(parseExifDate(raw), isNull);
    });
  });

  group('exifTakenAt', () {
    test('снимок без EXIF не роняет загрузку', () async {
      // Пересланное через мессенджер приходит без метаданных — это норма,
      // а не ошибка: фотография всё равно должна загрузиться.
      expect(await exifTakenAt(Uint8List.fromList([1, 2, 3, 4])), isNull);
    });
  });
}
