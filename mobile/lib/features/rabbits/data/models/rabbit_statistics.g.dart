// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitStatisticsImpl _$$RabbitStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$RabbitStatisticsImpl(
  total: (json['total'] as num?)?.toInt() ?? 0,
  aliveCount: (json['alive_count'] as num?)?.toInt() ?? 0,
  maleCount: (json['male_count'] as num?)?.toInt() ?? 0,
  femaleCount: (json['female_count'] as num?)?.toInt() ?? 0,
  pregnantCount: (json['pregnant_count'] as num?)?.toInt() ?? 0,
  sickCount: (json['sick_count'] as num?)?.toInt() ?? 0,
  forSaleCount: (json['for_sale_count'] as num?)?.toInt() ?? 0,
  byBreed:
      (json['by_breed'] as List<dynamic>?)
          ?.map((e) => BreedStats.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  deadCount: (json['dead_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$RabbitStatisticsImplToJson(
  _$RabbitStatisticsImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'alive_count': instance.aliveCount,
  'male_count': instance.maleCount,
  'female_count': instance.femaleCount,
  'pregnant_count': instance.pregnantCount,
  'sick_count': instance.sickCount,
  'for_sale_count': instance.forSaleCount,
  'by_breed': instance.byBreed,
  'dead_count': instance.deadCount,
};

_$BreedStatsImpl _$$BreedStatsImplFromJson(Map<String, dynamic> json) =>
    _$BreedStatsImpl(
      breedId: (json['breed_id'] as num?)?.toInt(),
      breedName: json['breed_name'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BreedStatsImplToJson(_$BreedStatsImpl instance) =>
    <String, dynamic>{
      'breed_id': instance.breedId,
      'breed_name': instance.breedName,
      'count': instance.count,
    };
