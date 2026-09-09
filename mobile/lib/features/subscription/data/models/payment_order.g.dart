// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentOrder _$PaymentOrderFromJson(Map<String, dynamic> json) =>
    _PaymentOrder(
      invoiceId: json['invoice_id'] as String,
      amount: const DoubleConverter().fromJson(json['amount'] as Object),
      qr: json['qr'] as String?,
      invoiceUrl: json['invoice_url'] as String?,
      deepLink: json['deep_link'] as String?,
    );

Map<String, dynamic> _$PaymentOrderToJson(_PaymentOrder instance) =>
    <String, dynamic>{
      'invoice_id': instance.invoiceId,
      'amount': const DoubleConverter().toJson(instance.amount),
      'qr': instance.qr,
      'invoice_url': instance.invoiceUrl,
      'deep_link': instance.deepLink,
    };
