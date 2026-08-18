import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/json/double_converter.dart';

part 'rabbit_weight_model.freezed.dart';
part 'rabbit_weight_model.g.dart';

// IntConverter вынесен в core/json/int_converter.dart и импортирован выше

@freezed
class RabbitWeight with _$RabbitWeight {
  const factory RabbitWeight({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required int rabbitId,
    @DoubleConverter() required double weight,
    @JsonKey(name: 'measured_at') required DateTime measuredAt,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _RabbitWeight;

  factory RabbitWeight.fromJson(Map<String, dynamic> json) =>
      _$RabbitWeightFromJson(json);
}

/// Request model for adding new weight record
class AddWeightRequest {
  final double weight;
  final DateTime measuredAt;
  final String? notes;

  const AddWeightRequest({
    required this.weight,
    required this.measuredAt,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'weight': weight,
    'measured_at': measuredAt.toIso8601String(),
    if (notes != null) 'notes': notes,
  };
}
