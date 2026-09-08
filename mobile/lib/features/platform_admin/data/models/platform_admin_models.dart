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
    // Последний вход кого-либо из фермы — `max(users.last_login_at)`. `null`
    // значит «никто ещё не заходил», а не «неизвестно»: разница важна для
    // фильтра «не заходили N дней».
    @JsonKey(name: 'last_active') @NullableDateTimeConverter() DateTime? lastActiveAt,
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

/// Человек в составе фермы — глазами платформы.
///
/// Роль остаётся строкой, а не превращается в свой enum: разбор ролей уже
/// живёт в `core/access` (`FarmRoleAccess.parse`) вместе с подписями из
/// словаря, и второй перечень тех же трёх значений расходился бы с ним.
@freezed
class FarmStaffMember with _$FarmStaffMember {
  const factory FarmStaffMember({
    @IntConverter() required int id,
    @JsonKey(name: 'full_name') required String fullName,
    String? email,
    String? phone,
    required String role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    // `null` — «ни разу не заходил», а не «неизвестно»: поддержке важно
    // отличать нового человека от того, кто перестал заходить.
    @JsonKey(name: 'last_login_at')
    @NullableDateTimeConverter()
    DateTime? lastLoginAt,
  }) = _FarmStaffMember;

  factory FarmStaffMember.fromJson(Map<String, dynamic> json) =>
      _$FarmStaffMemberFromJson(json);
}

/// Платёж фермы в истории её обслуживания.
///
/// Сумма — строка, потому что DECIMAL приходит от базы строкой. В double её
/// здесь не переводим: модель отдаёт то, что прислал сервер, а округление и
/// знак валюты — дело экрана.
@freezed
class FarmPayment with _$FarmPayment {
  const factory FarmPayment({
    @IntConverter() required int id,
    required String amount,
    required String currency,
    required String status,
    String? description,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
  }) = _FarmPayment;

  factory FarmPayment.fromJson(Map<String, dynamic> json) =>
      _$FarmPaymentFromJson(json);
}

/// Ферма целиком — то, из чего собрана её карточка в админке.
///
/// Отдельный класс, а не расширение [PlatformFarm]: список ферм получает
/// короткую форму (тридцать ферм со составом и платежами были бы килобайтами
/// впустую), а карточка — полную. Несколько общих полей продублированы
/// осознанно — freezed-классы не наследуются друг от друга.
@freezed
class PlatformFarmDetail with _$PlatformFarmDetail {
  const factory PlatformFarmDetail({
    @IntConverter() required int id,
    required String name,
    UserRef? owner,
    @JsonKey(name: 'plan_id') @NullableIntConverter() int? planId,
    Plan? plan,
    // Пусто = бессрочно. Так и будет у бесплатного тарифа по умолчанию.
    @JsonKey(name: 'plan_expires_at')
    @NullableDateTimeConverter()
    DateTime? planExpiresAt,
    // `active` / `read_only` / `suspended`. Строкой, а не enum: значение
    // приходит от сервера, и незнакомое (например, добавленное позже)
    // не должно ронять разбор всей фермы.
    @Default('active') String status,
    @JsonKey(name: 'extra_rabbits') @NullableIntConverter() int? extraRabbits,
    @JsonKey(name: 'extra_staff') @NullableIntConverter() int? extraStaff,
    @JsonKey(name: 'extras_until')
    @NullableDateTimeConverter()
    DateTime? extrasUntil,
    @JsonKey(name: 'rabbits_count') @IntConverter() @Default(0) int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() @Default(0) int staffCount,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    DateTime? lastActiveAt,
    @Default([]) List<FarmStaffMember> staff,
    @Default([]) List<FarmPayment> payments,
    @JsonKey(name: 'storage_bytes') @IntConverter() @Default(0) int storageBytes,
    // Мягкое удаление: доступ фермы закрыт сразу, а записи физически уходят
    // через окно ожидания. Пусто = ферма жива.
    @JsonKey(name: 'deleted_at')
    @NullableDateTimeConverter()
    DateTime? deletedAt,
  }) = _PlatformFarmDetail;

  const PlatformFarmDetail._();

  /// Ферма помечена на удаление и ждёт окончательной чистки.
  bool get isDeleted => deletedAt != null;

  bool get isActive => status == 'active';
  bool get isReadOnly => status == 'read_only';
  bool get isSuspended => status == 'suspended';

  /// Поблажка выдана и ещё действует.
  ///
  /// Пустой срок при ненулевой добавке — «бессрочно», а не «истекла»: так
  /// договорились на сервере.
  bool get hasActiveExtras => _hasExtras && !_extrasExpired;

  /// Поблажка была, но её срок прошёл. Отдельно от [hasActiveExtras], потому
  /// что «истекла» и «не выдавали» — разные ответы на вопрос админа.
  bool get hasExpiredExtras => _hasExtras && _extrasExpired;

  bool get _hasExtras => extraRabbits != null || extraStaff != null;

  bool get _extrasExpired =>
      extrasUntil != null && !extrasUntil!.isAfter(DateTime.now());

  /// Предел поголовья с учётом действующей поблажки.
  ///
  /// Сервер держит `plan.max_rabbits` нетронутым — подмешивать туда добавку
  /// значило бы врать о самом тарифе, который виден и другим фермам. Поэтому
  /// складывает клиент, и только пока поблажка не истекла.
  int? get effectiveRabbitsLimit => _effective(plan?.maxRabbits, extraRabbits);

  /// То же по составу фермы.
  int? get effectiveStaffLimit => _effective(plan?.maxStaff, extraStaff);

  double? get rabbitsUsage => _usage(rabbitsCount, effectiveRabbitsLimit);

  double? get staffUsage => _usage(staffCount, effectiveStaffLimit);

  /// Ферма упёрлась хотя бы в один из своих пределов — дальше сервер начнёт
  /// отказывать в создании записей.
  bool get isAtLimit =>
      _reached(rabbitsCount, effectiveRabbitsLimit) ||
      _reached(staffCount, effectiveStaffLimit);

  int? _effective(int? limit, int? extra) {
    if (limit == null) return null;
    return limit + (hasActiveExtras ? (extra ?? 0) : 0);
  }

  static double? _usage(int used, int? limit) {
    if (limit == null || limit <= 0) return null;
    return used / limit;
  }

  static bool _reached(int used, int? limit) => limit != null && used >= limit;

  factory PlatformFarmDetail.fromJson(Map<String, dynamic> json) =>
      _$PlatformFarmDetailFromJson(json);
}
