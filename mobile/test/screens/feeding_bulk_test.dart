import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/presentation/providers/cages_provider.dart';
import 'package:mobile/features/feeding/data/models/feed_model.dart';
import 'package:mobile/features/feeding/data/models/feeding_record_model.dart';
import 'package:mobile/features/feeding/data/repositories/feeding_records_repository.dart';
import 'package:mobile/features/feeding/presentation/providers/feeding_records_provider.dart';
import 'package:mobile/features/feeding/presentation/providers/feeds_provider.dart';
import 'package:mobile/features/feeding/presentation/screens/feeding_record_form_screen.dart';

import '../support/test_app.dart';

/// Кормление пачкой — главный рабочий сценарий: работник обходит ряд и
/// записывает раздачу один раз, а не по форме на клетку. Проверяем то, из-за
/// чего цифры корма могут разойтись с реальностью: сколько ушло запросов,
/// какое количество отправлено и что подпись под полем говорит о нём честно.
class _FakeFeedingRecordsRepository extends FeedingRecordsRepository {
  _FakeFeedingRecordsRepository()
      : super(ApiClient(
          storage: const FlutterSecureStorage(),
          baseUrl: 'http://localhost',
        ));

  final List<Map<String, dynamic>> bulkCalls = [];
  int singleCalls = 0;

  @override
  Future<int> createFeedingRecordsBulk({
    required int feedId,
    required double quantityPerRecipient,
    required DateTime fedAt,
    List<int> rabbitIds = const [],
    List<int> cageIds = const [],
    String? notes,
  }) async {
    bulkCalls.add({
      'feed_id': feedId,
      'quantity': quantityPerRecipient,
      'rabbit_ids': rabbitIds,
      'cage_ids': cageIds,
    });
    return rabbitIds.length + cageIds.length;
  }

  @override
  Future<FeedingRecord> createFeedingRecord(FeedingRecordCreate record) async {
    singleCalls++;
    throw UnimplementedError('форма создаёт записи только пачкой');
  }

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
      const [];
}

final _feed = Feed(
  id: 7,
  name: 'Сено луговое',
  type: FeedType.hay,
  unit: FeedUnit.kg,
  currentStock: 100,
  minStock: 10,
);

CageModel _cage(int id, String number, String? row) => CageModel(
      id: id,
      number: number,
      type: 'group',
      capacity: 4,
      location: row,
      condition: 'good',
    );

final _cages = [
  _cage(1, 'A-1', 'Ряд A'),
  _cage(2, 'A-2', 'Ряд A'),
  _cage(3, 'B-1', 'Ряд Б'),
];

Future<_FakeFeedingRecordsRepository> _pumpForm(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final repository = _FakeFeedingRecordsRepository();

  await tester.pumpWidget(testAppScreen(
    const FeedingRecordFormScreen(),
    overrides: [
      feedingRecordsRepositoryProvider.overrideWithValue(repository),
      feedOptionsProvider.overrideWith((ref) async => [_feed]),
      cageOptionsProvider.overrideWith((ref) async => _cages),
    ],
  ));
  await tester.pumpAndSettle();

  return repository;
}

/// Переключиться на клетки и открыть шторку выбора.
/// Клетка может оказаться ниже кромки экрана: список в шторке ленивый, и
/// непостроенную строку не найти никаким finder-ом — как и человеку, которому
/// до неё надо долистать.
Future<void> _tapInSheet(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.scrollUntilVisible(
    target,
    120,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _openCagePicker(WidgetTester tester) async {
  await tester.tap(find.text('Клетки'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Какие клетки'));
  await tester.pumpAndSettle();
}

Future<void> _pickFeed(WidgetTester tester) async {
  await tester.tap(find.byType(DropdownButtonFormField<int>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Сено луговое').last);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('ru', null));

  testWidgets('вся ферма записывается одним запросом, количество — на клетку',
      (tester) async {
    final repository = await _pumpForm(tester);

    await _openCagePicker(tester);
    await tester.tap(find.text('Вся ферма'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    await _pickFeed(tester);
    await tester.enterText(find.byType(TextFormField).first, '0,5');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Добавить'));
    await tester.pumpAndSettle();

    // Один запрос на всю ферму, а не запрос на клетку.
    expect(repository.bulkCalls, hasLength(1));
    expect(repository.singleCalls, 0);

    final call = repository.bulkCalls.single;
    expect(call['cage_ids'], [1, 2, 3]);
    expect(call['rabbit_ids'], isEmpty);
    // Отправлена норма на одного получателя — умножать на количество клеток
    // должен сервер, иначе в каждой записи оказалась бы выдуманная дробь.
    expect(call['quantity'], 0.5);
    expect(call['feed_id'], 7);
  });

  testWidgets('ряд выбирается целиком одним нажатием', (tester) async {
    final repository = await _pumpForm(tester);

    await _openCagePicker(tester);
    await _tapInSheet(tester, 'Ряд A');
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    await _pickFeed(tester);
    await tester.enterText(find.byType(TextFormField).first, '1');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Добавить'));
    await tester.pumpAndSettle();

    expect(repository.bulkCalls.single['cage_ids'], [1, 2]);
  });

  testWidgets('подпись под количеством называет и норму, и общий расход',
      (tester) async {
    await _pumpForm(tester);

    await _openCagePicker(tester);
    await tester.tap(find.text('Вся ферма'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    await _pickFeed(tester);
    await tester.enterText(find.byType(TextFormField).first, '0,5');
    await tester.pumpAndSettle();

    // Число под полем не должно читаться двояко: 0,5 — на клетку, 1,5 —
    // всего со склада.
    expect(find.text('Сколько на каждого'), findsOneWidget);
    expect(
      find.textContaining('Всего спишется 1,5 кг'),
      findsOneWidget,
    );
  });

  testWidgets('одна клетка — та же форма и тот же один запрос',
      (tester) async {
    final repository = await _pumpForm(tester);

    await _openCagePicker(tester);
    await _tapInSheet(tester, 'Клетка B-1');
    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    await _pickFeed(tester);
    await tester.enterText(find.byType(TextFormField).first, '2');
    await tester.pumpAndSettle();

    // Пока получатель один, подпись остаётся прежней — лишнего про «каждого»
    // на одиночном кормлении быть не должно.
    expect(find.text('Сколько'), findsOneWidget);
    expect(find.textContaining('Всего спишется'), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, 'Добавить'));
    await tester.pumpAndSettle();

    expect(repository.bulkCalls.single['cage_ids'], [3]);
    expect(repository.bulkCalls.single['quantity'], 2.0);
  });

  testWidgets('без выбранных получателей форма не отправляется',
      (tester) async {
    final repository = await _pumpForm(tester);

    await tester.tap(find.text('Клетки'));
    await tester.pumpAndSettle();

    await _pickFeed(tester);
    await tester.enterText(find.byType(TextFormField).first, '1');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Добавить'));
    await tester.pumpAndSettle();

    expect(repository.bulkCalls, isEmpty);
    expect(find.text('Выберите хотя бы одну клетку'), findsOneWidget);
  });
}
