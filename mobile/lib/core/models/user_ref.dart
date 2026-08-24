import 'package:freezed_annotation/freezed_annotation.dart';
import '../json/int_converter.dart';

part 'user_ref.freezed.dart';
part 'user_ref.g.dart';

/// Ссылка на человека: кто записал кормление, кто поставил задачу.
///
/// К записям сервер прикладывает автора урезанным — только id, имя и почту, —
/// поэтому полная `UserModel` (с ролью, датами и признаком активности) на этом
/// объекте не разберётся. Лежит в core, а не в фиче: автор нужен и кормлениям,
/// и задачам, и любой другой записи, у которой есть «кто это сделал».
@freezed
class UserRef with _$UserRef {
  const factory UserRef({
    @IntConverter() required int id,
    @JsonKey(name: 'full_name') required String fullName,
    String? email,
  }) = _UserRef;

  factory UserRef.fromJson(Map<String, dynamic> json) =>
      _$UserRefFromJson(json);
}
