import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/feeding/data/models/feed_model.dart';
import 'package:mobile/features/feeding/data/models/feeding_record_model.dart';
import 'package:mobile/features/feeding/data/repositories/feeding_records_repository.dart';
import 'package:mobile/features/feeding/presentation/providers/feeding_records_provider.dart';
import 'package:mobile/features/feeding/presentation/screens/feeding_records_list_screen.dart';

import '../support/test_app.dart';

/// Удаление с окном на отмену — на примере списка кормлений.
///
/// Ради чего всё это: фермер работает в перчатках, и диалог «Точно удалить?»
/// от случайного нажатия не спасает — руку он приучает жать «Удалить»
/// рефлекторно. Спасает окно отмены, и проверяем здесь именно его суть:
/// запрос на сервер не уходит, пока окно открыто; по «Вернуть» не уходит
/// вовсе; и уходит сам, если окно просто закрылось.
class _FakeFeedingRecordsRepository extends FeedingRecordsRepository {
  _FakeFeedingRecordsRepository()
      : super(ApiClient(
          storage: const FlutterSecureStorage(),
          baseUrl: 'http://localhost',
        ));

  /// Что лежит «на сервере».
  List<FeedingRecord> stored = [_record];

  /// Кого и правда попросили удалить.
  final List<int> deleted = [];

  @override
  Future<List<FeedingRecord>> getFeedingRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    int? feedId,
    int? cageId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async =>
      stored;

  @override
  Future<void> deleteFeedingRecord(int id) async {
    deleted.add(id);
    stored = stored.where((r) => r.id != id).toList();
  }
}

final _feed = Feed(
  id: 7,
  name: 'Сено луговое',
  type: FeedType.hay,
  unit: FeedUnit.kg,
  currentStock: 100,
  minStock: 10,
);

final _record = FeedingRecord(
  id: 42,
  feedId: 7,
  quantity: 2.5,
  fedAt: DateTime(2026, 3, 12, 8, 30),
  feed: _feed,
);

final _deleteButton = find.byIcon(Icons.delete_outline);

Future<_FakeFeedingRecordsRepository> _pumpList(WidgetTester tester) async {
  final repository = _FakeFeedingRecordsRepository();

  // Экран пошире телефонного: строка кормления без автора не умещается в 420
  // и роняет тест переполнением — а проверяем мы здесь не вёрстку.
  await tester.binding.setSurfaceSize(const Size(600, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(testAppScreen(
    const FeedingRecordsListScreen(),
    overrides: [
      feedingRecordsRepositoryProvider.overrideWithValue(repository),
      // Удалять записи текучки может владелец.
      farmRoleProvider.overrideWithValue(FarmRoleAccess.owner),
    ],
  ));

  // Список загружается из `addPostFrameCallback`, ответ приходит следующим
  // кадром.
  await tester.pump();
  await tester.pump();

  expect(_deleteButton, findsOneWidget, reason: 'строка должна быть в списке');
  return repository;
}

/// Нажать «Удалить» и дождаться, когда подсказка с отменой выедет целиком:
/// отсчёт окна начинается только после этого.
Future<void> _tapDelete(WidgetTester tester) async {
  await tester.tap(_deleteButton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUpAll(() => initializeDateFormatting('ru', null));

  testWidgets('строка уходит сразу, а запрос на удаление — нет',
      (tester) async {
    final repository = await _pumpList(tester);

    await _tapDelete(tester);

    expect(repository.deleted, isEmpty,
        reason: 'пока окно отмены открыто, удалять нечего');
    expect(_deleteButton, findsNothing,
        reason: 'строка должна исчезнуть сразу, не дожидаясь сервера');
    expect(find.text('Вернуть'), findsOneWidget);
  });

  testWidgets('«Вернуть» отменяет удаление — запрос не уходит вовсе',
      (tester) async {
    final repository = await _pumpList(tester);

    await _tapDelete(tester);
    await tester.tap(find.text('Вернуть'));
    await tester.pump();
    // Подсказка уезжает, и только потом список перечитывается.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(repository.deleted, isEmpty);
    expect(_deleteButton, findsOneWidget,
        reason: 'строка должна вернуться на место');
  });

  testWidgets('окно закрылось само — запрос уходит', (tester) async {
    final repository = await _pumpList(tester);

    await _tapDelete(tester);
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    await tester.pump();

    expect(find.text('Вернуть'), findsNothing, reason: 'окно закрылось');
    expect(repository.deleted, [42]);
    expect(_deleteButton, findsNothing);
  });
}
