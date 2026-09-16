import '../../rabbits/data/models/breeding_model.dart';
import 'breeding_cycle.dart';

/// Строка бумажного плана окролов: один ожидаемый окрол.
///
/// Лист вешают в сарае на гвоздь, поэтому в строке только то, что помогает
/// дойти до нужной клетки и ничего не пропустить: когда ждать окрол, чья это
/// самка, где она сидит и когда ставить маточник.
class KindlingPlanRow {
  /// Ожидаемый день окрола.
  final DateTime birthDate;

  /// Когда поставить маточник. Ради этой колонки план и печатают: опоздать с
  /// маточником — потерять помёт.
  final DateTime nestBoxDate;

  /// День случки. Пустой у записи, в которой дата не разобралась.
  final DateTime? breedingDate;

  /// Кличка самки, иначе клеймо, иначе номер — тот же порядок, что в
  /// приложении, чтобы на бумаге и на экране кролик назывался одинаково.
  final String female;

  /// Номер клетки. Сервер отдаёт его не всегда, а выдумывать его нельзя.
  final String? cage;

  const KindlingPlanRow({
    required this.birthDate,
    required this.nestBoxDate,
    required this.breedingDate,
    required this.female,
    required this.cage,
  });
}

/// План окролов на месяц: строки по порядку дней.
///
/// Чистая функция — то, что попадёт на бумагу, должно проверяться без
/// запуска печати и без экрана.
///
/// В план идут только случки, по которым окрол ещё ждут: отменённые,
/// неудачные, пустые самки и уже записанные окролы на листе «что сделать» не
/// нужны — их нельзя ни пропустить, ни успеть.
List<KindlingPlanRow> kindlingPlanForMonth(
  List<BreedingModel> breedings, {
  required DateTime month,
}) {
  final rows = <KindlingPlanRow>[];

  for (final breeding in breedings) {
    if (BreedingStatus.fromValue(breeding.status) != BreedingStatus.planned) {
      continue;
    }
    // Прощупывание показало пустую самку — окрола не будет.
    if (breeding.isPregnant == false) continue;

    final expected = expectedBirthDay(breeding);
    if (expected == null) continue;
    if (expected.year != month.year || expected.month != month.month) continue;

    rows.add(
      KindlingPlanRow(
        birthDate: expected,
        nestBoxDate: expected.subtract(
          const Duration(days: BreedingCycleDays.nestBoxBeforeBirth),
        ),
        breedingDate: dayOfDateString(breeding.breedingDate),
        female: breeding.female?.label ?? '#${breeding.femaleId}',
        cage: _cageNumber(breeding),
      ),
    );
  }

  // Лист читают сверху вниз по дням; в один день бывает несколько окролов —
  // тогда порядок задаёт кличка, чтобы две печати подряд не отличались.
  rows.sort((a, b) {
    final byDay = a.birthDate.compareTo(b.birthDate);
    if (byDay != 0) return byDay;
    return a.female.compareTo(b.female);
  });

  return rows;
}

String? _cageNumber(BreedingModel breeding) {
  final number = breeding.female?.cage?.number.trim();
  return (number == null || number.isEmpty) ? null : number;
}
