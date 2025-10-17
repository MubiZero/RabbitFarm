import 'package:freezed_annotation/freezed_annotation.dart';

/// Универсальный конвертер для DateTime, приходящих как строка или DateTime объект
class DateTimeConverter implements JsonConverter<DateTime, Object> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is String) return DateTime.parse(json);
    if (json is DateTime) return json;
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

/// Конвертер для nullable DateTime
class NullableDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) return DateTime.parse(json);
    if (json is DateTime) return json;
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}
