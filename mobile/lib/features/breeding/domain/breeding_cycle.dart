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

  /// Позже 50-го дня от окрола отсаживать уже поздно: молодняк съедает корм
  /// самки, а её пора крыть заново. До этого дня дело держим в ленте, чтобы
  /// просроченная отсадка не исчезала на следующий день после срока.
  static const weaningLatest = 50;
}

/// Где случка находится прямо сейчас.
enum BreedingCycleStage {
  /// Покрыта, пора проверить сукрольность.
  pregnancyCheck,

  /// Сукрольность идёт, ждём окрол.
  birthExpected,

  /// Окрол записан, впереди отсадка молодняка.
  weaning,

  /// Молодняк отсажен — по этой случке всё сделано.
  weaned,

  /// Прощупывание показало, что самка пустая.
  notPregnant,

  /// Случка не удалась.
  failed,

  /// Случку отменили.
  cancelled,

  /// Цикл отработан: срок отсадки прошёл, отметки о ней нет и ждать нечего.
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

  /// Дата посчитана от события, которое ещё не случилось (от ожидаемого
  /// окрола), а значит уедет вместе с ним. Такую дату показывают с оговоркой:
  /// выдать оценку за точный срок — соврать фермеру о том самом дне, ради
  /// которого он открывает приложение.
  final bool isEstimated;

  const BreedingCycleStatus({
    required this.stage,
    this.actionDate,
    this.dayOfCycle,
    this.isEstimated = false,
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
      // «Завершена» сервер ставит в момент записи окрола. Дата отсадки
      // отсчитывается от дня окрола, поэтому берём настоящую, когда она
      // приехала со списком. Ожидаемая — запасной вариант для старых серверов
      // и для окролов, которых в ответе нет: срок тогда честно приблизительный.
      final born = _dayOfString(breeding.actualBirthDate);
      final weaned = _dayOfString(breeding.weaningDate);

      if (weaned != null) {
        return BreedingCycleStatus(
          stage: BreedingCycleStage.weaned,
          dayOfCycle: day,
        );
      }

      final countFrom = born ?? expected;
      final weaning =
          countFrom?.add(const Duration(days: BreedingCycleDays.weaning));
      if (weaning == null) {
        return BreedingCycleStatus(
          stage: BreedingCycleStage.closed,
          dayOfCycle: day,
        );
      }

      // Настоящий день окрола известен — можно честно показать просрочку до
      // последнего разумного дня отсадки. Оценка такого права не даёт: гнать
      // «просрочено» по выдуманной дате хуже, чем промолчать, поэтому от
      // ожидаемого окрола цикл закрывается сразу за расчётным днём.
      final lastCall = born?.add(
            const Duration(days: BreedingCycleDays.weaningLatest),
          ) ??
          weaning;
      if (lastCall.isBefore(today)) {
        return BreedingCycleStatus(
          stage: BreedingCycleStage.closed,
          dayOfCycle: day,
        );
      }

      return BreedingCycleStatus(
        stage: BreedingCycleStage.weaning,
        actionDate: weaning,
        dayOfCycle: day,
        isEstimated: born == null,
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
