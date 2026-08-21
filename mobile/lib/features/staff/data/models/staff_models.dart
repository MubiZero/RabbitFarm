import 'package:freezed_annotation/freezed_annotation.dart';
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
class FarmMember with _$FarmMember {
  const factory FarmMember({
    @IntConverter() required int id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    required FarmRole role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'owner_id') @NullableIntConverter() int? ownerId,
  }) = _FarmMember;

  const FarmMember._();

  /// У владельца нет своего владельца — по этому и отличаем.
  bool get isOwner => ownerId == null;

  factory FarmMember.fromJson(Map<String, dynamic> json) =>
      _$FarmMemberFromJson(json);
}

/// Выписанное, но ещё не использованное приглашение.
@freezed
class FarmInvitation with _$FarmInvitation {
  const factory FarmInvitation({
    @IntConverter() required int id,
    required String email,
    required FarmRole role,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _FarmInvitation;

  factory FarmInvitation.fromJson(Map<String, dynamic> json) =>
      _$FarmInvitationFromJson(json);
}

/// Ответ на создание приглашения: код приходит ровно один раз.
@freezed
class CreatedInvitation with _$CreatedInvitation {
  const factory CreatedInvitation({
    @IntConverter() required int id,
    required String email,
    required FarmRole role,
    required String code,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _CreatedInvitation;

  factory CreatedInvitation.fromJson(Map<String, dynamic> json) =>
      _$CreatedInvitationFromJson(json);
}
