import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/transaction_model.dart';

/// Repository for financial transactions operations
class TransactionsRepository {
  final ApiClient _apiClient;

  TransactionsRepository(this._apiClient);

  /// Get list of transactions with optional filters
  Future<List<Transaction>> getTransactions({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    TransactionType? type,
    TransactionCategory? category,
    int? rabbitId,
    DateTime? fromDate,
    DateTime? toDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      if (type != null) queryParams['type'] = _transactionTypeToString(type);
      if (category != null) {
        queryParams['category'] = _transactionCategoryToString(category);
      }
      if (rabbitId != null) queryParams['rabbit_id'] = rabbitId;
      if (fromDate != null) {
        queryParams['from_date'] = fromDate.toIso8601String().split('T')[0];
      }
      if (toDate != null) {
        queryParams['to_date'] = toDate.toIso8601String().split('T')[0];
      }
      if (minAmount != null) queryParams['min_amount'] = minAmount;
      if (maxAmount != null) queryParams['max_amount'] = maxAmount;

      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}/transactions',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data.containsKey('transactions')) {
          // Paginated response
          final List<dynamic> transactions = data['transactions'];
          return transactions.map((json) => Transaction.fromJson(json)).toList();
        } else if (data is List) {
          // Direct list response
          return data.map((json) => Transaction.fromJson(json)).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
          'Failed to get transactions: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get transaction by ID
  Future<Transaction> getTransactionById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}/transactions/$id',
      );

      if (response.data['success'] == true) {
        return Transaction.fromJson(response.data['data']);
      }

      throw Exception('Failed to get transaction');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get transaction: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get transactions for specific rabbit
  Future<RabbitTransactionsSummary> getRabbitTransactions(int rabbitId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}/rabbits/$rabbitId/transactions',
      );

      if (response.data['success'] == true) {
        return RabbitTransactionsSummary.fromJson(response.data['data']);
      }

      throw Exception('Failed to get rabbit transactions');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get rabbit transactions: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Create new transaction
  Future<Transaction> createTransaction(TransactionCreate transaction) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}/transactions',
        data: transaction.toJson(),
      );

      if (response.data['success'] == true) {
        return Transaction.fromJson(response.data['data']);
      }

      throw Exception('Failed to create transaction');
    } on DioException catch (e) {
      throw Exception(
          'Failed to create transaction: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Update transaction
  Future<Transaction> updateTransaction(
      int id, TransactionUpdate transaction) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.baseUrl}/transactions/$id',
        data: transaction.toJson(),
      );

      if (response.data['success'] == true) {
        return Transaction.fromJson(response.data['data']);
      }

      throw Exception('Failed to update transaction');
    } on DioException catch (e) {
      throw Exception(
          'Failed to update transaction: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Delete transaction
  Future<void> deleteTransaction(int id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.baseUrl}/transactions/$id',
      );

      if (response.data['success'] != true) {
        throw Exception('Failed to delete transaction');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to delete transaction: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get financial statistics
  Future<FinancialStatistics> getStatistics({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (fromDate != null) {
        queryParams['from_date'] = fromDate.toIso8601String().split('T')[0];
      }
      if (toDate != null) {
        queryParams['to_date'] = toDate.toIso8601String().split('T')[0];
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}/transactions/statistics',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        return FinancialStatistics.fromJson(response.data['data']);
      }

      throw Exception('Failed to get statistics');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get statistics: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get monthly report
  Future<MonthlyReport> getMonthlyReport({
    required int year,
    required int month,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'year': year,
        'month': month,
      };

      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}/transactions/monthly-report',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        return MonthlyReport.fromJson(response.data['data']);
      }

      throw Exception('Failed to get monthly report');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get monthly report: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Helper to convert TransactionType to string
  String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  /// Helper to convert TransactionCategory to string
  String _transactionCategoryToString(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.saleRabbit:
        return 'sale_rabbit';
      case TransactionCategory.saleMeat:
        return 'sale_meat';
      case TransactionCategory.saleFur:
        return 'sale_fur';
      case TransactionCategory.breedingFee:
        return 'breeding_fee';
      case TransactionCategory.feed:
        return 'feed';
      case TransactionCategory.veterinary:
        return 'veterinary';
      case TransactionCategory.equipment:
        return 'equipment';
      case TransactionCategory.utilities:
        return 'utilities';
      case TransactionCategory.other:
        return 'other';
    }
  }
}
