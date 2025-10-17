import 'package:freezed_annotation/freezed_annotation.dart';

part 'pedigree_model.freezed.dart';

/// Модель родословной кролика
///
/// Рекурсивная структура, представляющая дерево предков до N поколений.
/// Каждый узел может иметь отца (father) и мать (mother).
@freezed
class PedigreeModel with _$PedigreeModel {
  const factory PedigreeModel({
    required int id,
    required String name,
    String? tagId,
    required String sex,
    String? birthDate,
    String? breed,
    PedigreeModel? father,
    PedigreeModel? mother,
  }) = _PedigreeModel;

  /// Кастомная десериализация с явной обработкой null значений
  factory PedigreeModel.fromJson(Map<String, dynamic> json) {
    return PedigreeModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? 'Без имени',
      tagId: json['tag_id']?.toString(),
      sex: json['sex']?.toString() ?? 'unknown',
      birthDate: json['birth_date']?.toString(),
      breed: json['breed']?.toString(),
      father: json['father'] != null
          ? PedigreeModel.fromJson(json['father'] as Map<String, dynamic>)
          : null,
      mother: json['mother'] != null
          ? PedigreeModel.fromJson(json['mother'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Вспомогательная функция для парсинга ID
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    if (value is double) return value.toInt();
    throw FormatException('Cannot parse int from $value');
  }
}
