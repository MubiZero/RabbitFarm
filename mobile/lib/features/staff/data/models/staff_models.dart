import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';

part 'staff_models.freezed.dart';
part 'staff_models.g.dart';

/// Роль на ферме. Владелец один, его роль не меняется.
enum FarmRole {
  @JsonValue('owner')
  owner,
  @JsonValue('manager')
  manager,
  @JsonValue('worker')
  worker,
}

extension FarmRoleLabels on FarmRole {
  String get label => switch (this) {
        FarmRole.owner => 'Владелец',
        FarmRole.manager => 'Управляющий',
        FarmRole.worker => 'Работник',
      };

  /// Что человеку доступно — короткой строкой под именем.
  String get description => switch (this) {
        FarmRole.owner => 'Полный доступ, включая работников',
        FarmRole.manager => 'Ведёт поголовье, корма и финансы',
        FarmRole.worker => 'Смотрит данные и отмечает работу',
      };
}

/// Участник фермы: владелец или его сотрудник.
@freezed
abstract class FarmMember with _$FarmMember {
  const factory FarmMember({
    @IntConverter() required int id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    required FarmRole role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _FarmMember;

  const FarmMember._();

  /// Владельца отличаем по роли.
  ///
  /// Раньше признаком была пустая ссылка на владельца: у хозяина её не было,
  /// потому что он и считался фермой. Теперь ферма — отдельная запись, и
  /// принадлежность к ней есть у всех, включая хозяина. Роль отвечает на
  /// вопрос прямо, а не через отсутствие поля.
  bool get isOwner => role == FarmRole.owner;

  factory FarmMember.fromJson(Map<String, dynamic> json) =>
      _$FarmMemberFromJson(json);
}

/// Выписанное, но ещё не использованное приглашение. Ровно одно из
/// [email]/[phone] заполнено — сервер принимает только одно из двух
/// (`.xor('email', 'phone')` в `staffValidator`).
@freezed
abstract class FarmInvitation with _$FarmInvitation {
  const factory FarmInvitation({
    @IntConverter() required int id,
    String? email,
    String? phone,
    @JsonKey(name: 'full_name') String? fullName,
    required FarmRole role,
    @JsonKey(name: 'expires_at') @DateTimeConverter() required DateTime expiresAt,
  }) = _FarmInvitation;

  const FarmInvitation._();

  /// Контакт для отображения — почта или телефон, что бы ни было заполнено.
  String get contact => email ?? phone ?? '';

  factory FarmInvitation.fromJson(Map<String, dynamic> json) =>
      _$FarmInvitationFromJson(json);
}

/// Ответ на создание приглашения: код приходит ровно один раз.
@freezed
abstract class CreatedInvitation with _$CreatedInvitation {
  const factory CreatedInvitation({
    @IntConverter() required int id,
    String? email,
    String? phone,
    required FarmRole role,
    required String code,
    @JsonKey(name: 'expires_at') @DateTimeConverter() required DateTime expiresAt,
  }) = _CreatedInvitation;

  const CreatedInvitation._();

  /// Контакт для отображения — почта или телефон, что бы ни было заполнено.
  String get contact => email ?? phone ?? '';

  factory CreatedInvitation.fromJson(Map<String, dynamic> json) =>
      _$CreatedInvitationFromJson(json);
}
