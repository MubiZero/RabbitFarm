import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/models/user_ref.dart';
import 'package:mobile/features/finance/data/models/transaction_model.dart';
import 'package:mobile/features/finance/data/repositories/transactions_repository.dart';
import 'package:mobile/features/finance/presentation/providers/transactions_provider.dart';
import 'package:mobile/features/finance/presentation/screens/transactions_list_screen.dart';

import '../support/test_app.dart';

/// Сервер прикладывает автора к каждой проводке, а книга денег его не
/// показывала. Для фермы с наёмным управляющим «кто это записал» — главный
/// вопрос к денежной странице, и ответ всё это время лежал в ответе
/// неразобранным.
class _FakeTransactionsRepository extends TransactionsRepository {
  _FakeTransactionsRepository(this.transactions)
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<Transaction> transactions;

  @override
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
  }) async =>
      (page ?? 1) == 1 ? transactions : const [];

  @override
  Future<FinancialStatistics> getStatistics({
    DateTime? fromDate,
    DateTime? toDate,
  }) async =>
      const FinancialStatistics(
        totalIncome: 0,
        totalExpenses: 0,
        netProfit: 0,
        totalTransactions: 0,
        incomeByCategory: [],
        expensesByCategory: [],
        recentTransactions: [],
      );
}

const _me = UserRef(id: 1, fullName: 'Пётр Владелец');
const _manager = UserRef(id: 2, fullName: 'Иван Управляющий');

Transaction _transaction({required UserRef author}) => Transaction(
      id: 11,
      type: TransactionType.expense,
      category: TransactionCategory.feed,
      amount: 250,
      transactionDate: DateTime(2026, 9, 10),
      author: author,
    );

Widget _screen(Transaction transaction) => testAppScreen(
      const TransactionsListScreen(),
      overrides: [
        transactionsRepositoryProvider
            .overrideWithValue(_FakeTransactionsRepository([transaction])),
        farmRoleProvider.overrideWithValue(FarmRoleAccess.owner),
        currentUserIdProvider.overrideWithValue(_me.id),
      ],
    );

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  testWidgets('чужую проводку книга подписывает именем', (tester) async {
    await tester.pumpWidget(_screen(_transaction(author: _manager)));
    await _settle(tester);

    expect(find.text('Записал Иван Управляющий'), findsOneWidget);
  });

  // На ферме из одного человека все проводки его собственные, и подпись под
  // каждой была бы шумом. Автор проступает ровно там, где отвечает на вопрос.
  testWidgets('свою проводку книга не подписывает', (tester) async {
    await tester.pumpWidget(_screen(_transaction(author: _me)));
    await _settle(tester);

    expect(find.textContaining('Записал'), findsNothing);
  });

  testWidgets('в карточке операции автор назван всегда', (tester) async {
    await tester.pumpWidget(_screen(_transaction(author: _me)));
    await _settle(tester);

    await tester.tap(find.text('Корм'));
    await tester.pumpAndSettle();

    expect(find.text('Кто записал'), findsOneWidget);
    expect(find.text(_me.fullName), findsOneWidget);
  });
}
