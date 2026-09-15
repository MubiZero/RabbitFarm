import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/features/finance/data/models/transaction_model.dart';
import 'package:mobile/features/finance/data/repositories/transactions_repository.dart';
import 'package:mobile/features/finance/presentation/providers/transactions_provider.dart';
import 'package:mobile/features/finance/presentation/screens/transaction_form_screen.dart';

import '../support/test_app.dart';

/// Чек операции: поле `receipt_url` лежало в базе с самого начала, но взять
/// этот адрес человеку было негде — приложение файл не отправляло. Теперь
/// чек снимают телефоном прямо в форме, а снятый можно убрать.
class _FakeTransactionsRepository extends TransactionsRepository {
  _FakeTransactionsRepository()
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<({TransactionUpdate update, String? receiptPath})> updates = [];

  @override
  Future<Transaction> updateTransaction(
    int id,
    TransactionUpdate transaction, {
    String? receiptPath,
    Uint8List? receiptBytes,
  }) async {
    updates.add((update: transaction, receiptPath: receiptPath));
    return _record(receiptUrl: transaction.receiptUrl);
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

Transaction _record({String? receiptUrl = '/uploads/farm-1/receipts/r.png'}) =>
    Transaction(
      id: 3,
      type: TransactionType.expense,
      category: TransactionCategory.feed,
      amount: 150.5,
      transactionDate: DateTime(2026, 9, 1),
      description: 'Мешок комбикорма',
      receiptUrl: receiptUrl,
    );

Future<_FakeTransactionsRepository> _pump(
  WidgetTester tester, {
  String? receiptUrl = '/uploads/farm-1/receipts/r.png',
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final repository = _FakeTransactionsRepository();
  await tester.pumpWidget(
    testAppScreen(
      TransactionFormScreen(transaction: _record(receiptUrl: receiptUrl)),
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(repository),
        cacheScopeProvider.overrideWithValue(null),
      ],
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('у операции с чеком есть чем его убрать', (tester) async {
    await _pump(tester);

    expect(find.text('Чек'), findsOneWidget);
    expect(find.text('Убрать чек'), findsOneWidget);
    // Кнопка называет действие честно: снимок уже есть, значит его меняют.
    expect(find.text('Переснять'), findsOneWidget);
  });

  testWidgets('у операции без чека предлагают его снять', (tester) async {
    await _pump(tester, receiptUrl: null);

    expect(find.text('Снять чек'), findsOneWidget);
    expect(find.text('Убрать чек'), findsNothing);
  });

  testWidgets('снятый чек уходит на сервер пустой строкой', (tester) async {
    final repository = await _pump(tester);

    await tester.ensureVisible(find.text('Убрать чек'));
    await tester.tap(find.text('Убрать чек'));
    await tester.pumpAndSettle();

    final save = find.widgetWithText(FilledButton, 'Сохранить');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    // Пустая строка, а не null: null означает «поле не трогали», и файл
    // остался бы в хранилище навсегда.
    expect(repository.updates.single.update.receiptUrl, '');
    expect(repository.updates.single.receiptPath, isNull);
  });
}
