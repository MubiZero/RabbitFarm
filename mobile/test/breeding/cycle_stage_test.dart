import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/breeding/domain/breeding_cycle.dart';
import 'package:mobile/features/rabbits/data/models/breeding_model.dart';

/// Стадия цикла — единственное, ради чего фермер открывает «Разведение»:
/// «самка №12, 25-й день, пора ставить маточник». Ошибка здесь не видна
/// глазом на экране, поэтому все переходы и границы проверяются числами.
BreedingModel breeding({
  int id = 1,
  required String bred,
  String status = 'planned',
  String? expected,
  String? palpation,
  bool? isPregnant,
}) =>
    BreedingModel(
      id: id,
      maleId: 10,
      femaleId: 20,
      breedingDate: bred,
      status: status,
      expectedBirthDate: expected,
      palpationDate: palpation,
      isPregnant: isPregnant,
    );

DateTime day(int year, int month, int dayOfMonth) =>
    DateTime(year, month, dayOfMonth);

void main() {
  group('Покрыта, сукрольность ещё не проверяли', () {
    test('день случки — первый день цикла', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01'),
        now: day(2026, 3, 1),
      );

      expect(status.stage, BreedingCycleStage.pregnancyCheck);
      expect(status.dayOfCycle, 1);
      expect(status.actionDate, day(2026, 3, 15));
      expect(status.isOverdue(now: day(2026, 3, 1)), isFalse);
    });

    test('после 14-го дня проверка просрочена', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01'),
        now: day(2026, 3, 18),
      );

      expect(status.stage, BreedingCycleStage.pregnancyCheck);
      expect(status.isOverdue(now: day(2026, 3, 18)), isTrue);
    });

    test('в день проверки она ещё не просрочена', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01'),
        now: day(2026, 3, 15),
      );

      expect(status.isOverdue(now: day(2026, 3, 15)), isFalse);
    });

    test('на 21-й день проверка ещё показывается', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01'),
        now: day(2026, 3, 21),
      );

      expect(status.stage, BreedingCycleStage.pregnancyCheck);
      expect(status.dayOfCycle, 21);
    });

    test('после третьей недели ближайшее дело — сам окрол', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01'),
        now: day(2026, 3, 22),
      );

      expect(status.stage, BreedingCycleStage.birthExpected);
      expect(status.actionDate, day(2026, 4, 1));
    });

    test('случка, записанная наперёд, показывает будущую проверку', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-10'),
        now: day(2026, 3, 1),
      );

      expect(status.stage, BreedingCycleStage.pregnancyCheck);
      expect(status.actionDate, day(2026, 3, 24));
      expect(status.dayOfCycle, isNonPositive);
    });
  });

  group('Сукрольность подтверждена', () {
    test('прощупывание записано — ждём окрол', () {
      final status = breedingCycleStatus(
        breeding(
          bred: '2026-03-01',
          palpation: '2026-03-12',
          expected: '2026-04-01',
        ),
        now: day(2026, 3, 12),
      );

      expect(status.stage, BreedingCycleStage.birthExpected);
      expect(status.actionDate, day(2026, 4, 1));
    });

    test('отметка «сукрольная» без даты прощупывания тоже считается', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01', isPregnant: true),
        now: day(2026, 3, 5),
      );

      expect(status.stage, BreedingCycleStage.birthExpected);
    });

    test('окрол просрочен, пока его не записали', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01', isPregnant: true, expected: '2026-04-01'),
        now: day(2026, 4, 5),
      );

      expect(status.stage, BreedingCycleStage.birthExpected);
      expect(status.isOverdue(now: day(2026, 4, 5)), isTrue);
      expect(status.dayOfCycle, 36);
    });

    test('без даты с сервера окрол считается от случки', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01', isPregnant: true),
        now: day(2026, 3, 25),
      );

      // Сервер ставит ожидаемый окрол на 31-й день — клиент считает так же.
      expect(status.actionDate, day(2026, 4, 1));
    });
  });

  group('Самка пустая', () {
    test('прощупывание показало, что сукрольности нет — дел больше нет', () {
      final status = breedingCycleStatus(
        breeding(
          bred: '2026-03-01',
          palpation: '2026-03-14',
          isPregnant: false,
        ),
        now: day(2026, 3, 20),
      );

      expect(status.stage, BreedingCycleStage.notPregnant);
      expect(status.actionDate, isNull);
    });
  });

  group('Окрол записан', () {
    test('следующее дело — отсадка на 45-й день от окрола', () {
      final status = breedingCycleStatus(
        breeding(
          bred: '2026-03-01',
          status: 'completed',
          expected: '2026-04-01',
        ),
        now: day(2026, 4, 10),
      );

      expect(status.stage, BreedingCycleStage.weaning);
      expect(status.actionDate, day(2026, 5, 16));
    });

    test('в день отсадки дело ещё живое', () {
      final status = breedingCycleStatus(
        breeding(
          bred: '2026-03-01',
          status: 'completed',
          expected: '2026-04-01',
        ),
        now: day(2026, 5, 16),
      );

      expect(status.stage, BreedingCycleStage.weaning);
      expect(status.isOverdue(now: day(2026, 5, 16)), isFalse);
    });

    test('после отсадки цикл отработан', () {
      final status = breedingCycleStatus(
        breeding(
          bred: '2026-03-01',
          status: 'completed',
          expected: '2026-04-01',
        ),
        now: day(2026, 5, 17),
      );

      expect(status.stage, BreedingCycleStage.closed);
      expect(status.actionDate, isNull);
    });
  });

  group('Случка закрыта без окрола', () {
    test('неудачная', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01', status: 'failed'),
        now: day(2026, 3, 20),
      );

      expect(status.stage, BreedingCycleStage.failed);
      expect(status.actionDate, isNull);
    });

    test('отменённая', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01', status: 'cancelled'),
        now: day(2026, 3, 20),
      );

      expect(status.stage, BreedingCycleStage.cancelled);
      expect(status.actionDate, isNull);
    });
  });

  group('Кривые данные не роняют ленту', () {
    test('без даты случки день цикла неизвестен', () {
      final status = breedingCycleStatus(
        breeding(bred: ''),
        now: day(2026, 3, 20),
      );

      expect(status.dayOfCycle, isNull);
      expect(status.actionDate, isNull);
    });

    test('дата с временем и зоной разбирается как день', () {
      final status = breedingCycleStatus(
        breeding(bred: '2026-03-01T00:00:00.000Z'),
        now: day(2026, 3, 3),
      );

      expect(status.dayOfCycle, 3);
      expect(status.actionDate, day(2026, 3, 15));
    });
  });

  group('Порядок ленты', () {
    test('просроченное выше предстоящего, а безнадзорное — внизу', () {
      final overdue = breeding(id: 1, bred: '2026-03-01', isPregnant: true);
      final soon = breeding(id: 2, bred: '2026-03-20');
      final cancelled =
          breeding(id: 3, bred: '2026-02-01', status: 'cancelled');

      final sorted = sortedByNextAction(
        [cancelled, soon, overdue],
        now: day(2026, 4, 5),
      );

      expect(sorted.map((b) => b.id).toList(), [1, 2, 3]);
    });

    test('записи без дел идут от свежей к давней', () {
      final old = breeding(id: 1, bred: '2025-01-01', status: 'failed');
      final recent = breeding(id: 2, bred: '2026-01-01', status: 'cancelled');

      final sorted = sortedByNextAction([old, recent], now: day(2026, 4, 5));

      expect(sorted.map((b) => b.id).toList(), [2, 1]);
    });

    test('одинаковые сроки не переставляются от загрузки к загрузке', () {
      final first = breeding(id: 7, bred: '2026-03-01');
      final second = breeding(id: 3, bred: '2026-03-01');

      final sorted = sortedByNextAction([first, second], now: day(2026, 3, 5));

      expect(sorted.map((b) => b.id).toList(), [3, 7]);
    });
  });
}
