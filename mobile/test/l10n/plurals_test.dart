import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/l10n/generated/app_localizations_ru.dart';

/// Русские окончания числительных — самая частая ошибка в интерфейсе: «5
/// задача», «2 кроликов». Правило нетривиальное (11–14 ведут себя не как
/// 1–4), поэтому формы проверяются на всех трёх ветках и на исключениях.
void main() {
  final l10n = AppLocalizationsRu();

  group('Задачи', () {
    test('одна', () => expect(l10n.countTasks(1), '1 задача'));
    test('две-четыре', () {
      expect(l10n.countTasks(2), '2 задачи');
      expect(l10n.countTasks(4), '4 задачи');
    });
    test('пять и больше', () => expect(l10n.countTasks(5), '5 задач'));
    test('одиннадцать — исключение', () {
      expect(l10n.countTasks(11), '11 задач');
      expect(l10n.countTasks(14), '14 задач');
    });
    test('двадцать одна — снова единственное', () {
      expect(l10n.countTasks(21), '21 задача');
      expect(l10n.countTasks(22), '22 задачи');
    });
    test('ноль', () => expect(l10n.countTasks(0), '0 задач'));
  });

  group('Кролики', () {
    test('формы', () {
      expect(l10n.countRabbits(1), '1 кролик');
      expect(l10n.countRabbits(3), '3 кролика');
      expect(l10n.countRabbits(7), '7 кроликов');
      expect(l10n.countRabbits(21), '21 кролик');
    });
  });

  group('Виды корма', () {
    test('формы', () {
      expect(l10n.countFeedKinds(1), '1 вид корма');
      expect(l10n.countFeedKinds(2), '2 вида корма');
      expect(l10n.countFeedKinds(5), '5 видов корма');
    });
  });

  group('Просрочка', () {
    test('формы', () {
      expect(l10n.overdueByDays(1), 'Просрочена на 1 день');
      expect(l10n.overdueByDays(3), 'Просрочена на 3 дня');
      expect(l10n.overdueByDays(12), 'Просрочена на 12 дней');
    });
  });

  group('Периоды', () {
    test('формы', () {
      expect(l10n.periodDays(30), '30 дней');
      expect(l10n.periodMonths(3), '3 месяца');
    });
  });
}
