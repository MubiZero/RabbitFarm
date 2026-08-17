import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/features/feeding/data/models/feed_model.dart';
import 'package:mobile/features/feeding/data/models/feeding_record_model.dart';
import 'package:mobile/features/feeding/presentation/providers/feeding_records_provider.dart';
import 'package:mobile/features/feeding/presentation/providers/feeds_provider.dart';
import 'package:mobile/features/feeding/presentation/screens/feed_statistics_screen.dart';
import 'package:mobile/features/feeding/presentation/screens/feeding_statistics_screen.dart';
import 'package:mobile/features/finance/data/models/transaction_model.dart';
import 'package:mobile/features/finance/presentation/providers/transactions_provider.dart';
import 'package:mobile/features/finance/presentation/screens/transaction_statistics_screen.dart';

final _financeStats = FinancialStatistics(
  totalIncome: 184500,
  totalExpenses: 96200,
  netProfit: 88300,
  totalTransactions: 37,
  incomeByCategory: const [
    CategoryStatistics(
      category: TransactionCategory.saleRabbit,
      total: 142000,
      count: 21,
    ),
    CategoryStatistics(
      category: TransactionCategory.saleMeat,
      total: 42500,
      count: 6,
    ),
  ],
  expensesByCategory: const [
    CategoryStatistics(
      category: TransactionCategory.feed,
      total: 71400,
      count: 8,
    ),
    CategoryStatistics(
      category: TransactionCategory.veterinary,
      total: 24800,
      count: 2,
    ),
  ],
  recentTransactions: [
    Transaction(
      id: 4120,
      type: TransactionType.income,
      category: TransactionCategory.saleRabbit,
      amount: 12000,
      transactionDate: DateTime(2026, 3, 2),
    ),
    Transaction(
      id: 4119,
      type: TransactionType.expense,
      category: TransactionCategory.feed,
      amount: 8450,
      transactionDate: DateTime(2026, 2, 27),
    ),
  ],
);

const _emptyFinanceStats = FinancialStatistics(
  totalIncome: 0,
  totalExpenses: 0,
  netProfit: 0,
  totalTransactions: 0,
  incomeByCategory: [],
  expensesByCategory: [],
  recentTransactions: [],
);

const _feedStats = FeedStatistics(
  totalFeeds: 9,
  byType: FeedTypeStats(
    pellets: 3,
    hay: 2,
    vegetables: 2,
    grain: 1,
    supplements: 1,
    other: 0,
  ),
  lowStockCount: 2,
  lowStockItems: [
    LowStockItem(
      id: 12,
      name: 'Гранулы «Премиум»',
      currentStock: 8.5,
      minStock: 25,
      unit: 'кг',
    ),
    LowStockItem(
      id: 18,
      name: 'Люцерновое сено',
      currentStock: 14,
      minStock: 20,
      unit: 'кг',
    ),
  ],
  totalStockValue: 43700,
);

const _feedingStats = FeedingStatistics(
  totalFeedings: 214,
  totalQuantity: 486.5,
  byFeedType: FeedingByType(
    pellets: 240.5,
    hay: 180,
    vegetables: 46,
    grain: 20,
    supplements: 0,
    other: 0,
  ),
  byFeed: {
    'Гранулы «Премиум»': FeedingByFeed(quantity: 240.5, unit: 'кг', cost: 31265),
    'Люцерновое сено': FeedingByFeed(quantity: 180, unit: 'кг', cost: 9000),
  },
  totalCost: 40265,
);

