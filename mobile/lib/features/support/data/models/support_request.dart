import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/models/user_ref.dart';

part 'support_request.freezed.dart';
part 'support_request.g.dart';

/// Обращение фермы в поддержку — то, как его видит сама ферма.
///
/// Своя модель, а не общая с админкой: ферме не нужно поле `farm` (оно всегда
/// её собственное), зато нужен ответ поддержки, ради которого экран и
/// существует. Автор оставлен: в хозяйстве с работниками важно понимать, кто
/// из своих писал.
@freezed
abstract class SupportRequest with _$SupportRequest {
  const factory SupportRequest({
    @IntConverter() required int id,
    required String text,
    @Default('new') String status,

    /// Что ответила поддержка. `null` — ответа ещё нет.
    String? answer,
    @JsonKey(name: 'resolved_at')
    @NullableDateTimeConverter()
    DateTime? resolvedAt,
    UserRef? author,
    @JsonKey(name: 'created_at')
    @DateTimeConverter()
    required DateTime createdAt,
  }) = _SupportRequest;

  const SupportRequest._();

  bool get isResolved => status == 'resolved';

  /// Ответ есть и его есть что показать: пустую строку сервер вернуть может,
  /// а рисовать ради неё блок «Ответ поддержки» — обманывать.
  bool get hasAnswer => (answer?.trim().isNotEmpty ?? false);

  factory SupportRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFromJson(json);
}
