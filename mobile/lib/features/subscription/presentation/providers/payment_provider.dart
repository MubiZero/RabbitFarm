import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/api_providers.dart';
import '../../../reports/presentation/providers/reports_provider.dart';
import '../../data/models/payment_order.dart';
import '../../data/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PaymentRepository(apiClient);
});

enum PaymentFlowStatus {
  idle,
  creating,
  awaitingPayment,
  checking,
  completed,
  failed,
}

class PaymentFlowState {
  const PaymentFlowState({
    this.status = PaymentFlowStatus.idle,
    this.order,
    this.error,
  });

  final PaymentFlowStatus status;
  final PaymentOrder? order;
  final Object? error;

  PaymentFlowState copyWith({
    PaymentFlowStatus? status,
    PaymentOrder? order,
    Object? error,
  }) {
    return PaymentFlowState(
      status: status ?? this.status,
      order: order ?? this.order,
      error: error,
    );
  }
}

/// Оплата продления тарифа одной кнопкой (см.
/// docs/plans/PLATFORM-ADMIN.md, 4.1): создать заказ, отправить владельца
/// платить по ссылке банка, потом проверить результат вручную — не дожидаясь
/// вебхука, которого мобильное приложение не видит вовсе.
class PaymentFlowNotifier extends StateNotifier<PaymentFlowState> {
  PaymentFlowNotifier(this._ref) : super(const PaymentFlowState());

  final Ref _ref;

  Future<void> pay() async {
    state = const PaymentFlowState(status: PaymentFlowStatus.creating);
    try {
      final order = await _ref.read(paymentRepositoryProvider).createPayment();
      state = PaymentFlowState(
        status: PaymentFlowStatus.awaitingPayment,
        order: order,
      );
    } catch (e) {
      state = PaymentFlowState(status: PaymentFlowStatus.failed, error: e);
    }
  }

  /// Опрос статуса своего же заказа. Платёж мог остаться неподтверждённым —
  /// это не ошибка запроса, а обычный промежуточный исход, поэтому остаёмся
  /// в `awaitingPayment`, а не проваливаемся в `failed`.
  Future<void> checkPayment() async {
    final order = state.order;
    if (order == null) return;

    state = state.copyWith(status: PaymentFlowStatus.checking);
    try {
      final status =
          await _ref.read(paymentRepositoryProvider).checkStatus(order.invoiceId);
      if (status == 'completed') {
        state = state.copyWith(status: PaymentFlowStatus.completed);
        // Карточка тарифа на «Сегодня» и здесь читает один и тот же дашборд —
        // без сброса он показывал бы старый срок до следующего открытия.
        _ref.invalidate(dashboardReportProvider);
      } else {
        state = state.copyWith(status: PaymentFlowStatus.awaitingPayment);
      }
    } catch (e) {
      state = state.copyWith(status: PaymentFlowStatus.awaitingPayment, error: e);
    }
  }

  void reset() => state = const PaymentFlowState();
}

final paymentFlowProvider =
    StateNotifierProvider.autoDispose<PaymentFlowNotifier, PaymentFlowState>(
        (ref) => PaymentFlowNotifier(ref));
