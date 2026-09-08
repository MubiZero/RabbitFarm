import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/features/reports/data/models/report_model.dart';
import 'package:mobile/features/reports/presentation/providers/reports_provider.dart';
import 'package:mobile/features/reports/presentation/screens/reports_screen.dart';

import '../support/test_app.dart';

const _farmReport = FarmReport(
  period: ReportPeriod(from: '2026-07-22', to: '2026-08-21'),
  population: PopulationData(
    totalRabbits: 128,
    byBreed: [
      BreedCount(breedId: 1, count: 80),
      BreedCount(breedId: 2, count: 34),
      BreedCount(breedId: 9, count: 7),
    ],
  ),
  financial: FinancialData(
    transactions: [],
    summary: FinancialSummary(totalIncome: 184500, totalExpenses: 96200),
  ),
  health: HealthData(vaccinations: 23, medicalRecords: 4),
  breeding: BreedingData(breedings: 12, births: 8),
  feeding: FeedingData(
    totalFeedingRecords: 214,
    consumptionByUnit: [FeedConsumption(unit: 'kg', total: 486.5)],
  ),
);

const _healthReport = HealthReport(
  vaccinations: VaccinationsData(
    byType: [
      VaccineTypeCount(vaccineName: 'Миксоматоз', count: 14),
      VaccineTypeCount(vaccineName: 'ВГБК', count: 6),
    ],
    upcoming: [],
  ),
  medicalRecords: MedicalRecordsData(
    byOutcome: [
      RecordOutcomeCount(outcome: 'recovered', count: 3),
      RecordOutcomeCount(outcome: 'ongoing', count: 2),
      RecordOutcomeCount(outcome: null, count: 1),
    ],
  ),
);

const _financialReport = FinancialReport(
  summary: FinancialReportSummary(
    totalIncome: 184500,
    totalExpenses: 96200,
    netProfit: 88300,
  ),
  byCategory: [
    CategoryData(
      type: 'income',
      category: 'sale_rabbit',
      total: 142000,
      count: 21,
    ),
    CategoryData(type: 'expense', category: 'feed', total: 71400, count: 8),
  ],
);

/// Породы подменяем целиком: настоящий список пород ходит в сеть, а отчёту от
/// него нужны только названия.
final _breedNames = reportBreedNamesProvider.overrideWithValue({
  1: 'Калифорнийская',
  2: 'Новозеландская',
});

Override _role({required bool canFinance}) =>
    canProvider.overrideWith((ref, capability) =>
        capability == FarmCapability.manageFinance ? canFinance : true);

List<Override> _overrides({
  bool canFinance = true,
  FarmReport farm = _farmReport,
  Object? farmError,
}) =>
    [
      _breedNames,
      _role(canFinance: canFinance),
      farmReportProvider.overrideWith((ref, params) async {
        if (farmError != null) throw farmError;
        return farm;
      }),
      healthReportProvider.overrideWith((ref, params) async => _healthReport),
      financialReportProvider
          .overrideWith((ref, params) async => _financialReport),
    ];

