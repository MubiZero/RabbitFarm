// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitStatisticsImpl _$$RabbitStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$RabbitStatisticsImpl(
  total: json['total'] == null
      ? 0
      : const IntConverter().fromJson(json['total'] as Object),
  aliveCount: json['alive_count'] == null
      ? 0
      : const IntConverter().fromJson(json['alive_count'] as Object),
  maleCount: json['male_count'] == null
      ? 0
      : const IntConverter().fromJson(json['male_count'] as Object),
  femaleCount: json['female_count'] == null
      ? 0
      : const IntConverter().fromJson(json['female_count'] as Object),
  pregnantCount: json['pregnant_count'] == null
      ? 0
      : const IntConverter().fromJson(json['pregnant_count'] as Object),
  sickCount: json['sick_count'] == null
      ? 0
      : const IntConverter().fromJson(json['sick_count'] as Object),
  forSaleCount: json['for_sale_count'] == null
      ? 0
      : const IntConverter().fromJson(json['for_sale_count'] as Object),
  byBreed:
      (json['by_breed'] as List<dynamic>?)
          ?.map((e) => BreedStats.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  deadCount: json['dead_count'] == null
      ? 0
      : const IntConverter().fromJson(json['dead_count'] as Object),
);

Map<String, dynamic> _$$RabbitStatisticsImplToJson(
  _$RabbitStatisticsImpl instance,
) => <String, dynamic>{
  'total': const IntConverter().toJson(instance.total),
  'alive_count': const IntConverter().toJson(instance.aliveCount),
  'male_count': const IntConverter().toJson(instance.maleCount),
  'female_count': const IntConverter().toJson(instance.femaleCount),
  'pregnant_count': const IntConverter().toJson(instance.pregnantCount),
  'sick_count': const IntConverter().toJson(instance.sickCount),
  'for_sale_count': const IntConverter().toJson(instance.forSaleCount),
  'by_breed': instance.byBreed,
  'dead_count': const IntConverter().toJson(instance.deadCount),
};

_$BreedStatsImpl _$$BreedStatsImplFromJson(Map<String, dynamic> json) =>
    _$BreedStatsImpl(
      breedId: _$JsonConverterFromJson<Object, int>(
        json['breed_id'],
        const IntConverter().fromJson,
      ),
      breedName: json['breed_name'] as String?,
      count: json['count'] == null
          ? 0
          : const IntConverter().fromJson(json['count'] as Object),
    );

Map<String, dynamic> _$$BreedStatsImplToJson(_$BreedStatsImpl instance) =>
    <String, dynamic>{
      'breed_id': _$JsonConverterToJson<Object, int>(
        instance.breedId,
        const IntConverter().toJson,
      ),
      'breed_name': instance.breedName,
      'count': const IntConverter().toJson(instance.count),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
