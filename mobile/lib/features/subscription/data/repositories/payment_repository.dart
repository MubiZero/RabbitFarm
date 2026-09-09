import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_error.dart';
import '../models/payment_order.dart';

/// Оплата продления тарифа (см. docs/plans/PLATFORM-ADMIN.md, 4.1). Сумму
/// назначает сервер по тарифу фермы — тело запроса на создание заказа пустое.
class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  /// Создать заказ на оплату текущего тарифа фермы.
  Future<PaymentOrder> createPayment() async {
    return guardRequest(() async {
      final response = await _apiClient.post(ApiEndpoints.payments);
      return PaymentOrder.fromJson(response.data['data']);
    }, 'Не удалось создать заказ на оплату');
  }

  /// Ручной опрос статуса — не дожидаясь вебхука банка. Возвращает статус
  /// платежа банка: `new` / `completed` / `failed`.
  Future<String> checkStatus(String invoiceId) async {
    return guardRequest(() async {
      final response = await _apiClient.get(ApiEndpoints.paymentStatus(invoiceId));
      return response.data['data']['status'] as String;
    }, 'Не удалось проверить статус оплаты');
  }
}
