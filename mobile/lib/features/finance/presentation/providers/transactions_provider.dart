import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transactions_repository.dart';

/// Provider for TransactionsRepository
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TransactionsRepository(apiClient);
});

/// State class for transactions list
class TransactionsState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const TransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  TransactionsState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
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
    TransactionType? type,
    TransactionCategory? category,
    int? rabbitId,
    DateTime? fromDate,
    DateTime? toDate,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const TransactionsState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final transactions = await _repository.getTransactions(
        page: page ?? state.currentPage,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        type: type,
        category: category,
        rabbitId: rabbitId,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (refresh) {
        state = TransactionsState(
          transactions: transactions,
          isLoading: false,
          hasMore: transactions.length >= (limit ?? 10),
          currentPage: page ?? 1,
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

  // Add to transactions list
  ref.read(transactionsProvider.notifier).addTransaction(transaction);

  return transaction;
});

/// Provider for updating a transaction
final updateTransactionProvider = FutureProvider.autoDispose
    .family<Transaction, ({int id, TransactionUpdate update})>((ref, params) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  final transaction = await repository.updateTransaction(params.id, params.update);

  // Update in transactions list
  ref.read(transactionsProvider.notifier).updateTransaction(transaction);

  return transaction;
});

/// Provider for deleting a transaction
final deleteTransactionProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  await repository.deleteTransaction(id);

  // Remove from transactions list
  ref.read(transactionsProvider.notifier).removeTransaction(id);
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
