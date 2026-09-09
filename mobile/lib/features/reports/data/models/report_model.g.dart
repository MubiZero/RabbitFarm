// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardReport _$DashboardReportFromJson(
  Map<String, dynamic> json,
) => _DashboardReport(
  rabbits: RabbitStats.fromJson(json['rabbits'] as Map<String, dynamic>),
  cages: CageStats.fromJson(json['cages'] as Map<String, dynamic>),
  health: HealthStats.fromJson(json['health'] as Map<String, dynamic>),
  finance: json['finance'] == null
      ? null
      : FinanceStats.fromJson(json['finance'] as Map<String, dynamic>),
  tasks: TaskStats.fromJson(json['tasks'] as Map<String, dynamic>),
  inventory: InventoryStats.fromJson(json['inventory'] as Map<String, dynamic>),
  breeding: BreedingStats.fromJson(json['breeding'] as Map<String, dynamic>),
  planUsage: json['plan_usage'] == null
      ? null
      : PlanUsage.fromJson(json['plan_usage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DashboardReportToJson(_DashboardReport instance) =>
    <String, dynamic>{
      'rabbits': instance.rabbits,
      'cages': instance.cages,
      'health': instance.health,
      'finance': instance.finance,
      'tasks': instance.tasks,
      'inventory': instance.inventory,
      'breeding': instance.breeding,
      'plan_usage': instance.planUsage,
    };

_PlanUsage _$PlanUsageFromJson(Map<String, dynamic> json) => _PlanUsage(
  rabbits: ResourceUsage.fromJson(json['rabbits'] as Map<String, dynamic>),
  staff: ResourceUsage.fromJson(json['staff'] as Map<String, dynamic>),
  plan: json['plan'] == null
      ? null
      : PlanUsagePlan.fromJson(json['plan'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlanUsageToJson(_PlanUsage instance) =>
    <String, dynamic>{
      'rabbits': instance.rabbits,
      'staff': instance.staff,
      'plan': instance.plan,
    };

_PlanUsagePlan _$PlanUsagePlanFromJson(Map<String, dynamic> json) =>
    _PlanUsagePlan(
      id: const IntConverter().fromJson(json['id'] as Object),
      name: json['name'] as String,
      price: _$JsonConverterFromJson<Object, double>(
        json['price'],
        const DoubleConverter().fromJson,
      ),
      expiresAt: const NullableDateTimeConverter().fromJson(json['expires_at']),
      isExpired: json['is_expired'] as bool? ?? false,
    );

Map<String, dynamic> _$PlanUsagePlanToJson(
  _PlanUsagePlan instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
  'price': _$JsonConverterToJson<Object, double>(
    instance.price,
    const DoubleConverter().toJson,
  ),
  'expires_at': const NullableDateTimeConverter().toJson(instance.expiresAt),
  'is_expired': instance.isExpired,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_ResourceUsage _$ResourceUsageFromJson(Map<String, dynamic> json) =>
    _ResourceUsage(
      used: const IntConverter().fromJson(json['used'] as Object),
      limit: const NullableIntConverter().fromJson(json['limit']),
    );

Map<String, dynamic> _$ResourceUsageToJson(_ResourceUsage instance) =>
    <String, dynamic>{
      'used': const IntConverter().toJson(instance.used),
      'limit': const NullableIntConverter().toJson(instance.limit),
    };

_RabbitStats _$RabbitStatsFromJson(Map<String, dynamic> json) => _RabbitStats(
  total: const IntConverter().fromJson(json['total'] as Object),
  male: const IntConverter().fromJson(json['male'] as Object),
  female: const IntConverter().fromJson(json['female'] as Object),
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$RabbitStatsToJson(_RabbitStats instance) =>
    <String, dynamic>{
      'total': const IntConverter().toJson(instance.total),
      'male': const IntConverter().toJson(instance.male),
      'female': const IntConverter().toJson(instance.female),
      'history': instance.history,
    };

_CageStats _$CageStatsFromJson(Map<String, dynamic> json) => _CageStats(
  total: const IntConverter().fromJson(json['total'] as Object),
  occupied: const IntConverter().fromJson(json['occupied'] as Object),
  available: const IntConverter().fromJson(json['available'] as Object),
);

Map<String, dynamic> _$CageStatsToJson(_CageStats instance) =>
    <String, dynamic>{
      'total': const IntConverter().toJson(instance.total),
      'occupied': const IntConverter().toJson(instance.occupied),
      'available': const IntConverter().toJson(instance.available),
    };

_HealthStats _$HealthStatsFromJson(Map<String, dynamic> json) => _HealthStats(
  upcomingVaccinations: const IntConverter().fromJson(
    json['upcomingVaccinations'] as Object,
  ),
  overdueVaccinations: const IntConverter().fromJson(
    json['overdueVaccinations'] as Object,
  ),
);

Map<String, dynamic> _$HealthStatsToJson(_HealthStats instance) =>
    <String, dynamic>{
      'upcomingVaccinations': const IntConverter().toJson(
        instance.upcomingVaccinations,
      ),
      'overdueVaccinations': const IntConverter().toJson(
        instance.overdueVaccinations,
      ),
    };

_FinanceStats _$FinanceStatsFromJson(Map<String, dynamic> json) =>
    _FinanceStats(
      income30days: const DoubleConverter().fromJson(
        json['income30days'] as Object,
      ),
      expenses30days: const DoubleConverter().fromJson(
        json['expenses30days'] as Object,
      ),
      profit30days: const DoubleConverter().fromJson(
        json['profit30days'] as Object,
      ),
    );

Map<String, dynamic> _$FinanceStatsToJson(_FinanceStats instance) =>
    <String, dynamic>{
      'income30days': const DoubleConverter().toJson(instance.income30days),
      'expenses30days': const DoubleConverter().toJson(instance.expenses30days),
      'profit30days': const DoubleConverter().toJson(instance.profit30days),
    };

_TaskStats _$TaskStatsFromJson(Map<String, dynamic> json) => _TaskStats(
  pending: const IntConverter().fromJson(json['pending'] as Object),
  overdue: const IntConverter().fromJson(json['overdue'] as Object),
  urgent: const IntConverter().fromJson(json['urgent'] as Object),
);

Map<String, dynamic> _$TaskStatsToJson(_TaskStats instance) =>
    <String, dynamic>{
      'pending': const IntConverter().toJson(instance.pending),
      'overdue': const IntConverter().toJson(instance.overdue),
      'urgent': const IntConverter().toJson(instance.urgent),
    };

_InventoryStats _$InventoryStatsFromJson(Map<String, dynamic> json) =>
    _InventoryStats(
      lowStockFeeds: const IntConverter().fromJson(
        json['lowStockFeeds'] as Object,
      ),
    );

Map<String, dynamic> _$InventoryStatsToJson(_InventoryStats instance) =>
    <String, dynamic>{
      'lowStockFeeds': const IntConverter().toJson(instance.lowStockFeeds),
    };

_BreedingStats _$BreedingStatsFromJson(Map<String, dynamic> json) =>
    _BreedingStats(
      recentBirths: const IntConverter().fromJson(
        json['recentBirths'] as Object,
      ),
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BreedingStatsToJson(_BreedingStats instance) =>
    <String, dynamic>{
      'recentBirths': const IntConverter().toJson(instance.recentBirths),
      'history': instance.history,
    };

_FarmReport _$FarmReportFromJson(Map<String, dynamic> json) => _FarmReport(
  period: ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
  population: PopulationData.fromJson(
    json['population'] as Map<String, dynamic>,
  ),
  financial: json['financial'] == null
      ? null
      : FinancialData.fromJson(json['financial'] as Map<String, dynamic>),
  health: HealthData.fromJson(json['health'] as Map<String, dynamic>),
  breeding: BreedingData.fromJson(json['breeding'] as Map<String, dynamic>),
  feeding: FeedingData.fromJson(json['feeding'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FarmReportToJson(_FarmReport instance) =>
    <String, dynamic>{
      'period': instance.period,
      'population': instance.population,
      'financial': instance.financial,
      'health': instance.health,
      'breeding': instance.breeding,
      'feeding': instance.feeding,
    };

_ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) =>
    _ReportPeriod(from: json['from'] as String, to: json['to'] as String);

Map<String, dynamic> _$ReportPeriodToJson(_ReportPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

_PopulationData _$PopulationDataFromJson(Map<String, dynamic> json) =>
    _PopulationData(
      totalRabbits: const IntConverter().fromJson(
        json['total_rabbits'] as Object,
      ),
      byBreed: (json['by_breed'] as List<dynamic>)
          .map((e) => BreedCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PopulationDataToJson(_PopulationData instance) =>
    <String, dynamic>{
      'total_rabbits': const IntConverter().toJson(instance.totalRabbits),
      'by_breed': instance.byBreed,
    };

_BreedCount _$BreedCountFromJson(Map<String, dynamic> json) => _BreedCount(
  breedId: const IntConverter().fromJson(json['breed_id'] as Object),
  count: const IntConverter().fromJson(json['count'] as Object),
);

Map<String, dynamic> _$BreedCountToJson(_BreedCount instance) =>
    <String, dynamic>{
      'breed_id': const IntConverter().toJson(instance.breedId),
      'count': const IntConverter().toJson(instance.count),
    };

_FinancialData _$FinancialDataFromJson(Map<String, dynamic> json) =>
    _FinancialData(
      transactions: json['transactions'] as List<dynamic>,
      summary: FinancialSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$FinancialDataToJson(_FinancialData instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'summary': instance.summary,
    };

_FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) =>
    _FinancialSummary(
      totalIncome: const DoubleConverter().fromJson(
        json['total_income'] as Object,
      ),
      totalExpenses: const DoubleConverter().fromJson(
        json['total_expenses'] as Object,
      ),
    );

Map<String, dynamic> _$FinancialSummaryToJson(_FinancialSummary instance) =>
    <String, dynamic>{
      'total_income': const DoubleConverter().toJson(instance.totalIncome),
      'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
    };

_HealthData _$HealthDataFromJson(Map<String, dynamic> json) => _HealthData(
  vaccinations: const IntConverter().fromJson(json['vaccinations'] as Object),
  medicalRecords: const IntConverter().fromJson(
    json['medical_records'] as Object,
  ),
);

Map<String, dynamic> _$HealthDataToJson(_HealthData instance) =>
    <String, dynamic>{
      'vaccinations': const IntConverter().toJson(instance.vaccinations),
      'medical_records': const IntConverter().toJson(instance.medicalRecords),
    };

_BreedingData _$BreedingDataFromJson(Map<String, dynamic> json) =>
    _BreedingData(
      breedings: const IntConverter().fromJson(json['breedings'] as Object),
      births: const IntConverter().fromJson(json['births'] as Object),
    );

Map<String, dynamic> _$BreedingDataToJson(_BreedingData instance) =>
    <String, dynamic>{
      'breedings': const IntConverter().toJson(instance.breedings),
      'births': const IntConverter().toJson(instance.births),
    };

_FeedingData _$FeedingDataFromJson(Map<String, dynamic> json) => _FeedingData(
  totalFeedingRecords: const IntConverter().fromJson(
    json['total_feeding_records'] as Object,
  ),
  consumptionByUnit:
      (json['consumption_by_unit'] as List<dynamic>?)
          ?.map((e) => FeedConsumption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FeedingDataToJson(_FeedingData instance) =>
    <String, dynamic>{
      'total_feeding_records': const IntConverter().toJson(
        instance.totalFeedingRecords,
      ),
      'consumption_by_unit': instance.consumptionByUnit,
    };

_FeedConsumption _$FeedConsumptionFromJson(Map<String, dynamic> json) =>
    _FeedConsumption(
      unit: json['unit'] as String,
      total: const DoubleConverter().fromJson(json['total'] as Object),
    );

Map<String, dynamic> _$FeedConsumptionToJson(_FeedConsumption instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'total': const DoubleConverter().toJson(instance.total),
    };

_HealthReport _$HealthReportFromJson(Map<String, dynamic> json) =>
    _HealthReport(
      vaccinations: VaccinationsData.fromJson(
        json['vaccinations'] as Map<String, dynamic>,
      ),
      medicalRecords: MedicalRecordsData.fromJson(
        json['medical_records'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$HealthReportToJson(_HealthReport instance) =>
    <String, dynamic>{
      'vaccinations': instance.vaccinations,
      'medical_records': instance.medicalRecords,
    };

_VaccinationsData _$VaccinationsDataFromJson(Map<String, dynamic> json) =>
    _VaccinationsData(
      byType: (json['by_type'] as List<dynamic>)
          .map((e) => VaccineTypeCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      upcoming: json['upcoming'] as List<dynamic>,
    );

Map<String, dynamic> _$VaccinationsDataToJson(_VaccinationsData instance) =>
    <String, dynamic>{
      'by_type': instance.byType,
      'upcoming': instance.upcoming,
    };

_VaccineTypeCount _$VaccineTypeCountFromJson(Map<String, dynamic> json) =>
    _VaccineTypeCount(
      vaccineName: json['vaccine_name'] as String,
      count: const IntConverter().fromJson(json['count'] as Object),
    );

Map<String, dynamic> _$VaccineTypeCountToJson(_VaccineTypeCount instance) =>
    <String, dynamic>{
      'vaccine_name': instance.vaccineName,
      'count': const IntConverter().toJson(instance.count),
    };

_MedicalRecordsData _$MedicalRecordsDataFromJson(Map<String, dynamic> json) =>
    _MedicalRecordsData(
      byOutcome:
          (json['by_outcome'] as List<dynamic>?)
              ?.map(
                (e) => RecordOutcomeCount.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MedicalRecordsDataToJson(_MedicalRecordsData instance) =>
    <String, dynamic>{'by_outcome': instance.byOutcome};

_RecordOutcomeCount _$RecordOutcomeCountFromJson(Map<String, dynamic> json) =>
    _RecordOutcomeCount(
      outcome: json['outcome'] as String?,
      count: const IntConverter().fromJson(json['count'] as Object),
    );

Map<String, dynamic> _$RecordOutcomeCountToJson(_RecordOutcomeCount instance) =>
    <String, dynamic>{
      'outcome': instance.outcome,
      'count': const IntConverter().toJson(instance.count),
    };

_FinancialReport _$FinancialReportFromJson(Map<String, dynamic> json) =>
    _FinancialReport(
      summary: FinancialReportSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      byCategory: (json['by_category'] as List<dynamic>)
          .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FinancialReportToJson(_FinancialReport instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'by_category': instance.byCategory,
    };

_FinancialReportSummary _$FinancialReportSummaryFromJson(
  Map<String, dynamic> json,
) => _FinancialReportSummary(
  totalIncome: const DoubleConverter().fromJson(json['total_income'] as Object),
  totalExpenses: const DoubleConverter().fromJson(
    json['total_expenses'] as Object,
  ),
  netProfit: const DoubleConverter().fromJson(json['net_profit'] as Object),
);

Map<String, dynamic> _$FinancialReportSummaryToJson(
  _FinancialReportSummary instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
};

_CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) =>
    _CategoryData(
      type: json['type'] as String,
      category: json['category'] as String,
      total: const DoubleConverter().fromJson(json['total'] as Object),
      count: const IntConverter().fromJson(json['count'] as Object),
    );

Map<String, dynamic> _$CategoryDataToJson(_CategoryData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'category': instance.category,
      'total': const DoubleConverter().toJson(instance.total),
      'count': const IntConverter().toJson(instance.count),
    };
