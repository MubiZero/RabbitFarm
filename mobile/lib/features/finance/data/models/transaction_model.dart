import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../rabbits/data/models/rabbit_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Transaction Type enum
enum TransactionType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense,
}

/// Transaction Category enum
enum TransactionCategory {
  // Income categories
  @JsonValue('sale_rabbit')
  saleRabbit,
  @JsonValue('sale_meat')
  saleMeat,
  @JsonValue('sale_fur')
  saleFur,
  @JsonValue('breeding_fee')
  breedingFee,

  // Expense categories
  @JsonValue('feed')
  feed,
  @JsonValue('veterinary')
  veterinary,
  @JsonValue('equipment')
  equipment,
  @JsonValue('utilities')
  utilities,
  @JsonValue('other')
  other,
}

/// Helper to check if category is income
extension TransactionCategoryExtension on TransactionCategory {
  bool get isIncome {
    return this == TransactionCategory.saleRabbit ||
        this == TransactionCategory.saleMeat ||
        this == TransactionCategory.saleFur ||
        this == TransactionCategory.breedingFee;
  }

  bool get isExpense {
    return !isIncome;
  }
}

/// Custom converter for int values that might come as strings
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot convert $value to int');
  }

  @override
  int toJson(int value) => value;
}

/// Custom converter for double values that might come as strings
class DoubleConverter implements JsonConverter<double, dynamic> {
  const DoubleConverter();

  @override
  double fromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    throw ArgumentError('Cannot convert $value to double');
  }

  @override
  double toJson(double value) => value;
}

/// Transaction model
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @IntConverter() required int id,
    required TransactionType type,
    required TransactionCategory category,
    @DoubleConverter() required double amount,
    @JsonKey(name: 'transaction_date') required DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @IntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'created_by') @IntConverter() int? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Relationships (not included in JSON serialization by default)
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

/// Transaction create model
@freezed
class TransactionCreate with _$TransactionCreate {
  const factory TransactionCreate({
    required TransactionType type,
    required TransactionCategory category,
    required double amount,
    @JsonKey(name: 'transaction_date') required DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  }) = _TransactionCreate;

  factory TransactionCreate.fromJson(Map<String, dynamic> json) =>
      _$TransactionCreateFromJson(json);
}

/// Transaction update model
@freezed
class TransactionUpdate with _$TransactionUpdate {
  const factory TransactionUpdate({
    TransactionType? type,
    TransactionCategory? category,
    double? amount,
    @JsonKey(name: 'transaction_date') DateTime? transactionDate,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  }) = _TransactionUpdate;

  factory TransactionUpdate.fromJson(Map<String, dynamic> json) =>
      _$TransactionUpdateFromJson(json);
}

/// Financial statistics model
@freezed
class FinancialStatistics with _$FinancialStatistics {
  const factory FinancialStatistics({
    @JsonKey(name: 'total_income') @DoubleConverter() required double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() required double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required double netProfit,
    @JsonKey(name: 'total_transactions') @IntConverter() required int totalTransactions,
    @JsonKey(name: 'income_by_category') required List<CategoryStatistics> incomeByCategory,
    @JsonKey(name: 'expenses_by_category') required List<CategoryStatistics> expensesByCategory,
    @JsonKey(name: 'recent_transactions') required List<Transaction> recentTransactions,
  }) = _FinancialStatistics;

  factory FinancialStatistics.fromJson(Map<String, dynamic> json) =>
      _$FinancialStatisticsFromJson(json);
}

/// Category statistics model
@freezed
class CategoryStatistics with _$CategoryStatistics {
  const factory CategoryStatistics({
    required TransactionCategory category,
    @DoubleConverter() required double total,
    @IntConverter() required int count,
  }) = _CategoryStatistics;

  factory CategoryStatistics.fromJson(Map<String, dynamic> json) =>
      _$CategoryStatisticsFromJson(json);
}

/// Monthly report model
@freezed
class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required ReportPeriod period,
    required ReportSummary summary,
    required List<Transaction> transactions,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}

/// Report period model
@freezed
class ReportPeriod with _$ReportPeriod {
  const factory ReportPeriod({
    @IntConverter() required int year,
    @IntConverter() required int month,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
  }) = _ReportPeriod;

  factory ReportPeriod.fromJson(Map<String, dynamic> json) =>
      _$ReportPeriodFromJson(json);
}

/// Report summary model
@freezed
class ReportSummary with _$ReportSummary {
  const factory ReportSummary({
    @JsonKey(name: 'total_income') @DoubleConverter() required double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() required double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required double netProfit,
    @JsonKey(name: 'transaction_count') @IntConverter() required int transactionCount,
  }) = _ReportSummary;

  factory ReportSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryFromJson(json);
}

/// Rabbit transactions summary model
@freezed
class RabbitTransactionsSummary with _$RabbitTransactionsSummary {
  const factory RabbitTransactionsSummary({
    required List<Transaction> transactions,
    required TransactionSummary summary,
  }) = _RabbitTransactionsSummary;

  factory RabbitTransactionsSummary.fromJson(Map<String, dynamic> json) =>
      _$RabbitTransactionsSummaryFromJson(json);
}

/// Transaction summary model
@freezed
class TransactionSummary with _$TransactionSummary {
  const factory TransactionSummary({
    @JsonKey(name: 'total_income') @DoubleConverter() required double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() required double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required double netProfit,
  }) = _TransactionSummary;

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryFromJson(json);
}
