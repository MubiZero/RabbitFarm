import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/double_converter.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/models/user_ref.dart';

part 'platform_admin_models.freezed.dart';
part 'platform_admin_models.g.dart';

/// Тариф сервиса: сколько кроликов и людей он разрешает ферме.
///
/// Тариф — сущность всего сервиса, а не отдельной фермы: список у всех ферм
/// один и тот же, и правит его только платформенный админ.
///
/// Пустой лимит означает «без ограничения», а не «ноль». Это важно на двух
/// уровнях сразу: у фермы может не быть тарифа вовсе, а у тарифа — предела по
/// какому-то из ресурсов.
@freezed
class Plan with _$Plan {
  const factory Plan({
    @IntConverter() required int id,
    required String name,
    @JsonKey(name: 'max_rabbits') @NullableIntConverter() int? maxRabbits,
    @JsonKey(name: 'max_staff') @NullableIntConverter() int? maxStaff,
    @DoubleConverter() double? price,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _Plan;

  const Plan._();

  /// Тариф вообще ничего не ограничивает — ни поголовье, ни состав.
  bool get isUnlimited => maxRabbits == null && maxStaff == null;

  /// Заготовка для формы правки — с теми же значениями, что у тарифа сейчас.
  PlanDraft get draft => PlanDraft(
        name: name,
        maxRabbits: maxRabbits,
        maxStaff: maxStaff,
        price: price,
        isActive: isActive,
        isDefault: isDefault,
      );

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}

/// Что админ задаёт тарифу в форме.
///
/// Пустой лимит уходит на сервер именно как `null`, а не пропускается:
/// «снять ограничение» — такое же изменение, как «поставить 200», а
/// умолчание о поле сервер понял бы как «оставь как было».
@freezed
class PlanDraft with _$PlanDraft {
  const factory PlanDraft({
    required String name,
    @JsonKey(name: 'max_rabbits') int? maxRabbits,
    @JsonKey(name: 'max_staff') int? maxStaff,
    double? price,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _PlanDraft;

  factory PlanDraft.fromJson(Map<String, dynamic> json) =>
      _$PlanDraftFromJson(json);
}

/// Ферма с точки зрения платформы: чья она, на каком тарифе и сколько уже
/// израсходовала.
///
/// Фактическое потребление приходит вместе с фермой, а не запрашивается по
/// одной — иначе список из тридцати ферм означал бы шестьдесят запросов.
@freezed
class PlatformFarm with _$PlatformFarm {
  const factory PlatformFarm({
    @IntConverter() required int id,
    required String name,
    UserRef? owner,
    Plan? plan,
    @JsonKey(name: 'rabbits_count') @IntConverter() @Default(0) int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() @Default(0) int staffCount,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
  }) = _PlatformFarm;

  const PlatformFarm._();

  /// Доля израсходованного поголовья, 0..1. `null` — предела нет и делить
  /// не от чего.
  double? get rabbitsUsage => _usage(rabbitsCount, plan?.maxRabbits);

  /// То же по составу фермы.
  double? get staffUsage => _usage(staffCount, plan?.maxStaff);

  /// Ферма упёрлась хотя бы в один из своих пределов — дальше сервер начнёт
  /// отказывать в создании записей.
  bool get isAtLimit =>
      _reached(rabbitsCount, plan?.maxRabbits) ||
      _reached(staffCount, plan?.maxStaff);

  /// Ферма подошла к пределу вплотную: осталась пятая часть или меньше.
  bool get isNearLimit =>
      !isAtLimit &&
      ((rabbitsUsage ?? 0) >= 0.8 || (staffUsage ?? 0) >= 0.8);

  static double? _usage(int used, int? limit) {
    if (limit == null || limit <= 0) return null;
    return used / limit;
  }

  static bool _reached(int used, int? limit) => limit != null && used >= limit;

  factory PlatformFarm.fromJson(Map<String, dynamic> json) =>
      _$PlatformFarmFromJson(json);
}
