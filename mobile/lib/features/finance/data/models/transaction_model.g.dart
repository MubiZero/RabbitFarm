// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: const IntConverter().fromJson(json['id'] as Object),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
  amount: const DoubleConverter().fromJson(json['amount'] as Object),
  transactionDate: const DateOnlyConverter().fromJson(
    json['transaction_date'] as Object,
  ),
  rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
  description: json['description'] as String?,
  receiptUrl: json['receipt_url'] as String?,
  createdBy: const NullableIntConverter().fromJson(json['created_by']),
  createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updated_at']),
  rabbit: json['rabbit'] == null
      ? null
      : RabbitRef.fromJson(json['rabbit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionToJson(
  _Transaction instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'category': _$TransactionCategoryEnumMap[instance.category]!,
  'amount': const DoubleConverter().toJson(instance.amount),
  'transaction_date': const DateOnlyConverter().toJson(
    instance.transactionDate,
  ),
  'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
  'description': instance.description,
  'receipt_url': instance.receiptUrl,
  'created_by': const NullableIntConverter().toJson(instance.createdBy),
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const NullableDateTimeConverter().toJson(instance.updatedAt),
  'rabbit': instance.rabbit,
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

_TransactionCreate _$TransactionCreateFromJson(Map<String, dynamic> json) =>
    _TransactionCreate(
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      amount: (json['amount'] as num).toDouble(),
      transactionDate: const DateOnlyConverter().fromJson(
        json['transaction_date'] as Object,
      ),
      rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
      description: json['description'] as String?,
      receiptUrl: json['receipt_url'] as String?,
    );

Map<String, dynamic> _$TransactionCreateToJson(_TransactionCreate instance) =>
    <String, dynamic>{
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'amount': instance.amount,
      'transaction_date': const DateOnlyConverter().toJson(
        instance.transactionDate,
      ),
      'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
      'description': instance.description,
      'receipt_url': instance.receiptUrl,
    };

_TransactionUpdate _$TransactionUpdateFromJson(Map<String, dynamic> json) =>
    _TransactionUpdate(
      type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
      category: $enumDecodeNullable(
        _$TransactionCategoryEnumMap,
        json['category'],
      ),
      amount: (json['amount'] as num?)?.toDouble(),
      transactionDate: const NullableDateOnlyConverter().fromJson(
        json['transaction_date'],
      ),
      rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
      description: json['description'] as String?,
      receiptUrl: json['receipt_url'] as String?,
    );

Map<String, dynamic> _$TransactionUpdateToJson(_TransactionUpdate instance) =>
    <String, dynamic>{
      'type': _$TransactionTypeEnumMap[instance.type],
      'category': _$TransactionCategoryEnumMap[instance.category],
      'amount': instance.amount,
      'transaction_date': const NullableDateOnlyConverter().toJson(
        instance.transactionDate,
      ),
      'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
      'description': instance.description,
      'receipt_url': instance.receiptUrl,
    };

_FinancialStatistics _$FinancialStatisticsFromJson(Map<String, dynamic> json) =>
    _FinancialStatistics(
      totalIncome: const DoubleConverter().fromJson(
        json['total_income'] as Object,
      ),
      totalExpenses: const DoubleConverter().fromJson(
        json['total_expenses'] as Object,
      ),
      netProfit: const DoubleConverter().fromJson(json['net_profit'] as Object),
      totalTransactions: const IntConverter().fromJson(
        json['total_transactions'] as Object,
      ),
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

Map<String, dynamic> _$FinancialStatisticsToJson(
  _FinancialStatistics instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
  'total_transactions': const IntConverter().toJson(instance.totalTransactions),
  'income_by_category': instance.incomeByCategory,
  'expenses_by_category': instance.expensesByCategory,
  'recent_transactions': instance.recentTransactions,
};

_CategoryStatistics _$CategoryStatisticsFromJson(Map<String, dynamic> json) =>
    _CategoryStatistics(
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      total: const DoubleConverter().fromJson(json['total'] as Object),
      count: const IntConverter().fromJson(json['count'] as Object),
    );

Map<String, dynamic> _$CategoryStatisticsToJson(_CategoryStatistics instance) =>
    <String, dynamic>{
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'total': const DoubleConverter().toJson(instance.total),
      'count': const IntConverter().toJson(instance.count),
    };

_MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) =>
    _MonthlyReport(
      period: ReportPeriod.fromJson(json['period'] as Map<String, dynamic>),
      summary: ReportSummary.fromJson(json['summary'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonthlyReportToJson(_MonthlyReport instance) =>
    <String, dynamic>{
      'period': instance.period,
      'summary': instance.summary,
      'transactions': instance.transactions,
    };

_ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) =>
    _ReportPeriod(
      year: const IntConverter().fromJson(json['year'] as Object),
      month: const IntConverter().fromJson(json['month'] as Object),
      startDate: const DateOnlyConverter().fromJson(
        json['start_date'] as Object,
      ),
      endDate: const DateOnlyConverter().fromJson(json['end_date'] as Object),
    );

Map<String, dynamic> _$ReportPeriodToJson(_ReportPeriod instance) =>
    <String, dynamic>{
      'year': const IntConverter().toJson(instance.year),
      'month': const IntConverter().toJson(instance.month),
      'start_date': const DateOnlyConverter().toJson(instance.startDate),
      'end_date': const DateOnlyConverter().toJson(instance.endDate),
    };

_ReportSummary _$ReportSummaryFromJson(Map<String, dynamic> json) =>
    _ReportSummary(
      totalIncome: const DoubleConverter().fromJson(
        json['total_income'] as Object,
      ),
      totalExpenses: const DoubleConverter().fromJson(
        json['total_expenses'] as Object,
      ),
      netProfit: const DoubleConverter().fromJson(json['net_profit'] as Object),
      transactionCount: const IntConverter().fromJson(
        json['transaction_count'] as Object,
      ),
    );

Map<String, dynamic> _$ReportSummaryToJson(
  _ReportSummary instance,
) => <String, dynamic>{
  'total_income': const DoubleConverter().toJson(instance.totalIncome),
  'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
  'net_profit': const DoubleConverter().toJson(instance.netProfit),
  'transaction_count': const IntConverter().toJson(instance.transactionCount),
};

_RabbitTransactionsSummary _$RabbitTransactionsSummaryFromJson(
  Map<String, dynamic> json,
) => _RabbitTransactionsSummary(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: TransactionSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RabbitTransactionsSummaryToJson(
  _RabbitTransactionsSummary instance,
) => <String, dynamic>{
  'transactions': instance.transactions,
  'summary': instance.summary,
};

_TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) =>
    _TransactionSummary(
      totalIncome: const DoubleConverter().fromJson(
        json['total_income'] as Object,
      ),
      totalExpenses: const DoubleConverter().fromJson(
        json['total_expenses'] as Object,
      ),
      netProfit: const DoubleConverter().fromJson(json['net_profit'] as Object),
    );

Map<String, dynamic> _$TransactionSummaryToJson(_TransactionSummary instance) =>
    <String, dynamic>{
      'total_income': const DoubleConverter().toJson(instance.totalIncome),
      'total_expenses': const DoubleConverter().toJson(instance.totalExpenses),
      'net_profit': const DoubleConverter().toJson(instance.netProfit),
    };
