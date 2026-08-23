import 'package:freezed_annotation/freezed_annotation.dart';

/// Конвертеры дат.
///
/// В API живут два разных типа. Момент времени (`fed_at`, `measured_at`,
/// `due_date`, `created_at`) сервер отдаёт в UTC — его нужно переводить в
/// местное время, иначе кормление, записанное в 09:00, показывается как 06:00.
/// Календарная дата (`birth_date`, `vaccination_date`, `transaction_date`)
/// часового пояса не имеет вовсе, и сдвигать её нельзя: 1 марта в Москве
/// превратилось бы в 28 февраля.
///
/// Раньше и то и другое разбиралось одним `DateTime.parse` без перевода в
/// местное время, а обратно уходило в виде наивной местной строки — в базе
/// оказывался момент, сдвинутый на часовой пояс пользователя.

DateTime _parseInstant(String value) => DateTime.parse(value).toLocal();

DateTime _parseDate(String value) {
  final parsed = DateTime.parse(value);
  // Дата пришла как момент (например '2026-03-01T00:00:00.000Z') — берём
  // календарные составляющие как есть, без перевода в местный пояс.
  return DateTime(parsed.year, parsed.month, parsed.day);
}

String _formatDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

/// Момент времени: читается в местном поясе, отправляется в UTC.
class DateTimeConverter implements JsonConverter<DateTime, Object> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is String) return _parseInstant(json);
    if (json is DateTime) return json.toLocal();
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

/// Момент времени, которого может не быть.
class NullableDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) return _parseInstant(json);
    if (json is DateTime) return json.toLocal();
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

/// Календарная дата без времени: пояс не применяется ни в одну сторону.
class DateOnlyConverter implements JsonConverter<DateTime, Object> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is String) return _parseDate(json);
    if (json is DateTime) return DateTime(json.year, json.month, json.day);
    throw ArgumentError('Cannot convert $json to date');
  }

  @override
  String toJson(DateTime object) => _formatDate(object);
}

/// Календарная дата, которой может не быть.
class NullableDateOnlyConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateOnlyConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) return _parseDate(json);
    if (json is DateTime) return DateTime(json.year, json.month, json.day);
    throw ArgumentError('Cannot convert $json to date');
  }

  @override
  String? toJson(DateTime? object) =>
      object == null ? null : _formatDate(object);
}
