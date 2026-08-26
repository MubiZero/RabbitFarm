/// Собирает весь список из постраничного эндпоинта.
///
/// Выпадающие поля форм просили у сервера сразу всё одним запросом с
/// `limit: 200`. Сервер ограничивает страницу сотней (это осознанная защита:
/// без неё `?limit=500000` поднимал в память таблицу целиком), поэтому в
/// ответ приходило 422 — и форма показывала «клеток пока нет» там, где на
/// ферме их десять. Ошибка выглядела как пустота, и искать было нечего.
///
/// Здесь страницы честно перебираются до конца. Потолок нужен, чтобы опечатка
/// на сервере не увела клиент в бесконечный цикл: на ферме сотни клеток и
/// десятки кормов, тысячи страниц означают поломку, а не большое хозяйство.
const int kMaxPageSize = 100;

Future<List<T>> loadAllPages<T>(
  Future<List<T>> Function({required int page, required int limit}) fetch, {
  int pageSize = kMaxPageSize,
  int maxPages = 20,
}) async {
  final all = <T>[];

  for (var page = 1; page <= maxPages; page++) {
    final chunk = await fetch(page: page, limit: pageSize);
    all.addAll(chunk);
    if (chunk.length < pageSize) break;
  }

  return all;
}
