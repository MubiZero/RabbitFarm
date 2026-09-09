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
abstract class Plan with _$Plan {
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
abstract class PlanDraft with _$PlanDraft {
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
abstract class PlatformFarm with _$PlatformFarm {
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
abstract class FarmStaffMember with _$FarmStaffMember {
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
abstract class FarmPayment with _$FarmPayment {
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
abstract class PlatformFarmDetail with _$PlatformFarmDetail {
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

/// Фермы платформы по категориям — часть [PlatformSummary].
///
/// Категории тарифа не пересекаются и в сумме дают `total`: каждая ферма
/// попадает ровно в одну из `free`/`paid`/`noPlan`. `expired`/`suspended`/
/// `atLimit` — независимые срезы поверх них, ферма может входить сразу в
/// несколько (просроченный платный тариф почти всегда означает и
/// `read_only`, но это не одно и то же поле).
@freezed
abstract class PlatformFarmsSummary with _$PlatformFarmsSummary {
  const factory PlatformFarmsSummary({
    @IntConverter() @Default(0) int total,
    @IntConverter() @Default(0) int free,
    @IntConverter() @Default(0) int paid,
    @JsonKey(name: 'no_plan') @IntConverter() @Default(0) int noPlan,
    @IntConverter() @Default(0) int expired,
    @IntConverter() @Default(0) int suspended,
    @JsonKey(name: 'at_limit') @IntConverter() @Default(0) int atLimit,
  }) = _PlatformFarmsSummary;

  factory PlatformFarmsSummary.fromJson(Map<String, dynamic> json) =>
      _$PlatformFarmsSummaryFromJson(json);
}

/// Сводка платформы целиком (см. docs/plans/PLATFORM-ADMIN.md, этап 5) — один
/// агрегирующий запрос вместо подсчёта по загруженным страницам списка ферм,
/// иначе «12 ферм» означало бы «столько успело догрузиться».
@freezed
abstract class PlatformSummary with _$PlatformSummary {
  const factory PlatformSummary({
    @Default(PlatformFarmsSummary()) PlatformFarmsSummary farms,
    @JsonKey(name: 'registrations_30d') @IntConverter() @Default(0) int registrations30d,
    @JsonKey(name: 'inactive_30d') @IntConverter() @Default(0) int inactive30d,
    @JsonKey(name: 'rabbits_total') @IntConverter() @Default(0) int rabbitsTotal,
    @JsonKey(name: 'storage_bytes') @IntConverter() @Default(0) int storageBytes,
  }) = _PlatformSummary;

  factory PlatformSummary.fromJson(Map<String, dynamic> json) =>
      _$PlatformSummaryFromJson(json);
}

/// Итог отправки по одному каналу.
///
/// Неудачи — такая же часть результата, как и удачи: объявление, дошедшее до
/// тридцати из тридцати четырёх, отправлено не «успешно», а с потерями, и
/// админ должен это видеть.
@freezed
abstract class ChannelDelivery with _$ChannelDelivery {
  const factory ChannelDelivery({
    @IntConverter() @Default(0) int sent,
    @IntConverter() @Default(0) int failed,
  }) = _ChannelDelivery;

  const ChannelDelivery._();

  /// Сколько сообщений вообще пытались отправить этим каналом.
  int get attempted => sent + failed;

  bool get hasFailures => failed > 0;

  factory ChannelDelivery.fromJson(Map<String, dynamic> json) =>
      _$ChannelDeliveryFromJson(json);
}

/// Доставка объявления по каналам.
///
/// Оба поля необязательные: сервер считает статистику только по тем каналам,
/// которыми объявление отправляли, — и «нулём» отсутствие канала подменять
/// нельзя, иначе «email 0 из 0» читалось бы как провал рассылки, которой не
/// было.
@freezed
abstract class AnnouncementStats with _$AnnouncementStats {
  const factory AnnouncementStats({
    ChannelDelivery? push,
    ChannelDelivery? email,
  }) = _AnnouncementStats;

  const AnnouncementStats._();

  ChannelDelivery? byChannel(String channel) => switch (channel) {
        'push' => push,
        'email' => email,
        _ => null,
      };

  /// Хотя бы одно сообщение не дошло — по любому из каналов.
  bool get hasFailures =>
      (push?.hasFailures ?? false) || (email?.hasFailures ?? false);

