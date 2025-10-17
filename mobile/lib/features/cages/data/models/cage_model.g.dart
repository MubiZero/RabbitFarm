// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CageModelImpl _$$CageModelImplFromJson(Map<String, dynamic> json) =>
    _$CageModelImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      number: json['number'] as String,
      type: json['type'] as String,
      size: json['size'] as String?,
      capacity: const IntConverter().fromJson(json['capacity'] as Object),
      location: json['location'] as String?,
      condition: json['condition'] as String,
      lastCleanedAt: json['last_cleaned_at'] == null
          ? null
          : DateTime.parse(json['last_cleaned_at'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      rabbits: (json['rabbits'] as List<dynamic>?)
          ?.map((e) => RabbitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentOccupancy: _$JsonConverterFromJson<Object, int>(
        json['current_occupancy'],
        const IntConverter().fromJson,
      ),
      isFull: json['is_full'] as bool?,
      isAvailable: json['is_available'] as bool?,
    );

Map<String, dynamic> _$$CageModelImplToJson(_$CageModelImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'number': instance.number,
      'type': instance.type,
      'size': instance.size,
      'capacity': const IntConverter().toJson(instance.capacity),
      'location': instance.location,
      'condition': instance.condition,
      'last_cleaned_at': instance.lastCleanedAt?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'rabbits': instance.rabbits,
      'current_occupancy': _$JsonConverterToJson<Object, int>(
        instance.currentOccupancy,
        const IntConverter().toJson,
      ),
      'is_full': instance.isFull,
      'is_available': instance.isAvailable,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_$CageStatisticsImpl _$$CageStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$CageStatisticsImpl(
      totalCages: const IntConverter().fromJson(json['total_cages'] as Object),
      byType: CageTypeStats.fromJson(json['by_type'] as Map<String, dynamic>),
      byCondition: CageConditionStats.fromJson(
        json['by_condition'] as Map<String, dynamic>,
      ),
      occupancy: CageOccupancyStats.fromJson(
        json['occupancy'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$CageStatisticsImplToJson(
  _$CageStatisticsImpl instance,
) => <String, dynamic>{
  'total_cages': const IntConverter().toJson(instance.totalCages),
  'by_type': instance.byType,
  'by_condition': instance.byCondition,
  'occupancy': instance.occupancy,
};

_$CageTypeStatsImpl _$$CageTypeStatsImplFromJson(Map<String, dynamic> json) =>
    _$CageTypeStatsImpl(
      single: const IntConverter().fromJson(json['single'] as Object),
      group: const IntConverter().fromJson(json['group'] as Object),
      maternity: const IntConverter().fromJson(json['maternity'] as Object),
    );

Map<String, dynamic> _$$CageTypeStatsImplToJson(_$CageTypeStatsImpl instance) =>
    <String, dynamic>{
      'single': const IntConverter().toJson(instance.single),
      'group': const IntConverter().toJson(instance.group),
      'maternity': const IntConverter().toJson(instance.maternity),
    };

_$CageConditionStatsImpl _$$CageConditionStatsImplFromJson(
  Map<String, dynamic> json,
) => _$CageConditionStatsImpl(
  good: const IntConverter().fromJson(json['good'] as Object),
  needsRepair: const IntConverter().fromJson(json['needs_repair'] as Object),
  broken: const IntConverter().fromJson(json['broken'] as Object),
);

Map<String, dynamic> _$$CageConditionStatsImplToJson(
  _$CageConditionStatsImpl instance,
) => <String, dynamic>{
  'good': const IntConverter().toJson(instance.good),
  'needs_repair': const IntConverter().toJson(instance.needsRepair),
  'broken': const IntConverter().toJson(instance.broken),
};

_$CageOccupancyStatsImpl _$$CageOccupancyStatsImplFromJson(
  Map<String, dynamic> json,
) => _$CageOccupancyStatsImpl(
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

Map<String, dynamic> _$$CageOccupancyStatsImplToJson(
  _$CageOccupancyStatsImpl instance,
) => <String, dynamic>{
  'total_capacity': const IntConverter().toJson(instance.totalCapacity),
  'current_occupancy': const IntConverter().toJson(instance.currentOccupancy),
  'available_spaces': const IntConverter().toJson(instance.availableSpaces),
  'occupancy_rate': const IntConverter().toJson(instance.occupancyRate),
  'full_cages': const IntConverter().toJson(instance.fullCages),
  'empty_cages': const IntConverter().toJson(instance.emptyCages),
};
