import 'package:freezed_annotation/freezed_annotation.dart';

/// Универсальный конвертер для целых чисел, приходящих как number или string
class IntConverter implements JsonConverter<int, Object> {
  const IntConverter();

  @override
  int fromJson(Object json) {
    if (json is num) return json.toInt();
    if (json is String) return int.parse(json);
    throw ArgumentError('Cannot convert $json to int');
  }

  @override
  Object toJson(int object) => object;
}