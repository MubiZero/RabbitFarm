import 'dart:convert';

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
import 'package:mobile/features/onboarding/data/first_steps.dart';
import 'package:mobile/features/onboarding/presentation/providers/first_steps_provider.dart';
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

FeedingRecord _feedingRecord() =>
    FeedingRecord(id: 1, feedId: 1, quantity: 1, fedAt: DateTime(2026, 9, 1));

Widget _wrap({
  required int cagesTotal,
  required int rabbitsTotal,
  List<FeedingRecord> feedingRecords = const [],
  FarmRoleAccess role = FarmRoleAccess.owner,
  Set<FirstStep>? doneSteps,
}) => testAppScreen(
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
    // Шаги, которые карточка проверяет запросом: в тесте отвечаем за них
    // напрямую, чтобы не поднимать четыре репозитория ради одной галочки.
    if (doneSteps != null)
      firstStepDoneProvider.overrideWith(
        (ref, step) async => doneSteps.contains(step),
      ),
  ],
);

/// Ответы знакомства и признаки сделанных шагов читаются асинхронно —
/// карточка складывается не в первом кадре.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.pump();
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('на новой ферме первый шаг уже отмечен — счёт открыт', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(cagesTotal: 0, rabbitsTotal: 0));
    await _settle(tester);

    expect(find.text('Начало работы'), findsOneWidget);
    expect(find.text('Ферма создана'), findsOneWidget);
    expect(find.text('Завести клетки'), findsOneWidget);
    expect(find.text('Добавить самок и самцов'), findsOneWidget);
    expect(find.text('Отметить первое кормление'), findsOneWidget);

    // Ровно одна галочка — подаренная. Пустой список из одних кружков
    // выглядит работой, к которой ещё не приступали.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('1 из 4'), findsOneWidget);
  });

  testWidgets('клетка и кролик заведены — их шаги отмечены галочкой', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(cagesTotal: 3, rabbitsTotal: 10));
    await _settle(tester);

    // Созданная ферма плюс два сделанных шага; кормление ещё нет.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    expect(find.text('3 из 4'), findsOneWidget);
  });

  testWidgets('все шаги сделаны — карточка пропадает', (tester) async {
    await tester.pumpWidget(
      _wrap(
        cagesTotal: 3,
        rabbitsTotal: 10,
        feedingRecords: [_feedingRecord()],
      ),
    );
    // Первые кадры застают ответы знакомства и кормления ещё в загрузке —
    // карточка ждёт настоящего ответа, а не гадает по пустому значению.
    await _settle(tester);

    expect(find.text('Начало работы'), findsNothing);
  });

  testWidgets('работнику чек-лист не показывается', (tester) async {
    await tester.pumpWidget(
      _wrap(cagesTotal: 0, rabbitsTotal: 0, role: FarmRoleAccess.worker),
    );
    await _settle(tester);

    expect(find.text('Начало работы'), findsNothing);
  });

  testWidgets('«Скрыть» прячет карточку, даже если шаги не пройдены', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(cagesTotal: 0, rabbitsTotal: 0));
    await _settle(tester);

    await tester.tap(find.text('Скрыть'));
    await tester.pump();

    expect(find.text('Начало работы'), findsNothing);
  });

  group('шаги идут от ответов на знакомстве', () {
    testWidgets('сказал про помощников — появляется шаг пригласить', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_answers': jsonEncode({
          'crew': 'withHelpers',
          'focus': ['breeding'],
        }),
      });

      await tester.pumpWidget(
        _wrap(cagesTotal: 0, rabbitsTotal: 0, doneSteps: {FirstStep.cages}),
      );
      await _settle(tester);

      expect(find.text('Записать первую случку'), findsOneWidget);
      expect(find.text('Пригласить помощника'), findsOneWidget);
      // Про кормление не спрашивали — и предлагать его первым делом незачем.
      expect(find.text('Отметить первое кормление'), findsNothing);
    });

    testWidgets('сказал про деньги — предлагаем продажу, а не кормление', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_answers': jsonEncode({
          'crew': 'alone',
          'focus': ['money'],
        }),
      });

      await tester.pumpWidget(
        _wrap(cagesTotal: 0, rabbitsTotal: 0, doneSteps: const {}),
      );
      await _settle(tester);

      expect(find.text('Записать первую продажу'), findsOneWidget);
      expect(find.text('Отметить первое кормление'), findsNothing);
    });
  });
}
