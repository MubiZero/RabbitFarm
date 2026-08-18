import 'package:freezed_annotation/freezed_annotation.dart';

/// Разбор дробного числа, которое API может отдать числом или строкой:
/// суммы и веса приходят из MySQL DECIMAL как «1234.50».
double doubleFromJson(Object? json) {
  if (json is num) return json.toDouble();
  if (json is String) return double.parse(json);
  throw ArgumentError('Cannot convert $json to double');
}

class DoubleConverter implements JsonConverter<double, Object> {
  const DoubleConverter();

  @override
  double fromJson(Object json) => doubleFromJson(json);

  @override
  Object toJson(double object) => object;
}
