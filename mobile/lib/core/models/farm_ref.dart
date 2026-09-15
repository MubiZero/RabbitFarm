import 'package:freezed_annotation/freezed_annotation.dart';
import '../json/int_converter.dart';

part 'farm_ref.freezed.dart';
part 'farm_ref.g.dart';

/// Урезанная ферма при пользователе: состояние доступа (см.
/// `FarmStatusBanner`) и назначение по умолчанию. Сервер отдаёт её вместе с
/// профилем (`GET /auth/me`, вход, регистрация), полная `Farm` со всеми
/// полями здесь не нужна.
@freezed
abstract class FarmRef with _$FarmRef {
  const factory FarmRef({
    @IntConverter() required int id,
    // `active` / `read_only` / `suspended` — строкой, а не enum: незнакомое
    // значение (добавленное на сервере позже) не должно ронять разбор
    // профиля целиком.
    required String status,

    /// Кого это хозяйство держит: назначение, которое форма подставляет
    /// новому кролику. Пусто — хозяйство ещё не сказало, и действует
    /// «племя», как и на сервере.
    @JsonKey(name: 'default_purpose') String? defaultPurpose,
  }) = _FarmRef;

  factory FarmRef.fromJson(Map<String, dynamic> json) =>
      _$FarmRefFromJson(json);
}
