/// Разбор общего конверта списков.
///
/// Сервер отдаёт списки в виде `data: { items, pagination }`. Раньше форма
/// отличалась от ресурса к ресурсу — items, rows, tasks, transactions, а
/// счётчик страниц назывался то totalPages, то pages, — и каждый репозиторий
/// угадывал её сам. В медкартах угадал неверно: экран показывал пустой список,
/// хотя данные приходили.
library;

/// Элементы списка из ответа сервера.
///
/// Принимает и «голый» массив: часть эндпоинтов отдаёт список без пагинации.
List<dynamic> itemsOf(dynamic data) {
  if (data is List) return data;
  if (data is Map) {
    final items = data['items'];
    if (items is List) return items;
  }
  return const [];
}

/// Метаданные постраничного вывода.
class PageInfo {
  const PageInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;

  static int _toInt(Object? value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  factory PageInfo.of(dynamic data, {int fallbackCount = 0}) {
    final pagination = (data is Map ? data['pagination'] : null);
    if (pagination is! Map) {
      return PageInfo(
        page: 1,
        limit: fallbackCount,
        total: fallbackCount,
        totalPages: 1,
      );
    }

    return PageInfo(
      page: _toInt(pagination['page'], 1),
      limit: _toInt(pagination['limit'], fallbackCount),
      total: _toInt(pagination['total'], fallbackCount),
      totalPages: _toInt(pagination['totalPages'], 1),
    );
  }

  bool get hasMore => page < totalPages;
}
