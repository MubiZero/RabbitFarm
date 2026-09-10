import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/feeding/data/models/feeding_record_model.dart';
import 'package:mobile/features/feeding/data/repositories/feeding_records_repository.dart';
import 'package:mobile/features/feeding/presentation/providers/feeding_records_provider.dart';
import 'package:mobile/features/onboarding/presentation/widgets/activation_checklist_card.dart';

import '../support/test_app.dart';

/// Кормления без сети: конструктор просит `ApiClient`, которого в тестах нет,
/// а сама реализация метода не нужна — подменяется целиком.
class _FakeFeedingRecordsRepository extends FeedingRecordsRepository {
  _FakeFeedingRecordsRepository(this._records)
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<FeedingRecord> _records;

  @override
  Future<List<FeedingRecord>> getRecentFeedingRecords({int? limit}) async =>
      _records;
}

FeedingRecord _feedingRecord() => FeedingRecord(
      id: 1,
      feedId: 1,
      quantity: 1,
      fedAt: DateTime(2026, 9, 1),
    );

Widget _wrap({
  required int cagesTotal,
  required int rabbitsTotal,
  List<FeedingRecord> feedingRecords = const [],
  FarmRoleAccess role = FarmRoleAccess.owner,
}) =>
    testAppScreen(
      Scaffold(
        body: ActivationChecklistCard(
          cagesTotal: cagesTotal,
          rabbitsTotal: rabbitsTotal,
        ),
      ),
      overrides: <Override>[
        farmRoleProvider.overrideWithValue(role),
        feedingRecordsRepositoryProvider.overrideWithValue(
          _FakeFeedingRecordsRepository(feedingRecords),
        ),
      ],
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('на пустой ферме показывает все три шага не сделанными',
      (tester) async {
    await tester.pumpWidget(_wrap(cagesTotal: 0, rabbitsTotal: 0));
    await tester.pump();

    expect(find.text('Начало работы'), findsOneWidget);
    expect(find.text('Добавьте клетку'), findsOneWidget);
    expect(find.text('Добавьте кролика'), findsOneWidget);
    expect(find.text('Внесите первое кормление'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('клетка и кролик заведены — их шаги отмечены галочкой',
      (tester) async {
    await tester.pumpWidget(_wrap(cagesTotal: 3, rabbitsTotal: 10));
    await tester.pump();

    // Два выполненных шага, третий (кормление) — ещё нет.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
  });

  testWidgets('все три шага сделаны — карточка пропадает', (tester) async {
    await tester.pumpWidget(_wrap(
      cagesTotal: 3,
      rabbitsTotal: 10,
      feedingRecords: [_feedingRecord()],
    ));
    // Первый кадр застаёт `recentFeedingRecordsProvider` ещё в загрузке —
    // карточка ждёт настоящего ответа, а не гадает по пустому значению.
    await tester.pump();
    await tester.pump();

    expect(find.text('Начало работы'), findsNothing);
  });

  testWidgets('работнику чек-лист не показывается', (tester) async {
    await tester.pumpWidget(_wrap(
      cagesTotal: 0,
      rabbitsTotal: 0,
      role: FarmRoleAccess.worker,
    ));
    await tester.pump();

    expect(find.text('Начало работы'), findsNothing);
  });

  testWidgets('«Скрыть» прячет карточку, даже если шаги не пройдены',
      (tester) async {
    await tester.pumpWidget(_wrap(cagesTotal: 0, rabbitsTotal: 0));
    await tester.pump();

    await tester.tap(find.text('Скрыть'));
    await tester.pump();

    expect(find.text('Начало работы'), findsNothing);
  });
}
