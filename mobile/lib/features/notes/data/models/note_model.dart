import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/models/user_ref.dart';
import '../../../rabbits/data/models/rabbit_model.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

/// Заметка — необязательно привязана к кролику или клетке: и то и другое
/// может быть пустым, тогда это заметка по ферме в целом.
@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    @IntConverter() required int id,
    required String content,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'created_at') @NullableDateTimeConverter() DateTime? createdAt,
    RabbitRef? rabbit,
    CageInfo? cage,
    UserRef? author,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

/// DTO создания заметки.
@freezed
class NoteCreate with _$NoteCreate {
  const factory NoteCreate({
    required String content,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'cage_id') int? cageId,
  }) = _NoteCreate;

  factory NoteCreate.fromJson(Map<String, dynamic> json) =>
      _$NoteCreateFromJson(json);
}

/// DTO правки заметки.
@freezed
class NoteUpdate with _$NoteUpdate {
  const factory NoteUpdate({
    String? content,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'cage_id') int? cageId,
  }) = _NoteUpdate;

  factory NoteUpdate.fromJson(Map<String, dynamic> json) =>
      _$NoteUpdateFromJson(json);
}
