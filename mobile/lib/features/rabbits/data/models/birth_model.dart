import 'package:freezed_annotation/freezed_annotation.dart';
import 'rabbit_model.dart';
import 'breeding_model.dart';

part 'birth_model.freezed.dart';

/// Модель окрола
///
/// Содержит информацию о рождении крольчат, включая количество,
/// выживаемость и связь с случкой
@freezed
class BirthModel with _$BirthModel {
  const factory BirthModel({
    required int id,
    @JsonKey(name: 'breeding_id') int? breedingId,
    @JsonKey(name: 'mother_id') required int motherId,
    @JsonKey(name: 'birth_date') required String birthDate,
    @JsonKey(name: 'kits_born_alive') required int kitsBornAlive,
    @JsonKey(name: 'kits_born_dead') required int kitsBornDead,
    @JsonKey(name: 'kits_weaned') int? kitsWeaned,
    @JsonKey(name: 'weaning_date') String? weaningDate,
    String? complications,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    // Связанные объекты (если включены в ответ)
    RabbitModel? mother,
    BreedingModel? breeding,
    // Список рожденных крольчат (если созданы в системе)
    List<RabbitModel>? kits,
  }) = _BirthModel;

  factory BirthModel.fromJson(Map<String, dynamic> json) {
    try {
      return BirthModel(
        id: _parseInt(json['id']),
        breedingId: json['breeding_id'] != null ? _parseInt(json['breeding_id']) : null,
        motherId: _parseInt(json['mother_id']),
        birthDate: json['birth_date']?.toString() ?? '',
        kitsBornAlive: _parseInt(json['kits_born_alive'] ?? 0),
        kitsBornDead: _parseInt(json['kits_born_dead'] ?? 0),
        kitsWeaned: json['kits_weaned'] != null ? _parseInt(json['kits_weaned']) : null,
        weaningDate: json['weaning_date']?.toString(),
        complications: json['complications']?.toString(),
        notes: json['notes']?.toString(),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
        mother: (json['mother'] is Map<String, dynamic> &&
                _hasFullRabbitPayload(json['mother'] as Map<String, dynamic>))
            ? RabbitModel.fromJson(json['mother'] as Map<String, dynamic>)
            : null,
        breeding: json['breeding'] != null && json['breeding'] is Map
            ? BreedingModel.fromJson(json['breeding'] as Map<String, dynamic>)
            : null,
        kits: (json['kits'] is List)
            ? (json['kits'] as List)
                .whereType<Map<String, dynamic>>()
                .where(_hasFullRabbitPayload)
                .map((kit) => RabbitModel.fromJson(kit))
                .toList()
            : null,
      );
    } catch (e) {
      print('Error parsing BirthModel from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    if (value is double) return value.toInt();
    throw FormatException('Cannot parse int from $value');
  }

  /// Проверяет, что вложенный объект кролика содержит полный набор
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
