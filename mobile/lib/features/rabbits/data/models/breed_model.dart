import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/int_converter.dart';

part 'breed_model.freezed.dart';
part 'breed_model.g.dart';

@freezed
class BreedModel with _$BreedModel {
  const factory BreedModel({
    @IntConverter() required int id,
    required String name,
    String? description,
    @JsonKey(name: 'average_weight') double? averageWeight,
    @JsonKey(name: 'average_litter_size') @IntConverter() int? averageLitterSize,
    String? purpose,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _BreedModel;

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);
}
