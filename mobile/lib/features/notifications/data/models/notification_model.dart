/// Одно сообщение в ленте уведомлений.
///
/// Текст приходит уже собранным на языке читателя: сервер хранит ключ
/// словаря и подстановки, а фразу складывает в момент чтения — иначе смена
/// языка в настройках оставила бы старую ленту на прежнем языке.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.route,
    this.type,
    this.readAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;

  /// Куда ведёт нажатие — тот же адрес, что у тапа по пушу.
  final String? route;

  /// Вид сообщения: по нему выбирается значок.
  final String? type;

  final DateTime? readAt;

  bool get isRead => readAt != null;

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: (json['id'] as num).toInt(),
    title: json['title']?.toString() ?? '',
    body: json['body']?.toString() ?? '',
    createdAt:
        DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    route: json['route']?.toString(),
    type: json['type']?.toString(),
    readAt: DateTime.tryParse(json['read_at']?.toString() ?? ''),
  );
}
