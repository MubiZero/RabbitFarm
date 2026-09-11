import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/models/farm_ref.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    // Пусто у того, кто вошёл по телефону и почту не называл: с переходом на
    // вход по номеру (см. docs/HANDOFF.md) `users.email` стал необязательным
    // на сервере, и у приглашённого по SMS работника его действительно нет.
    String? email,
    @JsonKey(name: 'full_name') required String fullName,
    required String role,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') required bool isActive,
    // Платформенный суперадмин — это не роль на ферме, а отдельное
    // измерение доступа: он администрирует сервис целиком. Флаг ставится
    // вручную в базе, поэтому у обычного пользователя его в ответе может
    // не быть вовсе — отсюда значение по умолчанию.
    @JsonKey(name: 'is_platform_admin') @Default(false) bool isPlatformAdmin,
    @JsonKey(name: 'last_login_at') @NullableDateTimeConverter() DateTime? lastLoginAt,
    // Единственная настройка уведомлений на сейчас — получать ли ежедневный
    // дайджест (см. Настройки, `notificationDigestJob.js`). По умолчанию
    // включён: молчание не должно стать дефолтом там, где выбора раньше не
    // было вовсе.
    @JsonKey(name: 'digest_enabled') @Default(true) bool digestEnabled,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() required DateTime updatedAt,
    // Статус доступа хозяйства (см. `FarmStatusBanner`) — сервер отдаёт его
    // вместе с профилем начиная с 4.2. У платформенного админа вне фермы
    // может не быть вовсе.
    FarmRef? farm,
  }) = _UserModel;

  const UserModel._();

  /// Контакт для показа в профиле: почта, а у вошедшего по номеру — телефон.
  /// Хотя бы одно есть всегда — сервер не заводит учётку без того и другого.
  String? get contact =>
      email ?? (phone == null ? null : formatTjPhone(phone!));

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
