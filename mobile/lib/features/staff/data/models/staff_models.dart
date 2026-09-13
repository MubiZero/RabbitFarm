import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/utils/phone_utils.dart';

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
    // Почты может не быть вовсе: работника приглашают по телефону, и входит
    // он кодом из SMS. Контакт для показа — `contact`.
    String? email,
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

  /// Контакт для показа в составе фермы: почта, а если её нет — телефон.
  /// Хотя бы одно есть всегда (сервер требует при заведении учётки).
  String get contact => email ?? (phone == null ? '' : formatTjPhone(phone!));

  factory FarmMember.fromJson(Map<String, dynamic> json) =>
      _$FarmMemberFromJson(json);
}

/// Выписанное, но ещё не использованное приглашение.
@freezed
abstract class FarmInvitation with _$FarmInvitation {
  const factory FarmInvitation({
    @IntConverter() required int id,
    String? email,
    String? phone,
    required FarmRole role,
    @JsonKey(name: 'expires_at') @DateTimeConverter() required DateTime expiresAt,
  }) = _FarmInvitation;

  const FarmInvitation._();

  /// Кому выписано — почта или телефон. Приглашение всегда ровно на одно из
  /// двух (сервер принимает только одно), поэтому одно поле для показа.
  String get contact => email ?? (phone == null ? '' : formatTjPhone(phone!));

  factory FarmInvitation.fromJson(Map<String, dynamic> json) =>
      _$FarmInvitationFromJson(json);
}

/// Ответ на создание приглашения. Кода в нём нет: приглашённый войдёт
/// обычным кодом на свой контакт, и этот вход активирует приглашение.
@freezed
abstract class CreatedInvitation with _$CreatedInvitation {
  const factory CreatedInvitation({
    @IntConverter() required int id,
    String? email,
    String? phone,
    @JsonKey(name: 'full_name') String? fullName,
    required FarmRole role,
    @JsonKey(name: 'expires_at') @DateTimeConverter() required DateTime expiresAt,
  }) = _CreatedInvitation;

  const CreatedInvitation._();

  String get contact => email ?? (phone == null ? '' : formatTjPhone(phone!));

  factory CreatedInvitation.fromJson(Map<String, dynamic> json) =>
      _$CreatedInvitationFromJson(json);
}
