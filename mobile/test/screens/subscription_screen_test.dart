import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/reports/data/models/report_model.dart';
import 'package:mobile/features/reports/presentation/providers/reports_provider.dart';
import 'package:mobile/features/subscription/data/models/payment_order.dart';
import 'package:mobile/features/subscription/data/repositories/payment_repository.dart';
import 'package:mobile/features/subscription/presentation/providers/payment_provider.dart';
import 'package:mobile/features/subscription/presentation/screens/subscription_screen.dart';

import '../support/test_app.dart';

/// Дашборд с тарифом-фикстурой — остальные блоки этому экрану не нужны, но
/// `DashboardReport` требует их все.
DashboardReport _dashboard(PlanUsagePlan? plan) => DashboardReport(
      rabbits: const RabbitStats(total: 1, male: 1, female: 0),
      cages: const CageStats(total: 1, occupied: 0, available: 1),
      health: const HealthStats(upcomingVaccinations: 0, overdueVaccinations: 0),
      tasks: const TaskStats(pending: 0, overdue: 0, urgent: 0),
      inventory: const InventoryStats(lowStockFeeds: 0),
      breeding: const BreedingStats(recentBirths: 0),
      planUsage: PlanUsage(
        rabbits: const ResourceUsage(used: 1, limit: 30),
        staff: const ResourceUsage(used: 1, limit: 3),
        plan: plan,
      ),
    );

/// Репозиторий без сети. `statuses` — ответы `checkStatus` по порядку вызовов
/// (последний повторяется, если проверок больше, чем элементов).
class _FakePaymentRepository extends PaymentRepository {
  _FakePaymentRepository({this.createError, this.statuses = const []})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final Object? createError;
  final List<String> statuses;
  int _checkCalls = 0;
  int createCalls = 0;

  @override
  Future<PaymentOrder> createPayment() async {
    createCalls++;
    if (createError != null) throw createError!;
    return const PaymentOrder(
      invoiceId: 'inv1',
      amount: 50,
      qr: 'qr-data',
      invoiceUrl: 'https://pay.example/1',
      deepLink: 'eskhata://pay/1',
    );
  }

  @override
  Future<String> checkStatus(String invoiceId) async {
    final status = _checkCalls < statuses.length
        ? statuses[_checkCalls]
        : (statuses.isEmpty ? 'new' : statuses.last);
    _checkCalls++;
    return status;
  }
}

Widget _screen({PlanUsagePlan? plan, PaymentRepository? repository}) =>
    testAppScreen(
      const SubscriptionScreen(),
      overrides: [
        dashboardReportProvider.overrideWith((ref) async => _dashboard(plan)),
        paymentRepositoryProvider
            .overrideWithValue(repository ?? _FakePaymentRepository()),
      ],
    );

void main() {
  group('Экран «Тариф»', () {
    testWidgets('без тарифа объясняет, что делать', (tester) async {
      await tester.pumpWidget(_screen(plan: null));
      await tester.pumpAndSettle();

      expect(find.text('Тариф не назначен'), findsOneWidget);
      expect(find.text('Оплатить'), findsNothing);
    });

    testWidgets('бесплатный тариф не предлагает оплату', (tester) async {
      await tester.pumpWidget(_screen(
        plan: const PlanUsagePlan(id: 1, name: 'Бесплатный'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Бесплатный тариф'), findsOneWidget);
      expect(find.text('Оплатить'), findsNothing);
    });

    testWidgets('платный тариф показывает цену, срок и кнопку оплаты',
        (tester) async {
      await tester.pumpWidget(_screen(
        plan: PlanUsagePlan(
          id: 2,
          name: 'Базовый',
          price: 50,
          expiresAt: DateTime(2026, 10, 1),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Базовый'), findsOneWidget);
      expect(find.text('50 с / 30 дней'), findsOneWidget);
      expect(find.text('Действует до 01.10.2026'), findsOneWidget);
      expect(find.text('Оплатить'), findsOneWidget);
    });

    testWidgets('истёкший тариф подписан как истёкший', (tester) async {
      await tester.pumpWidget(_screen(
        plan: PlanUsagePlan(
          id: 2,
          name: 'Базовый',
          price: 50,
          expiresAt: DateTime(2026, 8, 1),
          isExpired: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Срок истёк 01.08.2026'), findsOneWidget);
    });

    testWidgets('оплата создаёт заказ и предлагает открыть страницу оплаты',
        (tester) async {
      final repository = _FakePaymentRepository();
      await tester.pumpWidget(_screen(
        plan: const PlanUsagePlan(id: 2, name: 'Базовый', price: 50),
        repository: repository,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Оплатить'));
      await tester.pumpAndSettle();

      expect(repository.createCalls, 1);
      expect(find.text('Открыть страницу оплаты'), findsOneWidget);
      expect(find.text('Проверить оплату'), findsOneWidget);
    });

    testWidgets('подтверждённая оплата показывает успех', (tester) async {
      final repository = _FakePaymentRepository(statuses: const ['completed']);
      await tester.pumpWidget(_screen(
        plan: const PlanUsagePlan(id: 2, name: 'Базовый', price: 50),
        repository: repository,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Оплатить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Проверить оплату'));
      await tester.pumpAndSettle();

      expect(find.text('Оплата прошла, тариф продлён'), findsOneWidget);
    });

    testWidgets('неподтверждённая оплата — подсказка подождать, а не ошибка',
        (tester) async {
      final repository = _FakePaymentRepository(statuses: const ['new']);
      await tester.pumpWidget(_screen(
        plan: const PlanUsagePlan(id: 2, name: 'Базовый', price: 50),
        repository: repository,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Оплатить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Проверить оплату'));
      await tester.pumpAndSettle();

      expect(find.textContaining('ещё не подтвердил'), findsOneWidget);
      // Карточка оплаты остаётся — платёж ещё можно проверить снова.
      expect(find.text('Проверить оплату'), findsOneWidget);
    });

    testWidgets('ошибка создания заказа показана снекбаром', (tester) async {
      final repository = _FakePaymentRepository(
        createError: Exception('Ферме не назначен тариф'),
      );
      await tester.pumpWidget(_screen(
        plan: const PlanUsagePlan(id: 2, name: 'Базовый', price: 50),
        repository: repository,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Оплатить'));
      await tester.pumpAndSettle();

      expect(find.text('Ферме не назначен тариф'), findsOneWidget);
    });
  });
}
