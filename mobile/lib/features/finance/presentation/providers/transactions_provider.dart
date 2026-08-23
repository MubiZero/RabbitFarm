import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transactions_repository.dart';

/// Provider for TransactionsRepository
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return TransactionsRepository(apiClient);
});

/// State class for transactions list
class TransactionsState {
  final List<Transaction> transactions;
  final bool isLoading;
  final Object? error;
  final bool hasMore;
  final int currentPage;

  /// Фильтры списка. Живут в состоянии, а не в экране: обновление жестом и
  /// подгрузка следующей страницы вызывали загрузку без них, и отфильтрованная
  /// ведомость незаметно смешивалась с остальными операциями.
  final TransactionType? type;
  final TransactionCategory? category;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.type,
    this.category,
    this.fromDate,
    this.toDate,
  });

  bool get hasFilters =>
      type != null || category != null || fromDate != null || toDate != null;

  TransactionsState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    Object? error,
    bool? hasMore,
    int? currentPage,
    TransactionType? type,
    bool clearType = false,
    TransactionCategory? category,
    bool clearCategory = false,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? toDate,
    bool clearToDate = false,
  }) {
    // clearError передаёт сюда null, а «?? this.error» его игнорировал —
    // сообщение об ошибке залипало в состоянии до перезапуска приложения,
    // переживая любые успешные загрузки. В остальных фичах принято
    // присваивать error напрямую; приводим к тому же виду.
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      type: clearType ? null : (type ?? this.type),
      category: clearCategory ? null : (category ?? this.category),
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
    );
  }
}

/// Notifier for managing transactions list state
class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final TransactionsRepository _repository;

  TransactionsNotifier(this._repository) : super(const TransactionsState());

  /// Load transactions with optional filters
  Future<void> loadTransactions({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = TransactionsState(
        isLoading: true,
        type: state.type,
        category: state.category,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final transactions = await _repository.getTransactions(
        page: page ?? state.currentPage,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        type: state.type,
        category: state.category,
        rabbitId: rabbitId,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );

      if (refresh) {
        state = TransactionsState(
          transactions: transactions,
          isLoading: false,
          hasMore: transactions.length >= (limit ?? 10),
          currentPage: page ?? 1,
          type: state.type,
          category: state.category,
          fromDate: state.fromDate,
          toDate: state.toDate,
        );
      } else {
        state = state.copyWith(
          transactions: [...state.transactions, ...transactions],
          isLoading: false,
          hasMore: transactions.length >= (limit ?? 10),
          currentPage: (page ?? state.currentPage) + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh transactions list
  Future<void> refresh() async {
    await loadTransactions(refresh: true);
  }

  /// Load more transactions (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadTransactions(page: state.currentPage);
  }

  /// Add new transaction to the list
  void addTransaction(Transaction transaction) {
    state = state.copyWith(
      transactions: [transaction, ...state.transactions],
    );
  }

  /// Update transaction in the list
  void updateTransaction(Transaction transaction) {
    final updatedTransactions = state.transactions.map((t) {
      return t.id == transaction.id ? transaction : t;
    }).toList();

    state = state.copyWith(transactions: updatedTransactions);
  }

  /// Remove transaction from the list
  void removeTransaction(int transactionId) {
    final updatedTransactions =
        state.transactions.where((t) => t.id != transactionId).toList();
    state = state.copyWith(transactions: updatedTransactions);
  }

  /// Задать фильтры и перезагрузить ведомость.
  Future<void> setFilters({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    state = state.copyWith(
      type: type,
      clearType: type == null,
      category: category,
      clearCategory: category == null,
      fromDate: fromDate,
      clearFromDate: fromDate == null,
      toDate: toDate,
      clearToDate: toDate == null,
    );
    await loadTransactions(refresh: true);
  }

  Future<void> clearFilters() async {
    state = state.copyWith(
      clearType: true,
      clearCategory: true,
      clearFromDate: true,
      clearToDate: true,
    );
    await loadTransactions(refresh: true);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for transactions list state
final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  final repository = ref.watch(transactionsRepositoryProvider);
  return TransactionsNotifier(repository);
});

/// Provider for single transaction by ID
final transactionByIdProvider =
    FutureProvider.autoDispose.family<Transaction, int>((ref, id) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.getTransactionById(id);
});

/// Provider for rabbit transactions
final rabbitTransactionsProvider = FutureProvider.autoDispose
    .family<RabbitTransactionsSummary, int>((ref, rabbitId) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.getRabbitTransactions(rabbitId);
});

/// Provider for creating a transaction
final createTransactionProvider = FutureProvider.autoDispose
    .family<Transaction, TransactionCreate>((ref, transactionCreate) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  final transaction = await repository.createTransaction(transactionCreate);

  return transaction;
});

/// Provider for updating a transaction
final updateTransactionProvider = FutureProvider.autoDispose
    .family<Transaction, ({int id, TransactionUpdate update})>((ref, params) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  final transaction = await repository.updateTransaction(params.id, params.update);

  return transaction;
});

/// Provider for deleting a transaction
final deleteTransactionProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  await repository.deleteTransaction(id);
});

/// Provider for financial statistics
final financialStatisticsProvider = FutureProvider.autoDispose
    .family<FinancialStatistics, ({DateTime? fromDate, DateTime? toDate})>(
        (ref, params) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.getStatistics(
    fromDate: params.fromDate,
    toDate: params.toDate,
  );
});

/// Provider for monthly report
final monthlyReportProvider = FutureProvider.autoDispose
    .family<MonthlyReport, ({int year, int month})>((ref, params) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.getMonthlyReport(
    year: params.year,
    month: params.month,
  );
});

/// Provider for filtering transactions by type
final transactionsByTypeProvider =
    Provider.autoDispose.family<List<Transaction>, TransactionType?>((ref, type) {
  final transactionsState = ref.watch(transactionsProvider);

  if (type == null) {
    return transactionsState.transactions;
  }

  return transactionsState.transactions.where((t) => t.type == type).toList();
});

/// Provider for filtering transactions by category
final transactionsByCategoryProvider = Provider.autoDispose
    .family<List<Transaction>, TransactionCategory?>((ref, category) {
  final transactionsState = ref.watch(transactionsProvider);

  if (category == null) {
    return transactionsState.transactions;
  }

  return transactionsState.transactions
      .where((t) => t.category == category)
      .toList();
});