/// Каркас загрузки пульсирует бесконечно, поэтому `pumpAndSettle` здесь не
/// сходится: ждём ответ провайдера и доигрываем анимацию полос вручную. Окно
/// растягиваем — отчёт длиннее стандартных 800x600, а `ListView` строит
/// только видимое.
Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _openSection(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU', null));

  group('Отчёт по ферме', () {
    testWidgets('показывает поголовье, породы и работу за период',
        (tester) async {
      await tester.pumpWidget(
        testAppScreen(const ReportsScreen(), overrides: _overrides()),
      );
      await _settle(tester);

      expect(find.text('Отчёты'), findsOneWidget);
      expect(find.textContaining('22 июля'), findsOneWidget); // границы периода
      expect(find.text('Кроликов сейчас'), findsOneWidget);
      expect(find.text('128'), findsOneWidget);
      expect(find.text('Окролы'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('Случки'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Вакцинации'), findsOneWidget);
      expect(find.text('23'), findsOneWidget);
      expect(find.text('Кормления'), findsOneWidget);
      expect(find.text('214'), findsOneWidget);
    });

    testWidgets('называет породы, а незнакомую помечает номером',
        (tester) async {
      await tester.pumpWidget(
        testAppScreen(const ReportsScreen(), overrides: _overrides()),
      );
      await _settle(tester);

      expect(find.text('ПОГОЛОВЬЕ ПО ПОРОДАМ'), findsOneWidget);
      expect(find.text('Калифорнийская'), findsOneWidget);
      expect(find.text('Новозеландская'), findsOneWidget);
      expect(find.text('Порода №9'), findsOneWidget);
    });

    testWidgets('на пустом периоде не показывает столбец нулей',
        (tester) async {
      await tester.pumpWidget(testAppScreen(
        const ReportsScreen(),
        overrides: _overrides(
          farm: _farmReport.copyWith(
            health: const HealthData(vaccinations: 0, medicalRecords: 0),
            breeding: const BreedingData(breedings: 0, births: 0),
            feeding: const FeedingData(totalFeedingRecords: 0),
          ),
        ),
      ));
      await _settle(tester);

      expect(find.text('За этот период записей нет'), findsOneWidget);
      expect(find.text('Случки'), findsNothing);
      // Поголовье от периода не зависит и остаётся на экране.
      expect(find.text('128'), findsOneWidget);
    });

    testWidgets('на совсем пустой ферме зовёт завести кролика', (tester) async {
      await tester.pumpWidget(testAppScreen(
        const ReportsScreen(),
        overrides: _overrides(
          farm: const FarmReport(
            period: ReportPeriod(from: '2026-07-22', to: '2026-08-21'),
            population: PopulationData(totalRabbits: 0, byBreed: []),
            financial: FinancialData(
              transactions: [],
              summary: FinancialSummary(totalIncome: 0, totalExpenses: 0),
            ),
            health: HealthData(vaccinations: 0, medicalRecords: 0),
            breeding: BreedingData(breedings: 0, births: 0),
            feeding: FeedingData(totalFeedingRecords: 0),
          ),
        ),
      ));
      await _settle(tester);

      expect(find.text('Отчёту пока не из чего собраться'), findsOneWidget);
      expect(find.text('Добавить кролика'), findsOneWidget);
    });

    testWidgets('на ошибке объясняет и предлагает повторить', (tester) async {
      await tester.pumpWidget(testAppScreen(
        const ReportsScreen(),
        overrides: _overrides(farmError: Exception('нет сети')),
      ));
      await _settle(tester);

      expect(find.text('Не удалось загрузить'), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
    });
  });

  group('Права на финансы', () {
    testWidgets('владельцу виден и раздел «Деньги», и деньги в отчёте по ферме',
        (tester) async {
      await tester.pumpWidget(
        testAppScreen(const ReportsScreen(), overrides: _overrides()),
      );
      await _settle(tester);

      expect(find.text('Деньги'), findsOneWidget); // сегмент выбора отчёта
      expect(find.text('ДЕНЬГИ ЗА ПЕРИОД'), findsOneWidget);
      expect(find.text('184\u00A0500 с'), findsOneWidget);
      expect(find.text('88\u00A0300 с'), findsOneWidget); // 184 500 − 96 200
    });

    testWidgets('работнику финансов не показываем вовсе', (tester) async {
      await tester.pumpWidget(testAppScreen(
        const ReportsScreen(),
        overrides: _overrides(canFinance: false),
      ));
      await _settle(tester);

      expect(find.text('Деньги'), findsNothing);
      expect(find.text('ДЕНЬГИ ЗА ПЕРИОД'), findsNothing);
      expect(find.text('Доходы'), findsNothing);
      // Остальной отчёт при этом на месте.
      expect(find.text('Кроликов сейчас'), findsOneWidget);
    });
  });

  group('Отчёт по здоровью', () {
    testWidgets('показывает прививки по вакцинам и лечение по исходу',
        (tester) async {
      await tester.pumpWidget(
        testAppScreen(const ReportsScreen(), overrides: _overrides()),
      );
      await _settle(tester);
      await _openSection(tester, 'Здоровье');

      expect(find.text('ПРИВИВКИ ПО ВАКЦИНАМ'), findsOneWidget);
      expect(find.text('Миксоматоз'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
      expect(find.text('ЛЕЧЕНИЕ ПО ИСХОДУ'), findsOneWidget);
      // Сервер отдаёт код исхода — на экране должно быть слово.
      expect(find.text('Выздоровел'), findsOneWidget);
      expect(find.text('Лечится'), findsOneWidget);
      expect(find.textContaining('recovered'), findsNothing);
    });
  });

  group('Финансовый отчёт', () {
    testWidgets('показывает итог и структуру по категориям', (tester) async {
      await tester.pumpWidget(
        testAppScreen(const ReportsScreen(), overrides: _overrides()),
      );
      await _settle(tester);
      await _openSection(tester, 'Деньги');

      expect(find.text('Прибыль'), findsOneWidget);
      expect(find.text('88\u00A0300 с'), findsOneWidget);
      expect(find.text('ДОХОДЫ ПО КАТЕГОРИЯМ'), findsOneWidget);
      expect(find.text('Продажа кролика'), findsOneWidget);
      expect(find.text('142\u00A0000 с'), findsOneWidget);
      expect(find.text('РАСХОДЫ ПО КАТЕГОРИЯМ'), findsOneWidget);
      expect(find.text('Корм'), findsOneWidget);
    });
  });
}
