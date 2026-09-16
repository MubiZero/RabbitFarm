import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';

/// Дата съёмки из самого снимка.
///
/// Галерея кролика показывает «когда снято», и сервер такую дату принимает,
/// но взять её было неоткуда: `image_picker` отдаёт только файл. Дата
/// изменения файла тут не годится — снимок, скопированный на телефон,
/// получает сегодняшнюю, и вся лента съезжает.
///
/// Формат в EXIF свой: `2026:09:15 10:20:30` — с двоеточиями и в дате тоже.
DateTime? parseExifDate(String? raw) {
  if (raw == null) return null;

  final match = RegExp(r'^(\d{4}):(\d{2}):(\d{2})[ T](\d{2}):(\d{2}):(\d{2})')
      .firstMatch(raw.trim());
  if (match == null) return null;

  final parts = [for (var i = 1; i <= 6; i++) int.parse(match.group(i)!)];

  // Камера с несброшенными часами пишет нули — формально это разбирается в
  // первый год нашей эры и выглядит в ленте как настоящая дата.
  if (parts[0] < 1900 || parts[1] < 1 || parts[1] > 12 || parts[2] < 1) {
    return null;
  }

  final taken =
      DateTime(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);

  // Дата из будущего — те же сбитые часы: показать её хуже, чем не показать
  // ничего.
  return taken.isAfter(DateTime.now()) ? null : taken;
}

/// Прочитать дату съёмки из байтов снимка. `null`, если её там нет —
/// у скриншотов, пересланных картинок и всего, что прошло через мессенджер,
/// EXIF обычно вырезан.
Future<DateTime?> exifTakenAt(Uint8List bytes) async {
  try {
    final tags = await readExifFromBytes(bytes);
    final raw = tags['EXIF DateTimeOriginal'] ?? tags['Image DateTime'];
    return parseExifDate(raw?.printable);
  } catch (e) {
    // Битый или необычный EXIF не должен мешать загрузить фотографию.
    debugPrint('EXIF: не удалось прочитать дату съёмки: $e');
    return null;
  }
}
