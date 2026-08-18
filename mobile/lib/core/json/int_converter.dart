import 'package:freezed_annotation/freezed_annotation.dart';

/// Разбор целого числа, которое API может отдать числом или строкой
/// (DECIMAL и BIGINT приходят от MySQL строками).
///
/// Функция и конвертер — одна реализация: аннотации в freezed-моделях
/// используют [IntConverter], рукописные `fromJson` — [intFromJson].
int intFromJson(Object? json) {
  if (json is num) return json.toInt();
  if (json is String) return int.parse(json);
  throw ArgumentError('Cannot convert $json to int');
}

/// То же, но пустое значение — это `null`, а не ошибка.
int? nullableIntFromJson(Object? json) {
  if (json == null) return null;
  if (json is num) return json.toInt();
  if (json is String) return json.isEmpty ? null : int.parse(json);
  return null;
}

class IntConverter implements JsonConverter<int, Object> {
  const IntConverter();

  @override
  int fromJson(Object json) => intFromJson(json);

  @override
  Object toJson(int object) => object;
}

class NullableIntConverter implements JsonConverter<int?, Object?> {
  const NullableIntConverter();

  @override
  int? fromJson(Object? json) => nullableIntFromJson(json);

  @override
  Object? toJson(int? object) => object;
}
