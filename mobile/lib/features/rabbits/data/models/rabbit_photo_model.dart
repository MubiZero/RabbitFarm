import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/models/user_ref.dart';

part 'rabbit_photo_model.freezed.dart';
part 'rabbit_photo_model.g.dart';

/// Один снимок в галерее кролика — в отличие от `photoUrl` на самой карточке,
/// снимков может быть много.
@freezed
class RabbitPhoto with _$RabbitPhoto {
  const factory RabbitPhoto({
    @IntConverter() required int id,
    required String url,
    String? caption,
    @JsonKey(name: 'taken_at') @NullableDateTimeConverter() DateTime? takenAt,
    @JsonKey(name: 'created_at') @NullableDateTimeConverter() DateTime? createdAt,
    UserRef? author,
  }) = _RabbitPhoto;

  factory RabbitPhoto.fromJson(Map<String, dynamic> json) =>
      _$RabbitPhotoFromJson(json);
}
