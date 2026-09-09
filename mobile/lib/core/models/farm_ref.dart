import 'package:freezed_annotation/freezed_annotation.dart';
import '../json/int_converter.dart';

part 'farm_ref.freezed.dart';
part 'farm_ref.g.dart';

/// Урезанная ферма при пользователе — только то, что решает, показывать ли
/// баннер о состоянии доступа (см. `FarmStatusBanner`): сервер отдаёт её
/// вместе с профилем (`GET /auth/me`, вход, регистрация), полная `Farm` со
/// всеми полями здесь не нужна.
@freezed
abstract class FarmRef with _$FarmRef {
  const factory FarmRef({
    @IntConverter() required int id,
    // `active` / `read_only` / `suspended` — строкой, а не enum: незнакомое
    // значение (добавленное на сервере позже) не должно ронять разбор
    // профиля целиком.
    required String status,
  }) = _FarmRef;

  factory FarmRef.fromJson(Map<String, dynamic> json) =>
      _$FarmRefFromJson(json);
}
