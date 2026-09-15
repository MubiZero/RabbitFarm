import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Банк отказал. Состояние окончательное: повторная проверка того же
  /// заказа ничего не изменит, нужен новый.
  declined,

  /// Не получилось даже спросить банк — оборвалась связь с нашим сервером.
  /// Отдельно от [declined] потому, что это разные советы человеку:
  /// «попробуйте ещё раз» против «платите заново».
  checkFailed,

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

  /// Ждём ли мы ещё денег по этому заказу.
  bool get isPending =>
      order != null &&
      (status == PaymentFlowStatus.awaitingPayment ||
          status == PaymentFlowStatus.checking ||
          status == PaymentFlowStatus.checkFailed);

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
  PaymentFlowNotifier(this._ref) : super(const PaymentFlowState()) {
    _restore();
  }

  final Ref _ref;

  /// Номер заказа, по которому ещё ждём денег.
  ///
  /// Оплата уходит в приложение банка, и наш экран за это время система
  /// вполне может выгрузить. Раньше заказ жил только в памяти открытого
  /// экрана: вернувшись, человек видел снова кнопку «Оплатить» и не имел
  /// никакого способа проверить уже сделанный платёж. Если при этом не
  /// дошёл и вебхук банка, деньги списаны, а тариф не продлён.
  static const _pendingInvoiceKey = 'payment_pending_invoice';

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final invoiceId = prefs.getString(_pendingInvoiceKey);
    if (invoiceId == null || !mounted || state.order != null) return;

    state = PaymentFlowState(
      status: PaymentFlowStatus.awaitingPayment,
      // Ссылки на оплату и суммы у восстановленного заказа нет — она
      // была в ответе сервера, который мы уже не держим. Для проверки
      // статуса хватает номера, а платить повторно по той же ссылке
      // всё равно не нужно.
      order: PaymentOrder(invoiceId: invoiceId, amount: 0),
    );
  }

  Future<void> _rememberInvoice(String? invoiceId) async {
    final prefs = await SharedPreferences.getInstance();
    if (invoiceId == null) {
      await prefs.remove(_pendingInvoiceKey);
      return;
    }
    await prefs.setString(_pendingInvoiceKey, invoiceId);
  }

  Future<void> pay() async {
    state = const PaymentFlowState(status: PaymentFlowStatus.creating);
    try {
      final order = await _ref.read(paymentRepositoryProvider).createPayment();
      await _rememberInvoice(order.invoiceId);
      if (!mounted) return;
      state = PaymentFlowState(
        status: PaymentFlowStatus.awaitingPayment,
        order: order,
      );
    } catch (e) {
      state = PaymentFlowState(status: PaymentFlowStatus.failed, error: e);
    }
  }

  /// Опрос статуса своего же заказа.
  ///
  /// Исходов три, и путать их нельзя: банк подтвердил, банк отказал, банк
  /// ещё думает. Отдельно от всех трёх — «мы не смогли спросить»: раньше
  /// оборванная связь показывалась человеку как «банк ещё не подтвердил»,
  /// то есть сообщением о состоянии платежа, которого никто не проверял.
  Future<void> checkPayment() async {
    final order = state.order;
    if (order == null) return;

    state = state.copyWith(status: PaymentFlowStatus.checking);
    try {
      final status = await _ref
          .read(paymentRepositoryProvider)
          .checkStatus(order.invoiceId);
      if (!mounted) return;

      if (status == 'completed') {
        await _rememberInvoice(null);
        if (!mounted) return;
        state = state.copyWith(status: PaymentFlowStatus.completed);
        // Карточка тарифа на «Сегодня» и здесь читает один и тот же дашборд —
        // без сброса он показывал бы старый срок до следующего открытия.
        _ref.invalidate(dashboardReportProvider);
        return;
      }

      if (status == 'failed') {
        await _rememberInvoice(null);
        if (!mounted) return;
        state = state.copyWith(status: PaymentFlowStatus.declined);
        return;
      }

      state = state.copyWith(status: PaymentFlowStatus.awaitingPayment);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(status: PaymentFlowStatus.checkFailed, error: e);
    }
  }

  /// Начать заново после отказа банка.
  Future<void> reset() async {
    await _rememberInvoice(null);
    if (mounted) state = const PaymentFlowState();
  }
}

/// Не `autoDispose`: заказ должен пережить уход с экрана оплаты — человек
/// уходит платить в приложение банка и возвращается уже в другой сеанс.
final paymentFlowProvider =
    StateNotifierProvider<PaymentFlowNotifier, PaymentFlowState>(
        (ref) => PaymentFlowNotifier(ref));
