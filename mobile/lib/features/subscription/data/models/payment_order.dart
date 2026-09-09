import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/double_converter.dart';

part 'payment_order.freezed.dart';
part 'payment_order.g.dart';

/// Заказ на оплату продления тарифа (см. docs/plans/PLATFORM-ADMIN.md, 4.1).
/// Сумму и описание считает сервер по тарифу фермы — здесь только то, что
/// нужно, чтобы отправить владельца платить и потом проверить результат.
@freezed
abstract class PaymentOrder with _$PaymentOrder {
  const factory PaymentOrder({
    @JsonKey(name: 'invoice_id') required String invoiceId,
    @DoubleConverter() required double amount,
    String? qr,
    @JsonKey(name: 'invoice_url') String? invoiceUrl,
    @JsonKey(name: 'deep_link') String? deepLink,
  }) = _PaymentOrder;

  factory PaymentOrder.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderFromJson(json);
}
