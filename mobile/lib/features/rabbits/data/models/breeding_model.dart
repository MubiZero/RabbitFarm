import 'package:freezed_annotation/freezed_annotation.dart';
import 'rabbit_model.dart';

part 'breeding_model.freezed.dart';

/// Модель случки
///
/// Содержит информацию о планируемой или завершенной случке,
/// включая родителей, даты и статус беременности
@freezed
class BreedingModel with _$BreedingModel {
  const factory BreedingModel({
    required int id,
    @JsonKey(name: 'male_id') required int maleId,
    @JsonKey(name: 'female_id') required int femaleId,
    @JsonKey(name: 'breeding_date') required String breedingDate,
    required String status, // planned, completed, failed, cancelled
    @JsonKey(name: 'palpation_date') String? palpationDate,
    @JsonKey(name: 'is_pregnant') bool? isPregnant,
    @JsonKey(name: 'expected_birth_date') String? expectedBirthDate,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    // Связанные объекты (если включены в ответ)
    RabbitModel? male,
    RabbitModel? female,
    // Информация об инбридинге
    @JsonKey(name: 'inbreeding_coefficient') double? inbreedingCoefficient,
    @JsonKey(name: 'common_ancestors') List<String>? commonAncestors,
  }) = _BreedingModel;

  factory BreedingModel.fromJson(Map<String, dynamic> json) {
    return BreedingModel(
      id: _parseInt(json['id']),
      maleId: _parseInt(json['male_id']),
      femaleId: _parseInt(json['female_id']),
      breedingDate: json['breeding_date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'planned',
      palpationDate: json['palpation_date']?.toString(),
      isPregnant: json['is_pregnant'] as bool?,
      expectedBirthDate: json['expected_birth_date']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      male: (json['male'] is Map<String, dynamic> &&
              _hasFullRabbitPayload(json['male'] as Map<String, dynamic>))
          ? RabbitModel.fromJson(json['male'] as Map<String, dynamic>)
          : null,
      female: (json['female'] is Map<String, dynamic> &&
                _hasFullRabbitPayload(json['female'] as Map<String, dynamic>))
          ? RabbitModel.fromJson(json['female'] as Map<String, dynamic>)
          : null,
      inbreedingCoefficient: json['inbreeding_coefficient'] != null
          ? (json['inbreeding_coefficient'] as num).toDouble()
          : null,
      commonAncestors: json['common_ancestors'] != null
          ? List<String>.from(json['common_ancestors'] as List)
          : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    if (value is double) return value.toInt();
    throw FormatException('Cannot parse int from $value');
  }

  /// Проверяет что вложенный объект кролика содержит полный набор
  /// обязательных полей для корректного парсинга `RabbitModel`.
  static bool _hasFullRabbitPayload(Map<String, dynamic> m) {
    const requiredKeys = [
      'id',
      'tag_id',
      'name',
      'breed_id',
      'sex',
      'birth_date',
      'status',
      'purpose',
      'created_at',
      'updated_at',
    ];
    for (final k in requiredKeys) {
      if (!m.containsKey(k) || m[k] == null) return false;
    }
    return true;
  }
}

/// Статус случки
enum BreedingStatus {
  planned('planned', 'Запланирована'),
  completed('completed', 'Завершена'),
  failed('failed', 'Неудачная'),
  cancelled('cancelled', 'Отменена');

  final String value;
  final String label;
  const BreedingStatus(this.value, this.label);

  static BreedingStatus fromValue(String value) {
    return BreedingStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BreedingStatus.planned,
    );
  }
}