/// Скелетон загрузки пульсирует бесконечно, поэтому `pumpAndSettle` на этих
/// экранах не сходится: ждём завершения провайдера и доигрываем анимацию полос
/// разбивки вручную. Окно растягиваем, потому что экран длиннее стандартных
/// 800x600, а `ListView` строит только видимые элементы.
Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _wrap(Widget screen, List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: screen,
      ),
    );

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU', null));

  group('Экран аналитики финансов', () {
    testWidgets('показывает суммы, прибыль и разбивку по категориям',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const TransactionStatisticsScreen(),
        [
          financialStatisticsProvider
              .overrideWith((ref, params) async => _financeStats),
        ],
      ));
      await _settle(tester);

      expect(find.text('Аналитика финансов'), findsOneWidget);
      expect(find.text('184\u00A0500 ₽'), findsOneWidget); // доходы
      expect(find.text('96\u00A0200 ₽'), findsOneWidget); // расходы
      expect(find.text('88\u00A0300 ₽'), findsOneWidget); // прибыль
      expect(find.text('Прибыль'), findsOneWidget);
      expect(find.text('37 операций'), findsOneWidget);
      expect(find.text('ДОХОДЫ ПО КАТЕГОРИЯМ'), findsOneWidget);
      expect(find.text('Продажа кролика'), findsWidgets);
      expect(find.text('ПОСЛЕДНИЕ ОПЕРАЦИИ'), findsOneWidget);
    });

    testWidgets('показывает убыток, когда расходы больше доходов',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const TransactionStatisticsScreen(),
        [
          financialStatisticsProvider.overrideWith((ref, params) async =>
              _financeStats.copyWith(
                  totalIncome: 10000, totalExpenses: 25000, netProfit: -15000)),
        ],
      ));
      await _settle(tester);

      expect(find.text('Убыток'), findsOneWidget);
      expect(find.text('15\u00A0000 ₽'), findsOneWidget);
    });

    testWidgets('на пустом периоде предлагает добавить операцию',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const TransactionStatisticsScreen(),
        [
          financialStatisticsProvider
              .overrideWith((ref, params) async => _emptyFinanceStats),
        ],
      ));
      await _settle(tester);

      expect(find.text('За этот период операций не было'), findsOneWidget);
      expect(find.text('Добавить операцию'), findsOneWidget);
    });

    testWidgets('на ошибке предлагает повторить', (tester) async {
      await tester.pumpWidget(_wrap(
        const TransactionStatisticsScreen(),
        [
          financialStatisticsProvider.overrideWith(
              (ref, params) async => throw Exception('нет сети')),
        ],
      ));
      await _settle(tester);

      expect(find.text('Ошибка загрузки'), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
    });
  });

  group('Экран аналитики склада', () {
    testWidgets('показывает состав склада и позиции на исходе',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FeedStatisticsScreen(),
        [feedStatisticsProvider.overrideWith((ref) async => _feedStats)],
      ));
      await _settle(tester);

      expect(find.text('Аналитика склада'), findsOneWidget);
      expect(find.text('9'), findsOneWidget); // позиций на складе
      expect(find.text('43\u00A0700 ₽'), findsOneWidget); // стоимость запаса
      expect(find.text('СОСТАВ ПО ТИПАМ'), findsOneWidget);
      expect(find.text('Гранулы'), findsOneWidget);
      expect(find.text('ОСТАТКИ НА ИСХОДЕ'), findsOneWidget);
      expect(find.text('Гранулы «Премиум»'), findsOneWidget);
      expect(find.text('8,5 кг'), findsOneWidget);
      expect(find.text('минимум 25 кг'), findsOneWidget);
    });

    testWidgets('при достаточных запасах не пугает предупреждением',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FeedStatisticsScreen(),
        [
          feedStatisticsProvider.overrideWith((ref) async =>
              _feedStats.copyWith(lowStockCount: 0, lowStockItems: [])),
        ],
      ));
      await _settle(tester);

      expect(find.text('Запасов хватает по всем позициям'), findsOneWidget);
    });

    testWidgets('на пустом складе предлагает добавить корм', (tester) async {
      await tester.pumpWidget(_wrap(
        const FeedStatisticsScreen(),
        [
          feedStatisticsProvider.overrideWith((ref) async => _feedStats
              .copyWith(totalFeeds: 0, lowStockCount: 0, lowStockItems: [])),
        ],
      ));
      await _settle(tester);

      expect(find.text('Склад пока пуст'), findsOneWidget);
      expect(find.text('Добавить корм'), findsOneWidget);
    });
  });

  group('Экран аналитики кормлений', () {
    testWidgets('показывает число кормлений, затраты и расход по кормам',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FeedingStatisticsScreen(),
        [
          feedingStatisticsProvider
              .overrideWith((ref, params) async => _feedingStats),
        ],
      ));
      await _settle(tester);

      expect(find.text('Аналитика кормлений'), findsOneWidget);
      expect(find.text('214'), findsOneWidget);
      expect(find.text('40\u00A0265 ₽'), findsOneWidget);
      expect(find.text('РАСХОД ПО ТИПАМ КОРМА'), findsOneWidget);
      expect(find.text('ПО КОРМАМ'), findsOneWidget);
      expect(find.text('240,5 кг'), findsOneWidget);
    });

    testWidgets('на пустом периоде предлагает записать кормление',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FeedingStatisticsScreen(),
        [
          feedingStatisticsProvider.overrideWith((ref, params) async =>
              _feedingStats.copyWith(
                totalFeedings: 0,
                totalQuantity: 0,
                totalCost: 0,
                byFeed: const {},
              )),
        ],
      ));
      await _settle(tester);

      expect(find.text('За этот период кормлений не было'), findsOneWidget);
      expect(find.text('Записать кормление'), findsOneWidget);
    });
  });
}
