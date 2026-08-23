import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cage_model.dart';
import '../../data/repositories/cages_repository.dart';

/// Ряд крольчатника: клетки, стоящие в одном месте.
///
/// [location] равен `null`, когда место у клетки не указано. Пустая строка и
/// отсутствие места — это одно и то же, поэтому пустая строка сюда не
/// доезжает: иначе в списке рядов появился бы безымянный ряд рядом с
/// «место не указано», и это выглядело бы как два разных места.
class CageRow {
  final String? location;
  final List<CageModel> cages;

  const CageRow({required this.location, required this.cages});

  int get capacity => cages.fold(0, (sum, cage) => sum + cage.capacity);

  int get occupied => cages.fold(
        0,
        (sum, cage) => sum + (cage.currentOccupancy ?? cage.rabbits?.length ?? 0),
      );
}

/// Карта фермы: все клетки, разложенные по рядам.
///
/// Клетки приходят страницами, а ряд — это не страница. Если раскладывать по
/// местам то, что успело приехать, «второй ряд» окажется наполовину пустым и
/// будет достраиваться на глазах, а счётчик занятости под его названием
/// покажет неправду. Поэтому здесь список вычитывается целиком и только потом
/// группируется.
final cageRowsProvider = FutureProvider.autoDispose<List<CageRow>>((ref) async {
  final repository = ref.watch(cagesRepositoryProvider);

  const pageSize = 100; // Потолок сервера на одну страницу списка клеток.
  const maxPages = 20; // Ферма на две тысячи клеток — уже не мобильный экран.

  final cages = <CageModel>[];
  for (var page = 1; page <= maxPages; page++) {
    final batch = await repository.getCages(page: page, limit: pageSize);
    cages.addAll(batch);
    if (batch.length < pageSize) break;
  }

  return groupCagesByLocation(cages);
});

/// Разложить клетки по рядам: сами ряды по алфавиту, клетки внутри — по
/// номеру, безымянный ряд — в конец.
///
/// Вынесено из провайдера, чтобы порядок можно было проверить тестом без
/// сети: именно порядок здесь и есть вся суть карты.
List<CageRow> groupCagesByLocation(List<CageModel> cages) {
  final byLocation = <String, List<CageModel>>{};
  final homeless = <CageModel>[];

  for (final cage in cages) {
    final location = cage.location?.trim() ?? '';
    if (location.isEmpty) {
      homeless.add(cage);
    } else {
      byLocation.putIfAbsent(location, () => []).add(cage);
    }
  }

  final rows = byLocation.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  return [
    for (final location in rows)
      CageRow(
        location: location,
        cages: byLocation[location]!..sort(compareCageNumbers),
      ),
    // Клетки без места идут последними и с честной подписью: спрятать их
    // значило бы потерять клетки, а подмешать в первый ряд — соврать, где они
    // стоят.
    if (homeless.isNotEmpty)
      CageRow(location: null, cages: homeless..sort(compareCageNumbers)),
  ];
}

/// Номера клеток сравниваются по числу, а не посимвольно: иначе «10» встаёт
/// между «1» и «2», и ряд в приложении не совпадает с рядом в сарае.
int compareCageNumbers(CageModel a, CageModel b) {
  final left = int.tryParse(a.number.trim());
  final right = int.tryParse(b.number.trim());
  if (left != null && right != null) return left.compareTo(right);
  return a.number.toLowerCase().compareTo(b.number.toLowerCase());
}
