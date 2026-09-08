// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CageModel _$CageModelFromJson(Map<String, dynamic> json) => _CageModel(
  id: const IntConverter().fromJson(json['id'] as Object),
  number: json['number'] as String,
  type: json['type'] as String,
  size: json['size'] as String?,
  capacity: const IntConverter().fromJson(json['capacity'] as Object),
  location: json['location'] as String?,
  condition: json['condition'] as String,
  lastCleanedAt: const NullableDateTimeConverter().fromJson(
    json['last_cleaned_at'],
  ),
  notes: json['notes'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updated_at']),
  rabbits: (json['rabbits'] as List<dynamic>?)
      ?.map((e) => RabbitModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentOccupancy: const NullableIntConverter().fromJson(
    json['current_occupancy'],
  ),
  isFull: json['is_full'] as bool?,
  isAvailable: json['is_available'] as bool?,
);

Map<String, dynamic> _$CageModelToJson(
  _CageModel instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'number': instance.number,
  'type': instance.type,
  'size': instance.size,
  'capacity': const IntConverter().toJson(instance.capacity),
  'location': instance.location,
  'condition': instance.condition,
  'last_cleaned_at': const NullableDateTimeConverter().toJson(
    instance.lastCleanedAt,
  ),
  'notes': instance.notes,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const NullableDateTimeConverter().toJson(instance.updatedAt),
  'rabbits': instance.rabbits,
  'current_occupancy': const NullableIntConverter().toJson(
    instance.currentOccupancy,
  ),
  'is_full': instance.isFull,
  'is_available': instance.isAvailable,
};

_CageStatistics _$CageStatisticsFromJson(Map<String, dynamic> json) =>
    _CageStatistics(
      totalCages: const IntConverter().fromJson(json['total_cages'] as Object),
      byType: CageTypeStats.fromJson(json['by_type'] as Map<String, dynamic>),
      byCondition: CageConditionStats.fromJson(
        json['by_condition'] as Map<String, dynamic>,
      ),
      occupancy: CageOccupancyStats.fromJson(
        json['occupancy'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CageStatisticsToJson(_CageStatistics instance) =>
    <String, dynamic>{
      'total_cages': const IntConverter().toJson(instance.totalCages),
      'by_type': instance.byType,
      'by_condition': instance.byCondition,
      'occupancy': instance.occupancy,
    };

_CageTypeStats _$CageTypeStatsFromJson(Map<String, dynamic> json) =>
    _CageTypeStats(
      single: const IntConverter().fromJson(json['single'] as Object),
      group: const IntConverter().fromJson(json['group'] as Object),
      maternity: const IntConverter().fromJson(json['maternity'] as Object),
    );

Map<String, dynamic> _$CageTypeStatsToJson(_CageTypeStats instance) =>
    <String, dynamic>{
      'single': const IntConverter().toJson(instance.single),
      'group': const IntConverter().toJson(instance.group),
      'maternity': const IntConverter().toJson(instance.maternity),
    };

_CageConditionStats _$CageConditionStatsFromJson(Map<String, dynamic> json) =>
    _CageConditionStats(
      good: const IntConverter().fromJson(json['good'] as Object),
      needsRepair: const IntConverter().fromJson(
        json['needs_repair'] as Object,
      ),
      broken: const IntConverter().fromJson(json['broken'] as Object),
    );

Map<String, dynamic> _$CageConditionStatsToJson(_CageConditionStats instance) =>
    <String, dynamic>{
      'good': const IntConverter().toJson(instance.good),
      'needs_repair': const IntConverter().toJson(instance.needsRepair),
      'broken': const IntConverter().toJson(instance.broken),
    };

_CageOccupancyStats _$CageOccupancyStatsFromJson(Map<String, dynamic> json) =>
    _CageOccupancyStats(
      totalCapacity: const IntConverter().fromJson(
        json['total_capacity'] as Object,
      ),
      currentOccupancy: const IntConverter().fromJson(
        json['current_occupancy'] as Object,
      ),
      availableSpaces: const IntConverter().fromJson(
        json['available_spaces'] as Object,
      ),
      occupancyRate: const IntConverter().fromJson(
        json['occupancy_rate'] as Object,
      ),
      fullCages: const IntConverter().fromJson(json['full_cages'] as Object),
      emptyCages: const IntConverter().fromJson(json['empty_cages'] as Object),
    );

Map<String, dynamic> _$CageOccupancyStatsToJson(
  _CageOccupancyStats instance,
) => <String, dynamic>{
  'total_capacity': const IntConverter().toJson(instance.totalCapacity),
  'current_occupancy': const IntConverter().toJson(instance.currentOccupancy),
  'available_spaces': const IntConverter().toJson(instance.availableSpaces),
  'occupancy_rate': const IntConverter().toJson(instance.occupancyRate),
  'full_cages': const IntConverter().toJson(instance.fullCages),
  'empty_cages': const IntConverter().toJson(instance.emptyCages),
};