  factory AnnouncementStats.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementStatsFromJson(json);
}

/// Ферма-адресат объявления — только то, что нужно для подписи в истории.
///
/// Отдельный класс, а не переиспользование [PlatformFarm]: сервер отдаёт
/// объявлению только имя фермы, не её тариф и потребление, — тащить их сюда
/// было бы полем, которое никогда не заполнится.
@freezed
abstract class AnnouncementTargetFarm with _$AnnouncementTargetFarm {
  const factory AnnouncementTargetFarm({
    @IntConverter() required int id,
    required String name,
  }) = _AnnouncementTargetFarm;

  factory AnnouncementTargetFarm.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementTargetFarmFromJson(json);
}

/// Отправленное объявление платформенного админа.
///
/// Неизменяемая запись истории: отозвать её нельзя, поэтому в модели нет ни
/// правки, ни черновиков — только то, что уже ушло, и с каким результатом.
///
/// `targetType` и `targetFilter` — строки, а не enum, по той же причине, что и
/// `status` у [PlatformFarmDetail]: значения приходят от сервера, и незнакомое
/// не должно ронять разбор всего списка.
@freezed
abstract class Announcement with _$Announcement {
  const factory Announcement({
    @IntConverter() required int id,
    required String title,
    required String body,
    // Доступны только push и почта. SMS сюда не входит: шлюз принимает лишь
    // заранее одобренные шаблоны, а объявление — свободный текст.
    @Default(<String>[]) List<String> channels,
    @JsonKey(name: 'target_type') @Default('all') String targetType,
    @JsonKey(name: 'target_farm_id') @NullableIntConverter() int? targetFarmId,
    // Имя приезжает вложенным объектом (ключ ассоциации на сервере — camelCase,
    // как и у `auditLog` в других местах того же API). `null` у ферм, которых
    // с тех пор удалили, — тогда история показывает id как есть.
    AnnouncementTargetFarm? targetFarm,
    @JsonKey(name: 'target_filter') String? targetFilter,
    // Скольким фермам адресовано и сколько человек в них оказалось. Второе
    // может быть нулём при непустом первом — например, у ферм без активных
    // пользователей.
    @JsonKey(name: 'farms_count') @IntConverter() @Default(0) int farmsCount,
    @JsonKey(name: 'recipients_count')
    @IntConverter()
    @Default(0)
    int recipientsCount,
    AnnouncementStats? stats,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
  }) = _Announcement;

  const Announcement._();

  /// Объявление никому не досталось: подходящих получателей не нашлось.
  bool get hasNoRecipients => recipientsCount == 0;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}

/// Что админ набрал в форме объявления.
///
/// [toJson] написан руками, а не сгенерирован: сервер запрещает лишние поля —
/// `target_farm_id` допустим только при адресате «одна ферма», а
/// `target_filter` — только при «по срезу». Пустое значение в теле запроса
/// это уже нарушение, поэтому неподходящие поля не отправляются вовсе.
@freezed
abstract class AnnouncementDraft with _$AnnouncementDraft {
  const factory AnnouncementDraft({
    required String title,
    required String body,
    required List<String> channels,
    required String targetType,
    int? targetFarmId,
    String? targetFilter,
  }) = _AnnouncementDraft;

  const AnnouncementDraft._();

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'channels': channels,
        'target_type': targetType,
        if (targetType == 'farm') 'target_farm_id': targetFarmId,
        if (targetType == 'filter') 'target_filter': targetFilter,
      };
}

/// Ферма-автор обращения в поддержку — только то, что нужно для подписи в
/// списке (см. `AnnouncementTargetFarm`, тот же приём и та же причина: сервер
/// отдаёт обращению лишь имя фермы, не весь `PlatformFarm`).
@freezed
abstract class SupportRequestFarm with _$SupportRequestFarm {
  const factory SupportRequestFarm({
    @IntConverter() required int id,
    required String name,
  }) = _SupportRequestFarm;

  factory SupportRequestFarm.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFarmFromJson(json);
}

/// Обращение фермы в поддержку — видно платформенному админу.
///
/// Ни темы, ни переписки: одно сообщение и статус `new`/`resolved`. Автор
/// [UserRef] уже есть в `core/models` — то же самое урезанное «кто это
/// сделал», что у записи кормления или задачи.
@freezed
abstract class SupportRequest with _$SupportRequest {
  const factory SupportRequest({
    @IntConverter() required int id,
    required String text,
    @Default('new') String status,
    SupportRequestFarm? farm,
    UserRef? author,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
  }) = _SupportRequest;

  const SupportRequest._();

  bool get isResolved => status == 'resolved';

  factory SupportRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFromJson(json);
}
