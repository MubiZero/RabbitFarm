// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: const IntConverter().fromJson(json['id']),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      amount: const DoubleConverter().fromJson(json['amount']),
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
      description: json['description'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      createdBy: const NullableIntConverter().fromJson(json['created_by']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'amount': const DoubleConverter().toJson(instance.amount),
      'transaction_date': instance.transactionDate.toIso8601String(),
      'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
      'description': instance.description,
      'receipt_url': instance.receiptUrl,
      'created_by': const NullableIntConverter().toJson(instance.createdBy),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};

const _$TransactionCategoryEnumMap = {
  TransactionCategory.saleRabbit: 'sale_rabbit',
  TransactionCategory.saleMeat: 'sale_meat',
  TransactionCategory.saleFur: 'sale_fur',
  TransactionCategory.breedingFee: 'breeding_fee',
  TransactionCategory.feed: 'feed',
  TransactionCategory.veterinary: 'veterinary',
  TransactionCategory.equipment: 'equipment',
  TransactionCategory.utilities: 'utilities',
  TransactionCategory.other: 'other',
};

_$TransactionCreateImpl _$$TransactionCreateImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionCreateImpl(
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
  amount: (json['amount'] as num).toDouble(),
  transactionDate: DateTime.parse(json['transaction_date'] as String),
  rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
  description: json['description'] as String?,
  receiptUrl: json['receipt_url'] as String?,
);

Map<String, dynamic> _$$TransactionCreateImplToJson(
  _$TransactionCreateImpl instance,
) => <String, dynamic>{
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'category': _$TransactionCategoryEnumMap[instance.category]!,
  'amount': instance.amount,
  'transaction_date': instance.transactionDate.toIso8601String(),
  'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
  'description': instance.description,
  'receipt_url': instance.receiptUrl,
};

_$TransactionUpdateImpl _$$TransactionUpdateImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionUpdateImpl(
  type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
  category: $enumDecodeNullable(_$TransactionCategoryEnumMap, json['category']),
  amount: (json['amount'] as num?)?.toDouble(),
  transactionDate: json['transaction_date'] == null
      ? null
      : DateTime.parse(json['transaction_date'] as String),
  rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
  description: json['description'] as String?,
  receiptUrl: json['receipt_url'] as String?,
);

Map<String, dynamic> _$$TransactionUpdateImplToJson(
  _$TransactionUpdateImpl instance,
) => <String, dynamic>{
  'type': _$TransactionTypeEnumMap[instance.type],
  'category': _$TransactionCategoryEnumMap[instance.category],
  'amount': instance.amount,
  'transaction_date': instance.transactionDate?.toIso8601String(),
  'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
  'description': instance.description,
  'receipt_url': instance.receiptUrl,
};

_$FinancialStatisticsImpl _$$FinancialStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialStatisticsImpl(
  totalIncome: const DoubleConverter().fromJson(json['total_income']),
  totalExpenses: const DoubleConverter().fromJson(json['total_expenses']),
  netProfit: const DoubleConverter().fromJson(json['net_profit']),
  totalTransactions: const IntConverter().fromJson(json['total_transactions']),
  incomeByCategory: (json['income_by_category'] as List<dynamic>)
      .map((e) => CategoryStatistics.fromJson(e as Map<String, dynamic>))
      .toList(),
  expensesByCategory: (json['expenses_by_category'] as List<dynamic>)
      .map((e) => CategoryStatistics.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentTransactions: (json['recent_transactions'] as List<dynamic>)
      .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$FinancialStatisticsImplToJson(
  _$FinancialStatisticsImpl instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
  'total_transactions': const IntConverter().toJson(instance.totalTransactions),
  'income_by_category': instance.incomeByCategory,
  'expenses_by_category': instance.expensesByCategory,
  'recent_transactions': instance.recentTransactions,
};

_$CategoryStatisticsImpl _$$CategoryStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryStatisticsImpl(
  category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
  total: const DoubleConverter().fromJson(json['total']),
  count: const IntConverter().fromJson(json['count']),
);

Map<String, dynamic> _$$CategoryStatisticsImplToJson(
  _$CategoryStatisticsImpl instance,
) => <String, dynamic>{
  'category': _$TransactionCategoryEnumMap[instance.category]!,
  'total': const DoubleConverter().toJson(instance.total),
  'count': const IntConverter().toJson(instance.count),
};

_$MonthlyReportImpl _$$MonthlyReportImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyReportImpl(
      period: ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
      summary: ReportSummary.fromJson(json['summary'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MonthlyReportImplToJson(_$MonthlyReportImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'summary': instance.summary,
      'transactions': instance.transactions,
    };

_$ReportPeriodImpl _$$ReportPeriodImplFromJson(Map<String, dynamic> json) =>
    _$ReportPeriodImpl(
      year: const IntConverter().fromJson(json['year']),
      month: const IntConverter().fromJson(json['month']),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$$ReportPeriodImplToJson(_$ReportPeriodImpl instance) =>
    <String, dynamic>{
      'year': const IntConverter().toJson(instance.year),
      'month': const IntConverter().toJson(instance.month),
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };

_$ReportSummaryImpl _$$ReportSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ReportSummaryImpl(
      totalIncome: const DoubleConverter().fromJson(json['total_income']),
      totalExpenses: const DoubleConverter().fromJson(json['total_expenses']),
      netProfit: const DoubleConverter().fromJson(json['net_profit']),
      transactionCount: const IntConverter().fromJson(
        json['transaction_count'],
      ),
    );

Map<String, dynamic> _$$ReportSummaryImplToJson(
  _$ReportSummaryImpl instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
  'transaction_count': const IntConverter().toJson(instance.transactionCount),
};

_$RabbitTransactionsSummaryImpl _$$RabbitTransactionsSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$RabbitTransactionsSummaryImpl(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: TransactionSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RabbitTransactionsSummaryImplToJson(
  _$RabbitTransactionsSummaryImpl instance,
) => <String, dynamic>{
  'transactions': instance.transactions,
  'summary': instance.summary,
};

_$TransactionSummaryImpl _$$TransactionSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionSummaryImpl(
  totalIncome: const DoubleConverter().fromJson(json['total_income']),
  totalExpenses: const DoubleConverter().fromJson(json['total_expenses']),
  netProfit: const DoubleConverter().fromJson(json['net_profit']),
);

Map<String, dynamic> _$$TransactionSummaryImplToJson(
  _$TransactionSummaryImpl instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
};
