import 'package:freezed_annotation/freezed_annotation.dart';
import 'breed_model.dart';

part 'rabbit_model.freezed.dart';
part 'rabbit_model.g.dart';

@freezed
class RabbitModel with _$RabbitModel {
  const factory RabbitModel({
    required int id,
    @JsonKey(name: 'tag_id') required String tagId,
    required String name,
    @JsonKey(name: 'breed_id') required int breedId,
    required String sex,
    @JsonKey(name: 'birth_date') required DateTime birthDate,
    String? color,
    @JsonKey(name: 'cage_id') int? cageId,
    @JsonKey(name: 'father_id') int? fatherId,
    @JsonKey(name: 'mother_id') int? motherId,
    required String status,
    required String purpose,
    @JsonKey(name: 'acquired_date') DateTime? acquiredDate,
    @JsonKey(name: 'sold_date') DateTime? soldDate,
    @JsonKey(name: 'death_date') DateTime? deathDate,
    @JsonKey(name: 'death_reason') String? deathReason,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? temperament,
    String? notes,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Relations
    @JsonKey(name: 'Breed') BreedModel? breed,
    @JsonKey(name: 'Cage') CageInfo? cage,
    @JsonKey(name: 'father') ParentInfo? father,
    @JsonKey(name: 'mother') ParentInfo? mother,
  }) = _RabbitModel;

  factory RabbitModel.fromJson(Map<String, dynamic> json) =>
      _$RabbitModelFromJson(json);
}

@freezed
class CageInfo with _$CageInfo {
  const factory CageInfo({
    required int id,
    required String number,
    String? type,
    String? location,
  }) = _CageInfo;

  factory CageInfo.fromJson(Map<String, dynamic> json) =>
      _$CageInfoFromJson(json);
}

@freezed
class ParentInfo with _$ParentInfo {
  const factory ParentInfo({
    required int id,
    required String name,
    @JsonKey(name: 'tag_id') required String tagId,
  }) = _ParentInfo;

  factory ParentInfo.fromJson(Map<String, dynamic> json) =>
      _$ParentInfoFromJson(json);
}
