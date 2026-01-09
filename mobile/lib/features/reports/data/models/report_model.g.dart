// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardReportImpl _$$DashboardReportImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardReportImpl(
  rabbits: RabbitStats.fromJson(json['rabbits'] as Map<String, dynamic>),
  cages: CageStats.fromJson(json['cages'] as Map<String, dynamic>),
  health: HealthStats.fromJson(json['health'] as Map<String, dynamic>),
  finance: FinanceStats.fromJson(json['finance'] as Map<String, dynamic>),
  tasks: TaskStats.fromJson(json['tasks'] as Map<String, dynamic>),
  inventory: InventoryStats.fromJson(json['inventory'] as Map<String, dynamic>),
  breeding: BreedingStats.fromJson(json['breeding'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DashboardReportImplToJson(
  _$DashboardReportImpl instance,
) => <String, dynamic>{
  'rabbits': instance.rabbits,
  'cages': instance.cages,
  'health': instance.health,
  'finance': instance.finance,
  'tasks': instance.tasks,
  'inventory': instance.inventory,
  'breeding': instance.breeding,
};

_$RabbitStatsImpl _$$RabbitStatsImplFromJson(Map<String, dynamic> json) =>
    _$RabbitStatsImpl(
      total: const IntConverter().fromJson(json['total']),
      male: const IntConverter().fromJson(json['male']),
      female: const IntConverter().fromJson(json['female']),
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RabbitStatsImplToJson(_$RabbitStatsImpl instance) =>
    <String, dynamic>{
      'total': const IntConverter().toJson(instance.total),
      'male': const IntConverter().toJson(instance.male),
      'female': const IntConverter().toJson(instance.female),
      'history': instance.history,
    };

_$CageStatsImpl _$$CageStatsImplFromJson(Map<String, dynamic> json) =>
    _$CageStatsImpl(
      total: const IntConverter().fromJson(json['total']),
      occupied: const IntConverter().fromJson(json['occupied']),
      available: const IntConverter().fromJson(json['available']),
    );

Map<String, dynamic> _$$CageStatsImplToJson(_$CageStatsImpl instance) =>
    <String, dynamic>{
      'total': const IntConverter().toJson(instance.total),
      'occupied': const IntConverter().toJson(instance.occupied),
      'available': const IntConverter().toJson(instance.available),
    };

_$HealthStatsImpl _$$HealthStatsImplFromJson(Map<String, dynamic> json) =>
    _$HealthStatsImpl(
      upcomingVaccinations: const IntConverter().fromJson(
        json['upcomingVaccinations'],
      ),
      overdueVaccinations: const IntConverter().fromJson(
        json['overdueVaccinations'],
      ),
    );

Map<String, dynamic> _$$HealthStatsImplToJson(_$HealthStatsImpl instance) =>
    <String, dynamic>{
      'upcomingVaccinations': const IntConverter().toJson(
        instance.upcomingVaccinations,
      ),
      'overdueVaccinations': const IntConverter().toJson(
        instance.overdueVaccinations,
      ),
    };

_$FinanceStatsImpl _$$FinanceStatsImplFromJson(Map<String, dynamic> json) =>
    _$FinanceStatsImpl(
      income30days: const DoubleConverter().fromJson(json['income30days']),
      expenses30days: const DoubleConverter().fromJson(json['expenses30days']),
      profit30days: const DoubleConverter().fromJson(json['profit30days']),
    );

Map<String, dynamic> _$$FinanceStatsImplToJson(_$FinanceStatsImpl instance) =>
    <String, dynamic>{
      'income30days': const DoubleConverter().toJson(instance.income30days),
      'expenses30days': const DoubleConverter().toJson(instance.expenses30days),
      'profit30days': const DoubleConverter().toJson(instance.profit30days),
    };

_$TaskStatsImpl _$$TaskStatsImplFromJson(Map<String, dynamic> json) =>
    _$TaskStatsImpl(
      pending: const IntConverter().fromJson(json['pending']),
      overdue: const IntConverter().fromJson(json['overdue']),
      urgent: const IntConverter().fromJson(json['urgent']),
    );

Map<String, dynamic> _$$TaskStatsImplToJson(_$TaskStatsImpl instance) =>
    <String, dynamic>{
      'pending': const IntConverter().toJson(instance.pending),
      'overdue': const IntConverter().toJson(instance.overdue),
      'urgent': const IntConverter().toJson(instance.urgent),
    };

_$InventoryStatsImpl _$$InventoryStatsImplFromJson(Map<String, dynamic> json) =>
    _$InventoryStatsImpl(
      lowStockFeeds: const IntConverter().fromJson(json['lowStockFeeds']),
    );

Map<String, dynamic> _$$InventoryStatsImplToJson(
  _$InventoryStatsImpl instance,
) => <String, dynamic>{
  'lowStockFeeds': const IntConverter().toJson(instance.lowStockFeeds),
};

_$BreedingStatsImpl _$$BreedingStatsImplFromJson(Map<String, dynamic> json) =>
    _$BreedingStatsImpl(
      recentBirths: const IntConverter().fromJson(json['recentBirths']),
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BreedingStatsImplToJson(_$BreedingStatsImpl instance) =>
    <String, dynamic>{
      'recentBirths': const IntConverter().toJson(instance.recentBirths),
      'history': instance.history,
    };

_$FarmReportImpl _$$FarmReportImplFromJson(Map<String, dynamic> json) =>
    _$FarmReportImpl(
      period: ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
      population: PopulationData.fromJson(
        json['population'] as Map<String, dynamic>,
      ),
      financial: FinancialData.fromJson(
        json['financial'] as Map<String, dynamic>,
      ),
      health: HealthData.fromJson(json['health'] as Map<String, dynamic>),
      breeding: BreedingData.fromJson(json['breeding'] as Map<String, dynamic>),
      feeding: FeedingData.fromJson(json['feeding'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FarmReportImplToJson(_$FarmReportImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'population': instance.population,
      'financial': instance.financial,
      'health': instance.health,
      'breeding': instance.breeding,
      'feeding': instance.feeding,
    };

_$ReportPeriodImpl _$$ReportPeriodImplFromJson(Map<String, dynamic> json) =>
    _$ReportPeriodImpl(from: json['from'] as String, to: json['to'] as String);

Map<String, dynamic> _$$ReportPeriodImplToJson(_$ReportPeriodImpl instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

_$PopulationDataImpl _$$PopulationDataImplFromJson(Map<String, dynamic> json) =>
    _$PopulationDataImpl(
      totalRabbits: const IntConverter().fromJson(json['total_rabbits']),
      byBreed: (json['by_breed'] as List<dynamic>)
          .map((e) => BreedCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PopulationDataImplToJson(
  _$PopulationDataImpl instance,
) => <String, dynamic>{
  'total_rabbits': const IntConverter().toJson(instance.totalRabbits),
  'by_breed': instance.byBreed,
};

_$BreedCountImpl _$$BreedCountImplFromJson(Map<String, dynamic> json) =>
    _$BreedCountImpl(
      breedId: const IntConverter().fromJson(json['breed_id']),
      count: const IntConverter().fromJson(json['count']),
    );

Map<String, dynamic> _$$BreedCountImplToJson(_$BreedCountImpl instance) =>
    <String, dynamic>{
      'breed_id': const IntConverter().toJson(instance.breedId),
      'count': const IntConverter().toJson(instance.count),
    };

_$FinancialDataImpl _$$FinancialDataImplFromJson(Map<String, dynamic> json) =>
    _$FinancialDataImpl(
      transactions: json['transactions'] as List<dynamic>,
      summary: FinancialSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$FinancialDataImplToJson(_$FinancialDataImpl instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'summary': instance.summary,
    };

_$FinancialSummaryImpl _$$FinancialSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialSummaryImpl(
  totalIncome: const DoubleConverter().fromJson(json['total_income']),
  totalExpenses: const DoubleConverter().fromJson(json['total_expenses']),
);

Map<String, dynamic> _$$FinancialSummaryImplToJson(
  _$FinancialSummaryImpl instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
};

_$HealthDataImpl _$$HealthDataImplFromJson(Map<String, dynamic> json) =>
    _$HealthDataImpl(
      vaccinations: const IntConverter().fromJson(json['vaccinations']),
      medicalRecords: const IntConverter().fromJson(json['medical_records']),
    );

Map<String, dynamic> _$$HealthDataImplToJson(_$HealthDataImpl instance) =>
    <String, dynamic>{
      'vaccinations': const IntConverter().toJson(instance.vaccinations),
      'medical_records': const IntConverter().toJson(instance.medicalRecords),
    };

_$BreedingDataImpl _$$BreedingDataImplFromJson(Map<String, dynamic> json) =>
    _$BreedingDataImpl(
      breedings: const IntConverter().fromJson(json['breedings']),
      births: const IntConverter().fromJson(json['births']),
    );

Map<String, dynamic> _$$BreedingDataImplToJson(_$BreedingDataImpl instance) =>
    <String, dynamic>{
      'breedings': const IntConverter().toJson(instance.breedings),
      'births': const IntConverter().toJson(instance.births),
    };

_$FeedingDataImpl _$$FeedingDataImplFromJson(Map<String, dynamic> json) =>
    _$FeedingDataImpl(
      totalFeedingRecords: const IntConverter().fromJson(
        json['total_feeding_records'],
      ),
      totalFeedConsumption: const DoubleConverter().fromJson(
        json['total_feed_consumption'],
      ),
    );

Map<String, dynamic> _$$FeedingDataImplToJson(_$FeedingDataImpl instance) =>
    <String, dynamic>{
      'total_feeding_records': const IntConverter().toJson(
        instance.totalFeedingRecords,
      ),
      'total_feed_consumption': const DoubleConverter().toJson(
        instance.totalFeedConsumption,
      ),
    };

_$HealthReportImpl _$$HealthReportImplFromJson(Map<String, dynamic> json) =>
    _$HealthReportImpl(
      vaccinations: VaccinationsData.fromJson(
        json['vaccinations'] as Map<String, dynamic>,
      ),
      medicalRecords: MedicalRecordsData.fromJson(
        json['medical_records'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$HealthReportImplToJson(_$HealthReportImpl instance) =>
    <String, dynamic>{
      'vaccinations': instance.vaccinations,
      'medical_records': instance.medicalRecords,
    };

_$VaccinationsDataImpl _$$VaccinationsDataImplFromJson(
  Map<String, dynamic> json,
) => _$VaccinationsDataImpl(
  byType: (json['by_type'] as List<dynamic>)
      .map((e) => VaccineTypeCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  upcoming: json['upcoming'] as List<dynamic>,
);

Map<String, dynamic> _$$VaccinationsDataImplToJson(
  _$VaccinationsDataImpl instance,
) => <String, dynamic>{
  'by_type': instance.byType,
  'upcoming': instance.upcoming,
};

_$VaccineTypeCountImpl _$$VaccineTypeCountImplFromJson(
  Map<String, dynamic> json,
) => _$VaccineTypeCountImpl(
  vaccineName: json['vaccine_name'] as String,
  count: const IntConverter().fromJson(json['count']),
);

Map<String, dynamic> _$$VaccineTypeCountImplToJson(
  _$VaccineTypeCountImpl instance,
) => <String, dynamic>{
  'vaccine_name': instance.vaccineName,
  'count': const IntConverter().toJson(instance.count),
};

_$MedicalRecordsDataImpl _$$MedicalRecordsDataImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalRecordsDataImpl(
  byType: (json['by_type'] as List<dynamic>)
      .map((e) => RecordTypeCount.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MedicalRecordsDataImplToJson(
  _$MedicalRecordsDataImpl instance,
) => <String, dynamic>{'by_type': instance.byType};

_$RecordTypeCountImpl _$$RecordTypeCountImplFromJson(
  Map<String, dynamic> json,
) => _$RecordTypeCountImpl(
  recordType: json['record_type'] as String,
  count: const IntConverter().fromJson(json['count']),
);

Map<String, dynamic> _$$RecordTypeCountImplToJson(
  _$RecordTypeCountImpl instance,
) => <String, dynamic>{
  'record_type': instance.recordType,
  'count': const IntConverter().toJson(instance.count),
};

_$FinancialReportImpl _$$FinancialReportImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialReportImpl(
  summary: FinancialReportSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  byCategory: (json['by_category'] as List<dynamic>)
      .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$FinancialReportImplToJson(
  _$FinancialReportImpl instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'by_category': instance.byCategory,
};

_$FinancialReportSummaryImpl _$$FinancialReportSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialReportSummaryImpl(
  totalIncome: const DoubleConverter().fromJson(json['total_income']),
  totalExpenses: const DoubleConverter().fromJson(json['total_expenses']),
  netProfit: const DoubleConverter().fromJson(json['net_profit']),
);

Map<String, dynamic> _$$FinancialReportSummaryImplToJson(
  _$FinancialReportSummaryImpl instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
};

_$CategoryDataImpl _$$CategoryDataImplFromJson(Map<String, dynamic> json) =>
    _$CategoryDataImpl(
      type: json['type'] as String,
      category: json['category'] as String,
      total: const DoubleConverter().fromJson(json['total']),
      count: const IntConverter().fromJson(json['count']),
    );

Map<String, dynamic> _$$CategoryDataImplToJson(_$CategoryDataImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'category': instance.category,
      'total': const DoubleConverter().toJson(instance.total),
      'count': const IntConverter().toJson(instance.count),
    };
