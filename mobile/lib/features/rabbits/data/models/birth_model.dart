import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'rabbit_model.dart';
import 'breeding_model.dart';
import '../../../../core/json/int_converter.dart';

part 'birth_model.freezed.dart';

/// Модель окрола
///
/// Содержит информацию о рождении крольчат, включая количество,
/// выживаемость и связь с случкой
@freezed
abstract class BirthModel with _$BirthModel {
  // Нужен, чтобы у модели могли быть свои геттеры (см. kitsAlive).
  const BirthModel._();

  const factory BirthModel({
    required int id,
    @JsonKey(name: 'breeding_id') int? breedingId,
    @JsonKey(name: 'mother_id') required int motherId,
    @JsonKey(name: 'birth_date') required String birthDate,
    @JsonKey(name: 'kits_born_alive') required int kitsBornAlive,
    @JsonKey(name: 'kits_born_dead') required int kitsBornDead,

    /// Пало до отсадки. Крольчонок в приложении — число внутри окрола,
    /// а не своя карточка, поэтому и падёж молодняка считается выводком.
    @JsonKey(name: 'kits_died') @Default(0) int kitsDied,
    @JsonKey(name: 'kits_weaned') int? kitsWeaned,
    @JsonKey(name: 'weaning_date') String? weaningDate,

    /// Когда по этому выводку завели карточки крольчат.
    ///
    /// Пока пусто — крольчата живут числами выше, и падёж с отсадкой
    /// отмечают прямо в выводке. Как только заведены, счёт идёт по
    /// карточкам: числа замораживаются, а отмечать надо на карточке
    /// крольчонка. Сервер такую правку выводка отклоняет — две правды об
    /// одних и тех же животных расходились молча.
    @JsonKey(name: 'kits_carded_at') String? kitsCardedAt,
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
        id: intFromJson(json['id']),
        breedingId: json['breeding_id'] != null
            ? intFromJson(json['breeding_id'])
            : null,
        motherId: intFromJson(json['mother_id']),
        birthDate: json['birth_date']?.toString() ?? '',
        kitsBornAlive: intFromJson(json['kits_born_alive'] ?? 0),
        kitsBornDead: intFromJson(json['kits_born_dead'] ?? 0),
        kitsDied: intFromJson(json['kits_died'] ?? 0),
        kitsWeaned: json['kits_weaned'] != null
            ? intFromJson(json['kits_weaned'])
            : null,
        weaningDate: json['weaning_date']?.toString(),
        kitsCardedAt: json['kits_carded_at']?.toString(),
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
      debugPrint('Error parsing BirthModel from JSON: $e');
      debugPrint('JSON data: $json');
      rethrow;
    }
  }

  /// Проверяет, что вложенный объект кролика содержит полный набор
  /// обязательных полей для корректного парсинга `RabbitModel`.
  /// Заведены ли по этому выводку карточки крольчат.
  bool get kitsCarded => kitsCardedAt != null && kitsCardedAt!.isNotEmpty;

  /// Сколько крольчат живо сейчас.
  ///
  /// Отсаженные считаются по факту отсадки, до неё — по разнице: владелец
  /// смотрит в список, чтобы узнать, сколько осталось, а не чтобы вычитать
  /// в уме.
  int get kitsAlive =>
      kitsWeaned ?? (kitsBornAlive - kitsDied).clamp(0, kitsBornAlive);

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
