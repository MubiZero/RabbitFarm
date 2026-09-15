import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/features/finance/data/models/transaction_model.dart';
import 'package:mobile/features/finance/data/repositories/transactions_repository.dart';
import 'package:mobile/features/finance/presentation/providers/transactions_provider.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/presentation/screens/sale_form_screen.dart';
import 'package:mobile/features/rabbits/presentation/utils/rabbit_labels.dart';

import '../support/test_app.dart';

/// Связь «кролик — деньги» работала в одну сторону: приход категории
/// `sale_*` переводил кролика в проданные, а статус «Продан», выбранный в
/// общей форме, не оставлял в книге ни строчки. Проверяется то, что уходит на
/// сервер: именно приход и именно этой категории — другая оставила бы деньги
/// в книге, а кролика в поголовье.
class _FakeTransactionsRepository extends TransactionsRepository {
  _FakeTransactionsRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<TransactionCreate> created = [];

  @override
  Future<Transaction> createTransaction(TransactionCreate transaction) async {
    created.add(transaction);
    return Transaction(
      id: 1,
      type: transaction.type,
      category: transaction.category,
      amount: transaction.amount,
      transactionDate: transaction.transactionDate,
      rabbitId: transaction.rabbitId,
    );
  }

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
      const [];
}

final _rabbit = RabbitModel(
  id: 42,
  name: 'Мушка',
  tagId: 'A-0231',
  breedId: 1,
  sex: 'female',
  birthDate: DateTime(2026, 1, 1),
  status: 'healthy',
  purpose: 'meat',
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

Widget _screen(_FakeTransactionsRepository repository) => testAppScreen(
      SaleFormScreen(rabbit: _rabbit),
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(repository),
        cacheScopeProvider.overrideWithValue(null),
      ],
    );

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpAndSettle();
}

Future<void> _submit(WidgetTester tester) async {
  final button = find.widgetWithText(FilledButton, 'Записать');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('продажа уходит приходом за этого кролика', (tester) async {
    final repository = _FakeTransactionsRepository();
    await tester.pumpWidget(_screen(repository));
    await _settle(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Цена'),
      '450',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Покупатель'),
      'Сосед из Гиссара',
    );
    await _submit(tester);

    final sale = repository.created.single;
    expect(sale.type, TransactionType.income);
    // Только `sale_*` переводит кролика в проданные на сервере.
    expect(sale.category, TransactionCategory.saleRabbit);
    expect(sale.amount, 450);
    expect(sale.rabbitId, _rabbit.id);
    expect(sale.description, 'Сосед из Гиссара');
  });

  // Продажа без суммы — это просто списание кролика из поголовья, а человек
  // пришёл записать доход. Пустая цена вернула бы ферме ту же дыру, ради
  // которой экран и заведён.
  testWidgets('без цены продажа не записывается', (tester) async {
    final repository = _FakeTransactionsRepository();
    await tester.pumpWidget(_screen(repository));
    await _settle(tester);

    await _submit(tester);

    expect(repository.created, isEmpty);
    expect(find.text('Укажите, за сколько продали'), findsOneWidget);
  });

  test('выбытие названо одним списком — на него смотрят и форма, и карточка',
      () {
    expect(rabbitStatusesTerminal,
        containsAll([rabbitStatusSold, rabbitStatusDead]));
    // Список статусов формы остаётся полным: он источник подписей, а прятать
    // выбытие — дело самого выпадающего списка.
    expect(rabbitStatuses, containsAll(rabbitStatusesTerminal));
  });
}
