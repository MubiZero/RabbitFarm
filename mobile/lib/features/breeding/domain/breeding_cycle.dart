import '../../rabbits/data/models/breeding_model.dart';

/// Сроки кроличьего цикла — одним местом на всё приложение.
///
/// Числа не выдуманы клиентом, они повторяют то, что уже считает сервер:
/// `backend/src/models/Breeding.js` ставит ожидаемый окрол на 31-й день после
/// случки, `breedingService` заводит задачу на пальпацию на 14-й день, а
/// `birthController` — задачу на отсадку на 45-й день после окрола. Если
/// развести эти числа, фермер увидит в ленте одну дату, а в задачах другую и
/// перестанет верить обеим.
///
/// Все сроки приблизительные: сукрольность длится 28–34 дня, прощупывают с
/// 10-го по 14-й день, отсаживают с 40-го по 50-й. Это ориентир «когда пора
/// подойти к клетке», а не расписание с точностью до суток.
abstract class BreedingCycleDays {
  /// Сукрольность: от случки до окрола.
  static const gestation = 31;

  /// Прощупывание: раньше 10-го дня плоды не прощупываются, к 14-му уже пора.
  static const pregnancyCheck = 14;

  /// После третьей недели прощупывать поздно — ближе следующее дело, окрол.
  static const pregnancyCheckLatest = 21;

  /// Отсадка молодняка от самки — считается от дня окрола.
  static const weaning = 45;
}

/// Где случка находится прямо сейчас.
enum BreedingCycleStage {
  /// Покрыта, пора проверить сукрольность.
  pregnancyCheck,

  /// Сукрольность идёт, ждём окрол.
  birthExpected,

  /// Окрол записан, впереди отсадка молодняка.
  weaning,

  /// Прощупывание показало, что самка пустая.
  notPregnant,

  /// Случка не удалась.
  failed,

  /// Случку отменили.
  cancelled,

  /// Цикл отработан: молодняк пора было отсадить, делать больше нечего.
  closed,
}

/// Стадия цикла и ближайшее дело по ней.
class BreedingCycleStatus {
  final BreedingCycleStage stage;

  /// Когда подойти к клетке. `null` — делать нечего либо считать не от чего
  /// (в записи нет разбираемой даты случки).
  final DateTime? actionDate;

  /// Какой день цикла идёт: день случки — первый. До случки — ноль и меньше,
  /// `null` — дата случки не разобралась.
  final int? dayOfCycle;

  const BreedingCycleStatus({
    required this.stage,
    this.actionDate,
    this.dayOfCycle,
  });

  /// Срок прошёл — с точностью до дня.
  bool isOverdue({DateTime? now}) {
    final date = actionDate;
    if (date == null) return false;
    return date.isBefore(_dayOf(now ?? DateTime.now()));
  }
}

/// Стадия цикла по записи о случке.
///
/// Чистая функция: фермер думает «самка №12, 25-й день», а не «поле status
/// равно planned», и переводить одно в другое должно одно место, проверяемое
/// без запуска экрана.
BreedingCycleStatus breedingCycleStatus(
  BreedingModel breeding, {
  DateTime? now,
}) {
  final today = _dayOf(now ?? DateTime.now());
  final bred = _dayOfString(breeding.breedingDate);

  // Ожидаемый окрол приходит с сервера; если поле пустое, считаем сами по той
  // же формуле, чтобы строка ленты не осталась без ближайшего дела.
  final expected = _dayOfString(breeding.expectedBirthDate) ??
      bred?.add(const Duration(days: BreedingCycleDays.gestation));

  final day = bred == null ? null : today.difference(bred).inDays + 1;

  switch (BreedingStatus.fromValue(breeding.status)) {
    case BreedingStatus.failed:
      return BreedingCycleStatus(
        stage: BreedingCycleStage.failed,
        dayOfCycle: day,
      );

    case BreedingStatus.cancelled:
      return BreedingCycleStatus(
        stage: BreedingCycleStage.cancelled,
        dayOfCycle: day,
      );

    case BreedingStatus.completed:
      // «Завершена» сервер ставит в момент записи окрола. Настоящей даты
      // окрола в записи о случке нет, поэтому отсадку считаем от ожидаемой
      // даты — отсюда и приблизительность этого срока в интерфейсе.
      final weaning =
          expected?.add(const Duration(days: BreedingCycleDays.weaning));
      if (weaning == null || weaning.isBefore(today)) {
        return BreedingCycleStatus(
          stage: BreedingCycleStage.closed,
          dayOfCycle: day,
        );
      }
      return BreedingCycleStatus(
        stage: BreedingCycleStage.weaning,
        actionDate: weaning,
        dayOfCycle: day,
      );

    case BreedingStatus.planned:
      if (breeding.isPregnant == false) {
        return BreedingCycleStatus(
          stage: BreedingCycleStage.notPregnant,
          dayOfCycle: day,
        );
      }

      final checked =
          breeding.palpationDate != null || breeding.isPregnant == true;
      if (!checked &&
          bred != null &&
          day! <= BreedingCycleDays.pregnancyCheckLatest) {
        return BreedingCycleStatus(
          stage: BreedingCycleStage.pregnancyCheck,
          actionDate: bred.add(
            const Duration(days: BreedingCycleDays.pregnancyCheck),
          ),
          dayOfCycle: day,
        );
      }

      return BreedingCycleStatus(
        stage: BreedingCycleStage.birthExpected,
        actionDate: expected,
        dayOfCycle: day,
      );
  }
}

/// Порядок ленты: сверху то, что горит.
///
/// Просроченное оказывается выше предстоящего само собой — у него дата
/// раньше. Записи без дела (отменённые, неудачные, отработанные) уходят вниз:
/// они уже ничего не требуют, но и прятать их не за чем.
List<BreedingModel> sortedByNextAction(
  List<BreedingModel> breedings, {
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final rows = [
    for (final breeding in breedings)
      (breeding, breedingCycleStatus(breeding, now: at)),
  ];

  rows.sort((a, b) {
    final left = a.$2.actionDate;
    final right = b.$2.actionDate;

    if (left != null && right != null) {
      final byAction = left.compareTo(right);
      if (byAction != 0) return byAction;
    } else if (left != null) {
      return -1;
    } else if (right != null) {
      return 1;
    } else {
      // Свежая случка выше давней: даты приходят в ISO, они сравнимы как есть.
      final byDate = b.$1.breedingDate.compareTo(a.$1.breedingDate);
      if (byDate != 0) return byDate;
    }
    // Порядок не должен зависеть от того, как список приехал с сервера.
    return a.$1.id.compareTo(b.$1.id);
  });

  return [for (final row in rows) row.$1];
}

DateTime? _dayOfString(String? raw) {
  final parsed = DateTime.tryParse(raw ?? '');
  return parsed == null
      ? null
      : DateTime(parsed.year, parsed.month, parsed.day);
}

DateTime _dayOf(DateTime value) =>
    DateTime(value.year, value.month, value.day);
