// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cage_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CageStatisticsImpl _$$CageStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$CageStatisticsImpl(
      totalCages: (json['total_cages'] as num).toInt(),
      byType: Map<String, int>.from(json['by_type'] as Map),
      byCondition: Map<String, int>.from(json['by_condition'] as Map),
      occupancy: CageOccupancyStats.fromJson(
        json['occupancy'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$CageStatisticsImplToJson(
  _$CageStatisticsImpl instance,
) => <String, dynamic>{
  'total_cages': instance.totalCages,
  'by_type': instance.byType,
  'by_condition': instance.byCondition,
  'occupancy': instance.occupancy,
};

_$CageOccupancyStatsImpl _$$CageOccupancyStatsImplFromJson(
  Map<String, dynamic> json,
) => _$CageOccupancyStatsImpl(
  totalCapacity: (json['total_capacity'] as num).toInt(),
  currentOccupancy: (json['current_occupancy'] as num).toInt(),
  availableSpaces: (json['available_spaces'] as num).toInt(),
  occupancyRate: (json['occupancy_rate'] as num).toInt(),
  fullCages: (json['full_cages'] as num).toInt(),
  emptyCages: (json['empty_cages'] as num).toInt(),
);

Map<String, dynamic> _$$CageOccupancyStatsImplToJson(
  _$CageOccupancyStatsImpl instance,
) => <String, dynamic>{
  'total_capacity': instance.totalCapacity,
  'current_occupancy': instance.currentOccupancy,
  'available_spaces': instance.availableSpaces,
  'occupancy_rate': instance.occupancyRate,
  'full_cages': instance.fullCages,
  'empty_cages': instance.emptyCages,
};
