import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/models/farm_ref.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    required String role,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') required bool isActive,
    // Вход мог быть только по OTP — тогда пароля ещё нет вовсе, и Настройки
    // должны предложить «Задать пароль», а не «Изменить».
    @JsonKey(name: 'has_password') @Default(false) bool hasPassword,
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
