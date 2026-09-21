import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/providers/after_write.dart';
import 'package:mobile/features/cages/presentation/providers/cages_provider.dart';
import 'package:mobile/features/cages/presentation/providers/herd_cages_provider.dart';
import 'package:mobile/features/feeding/presentation/providers/feeds_provider.dart';
import 'package:mobile/features/home/presentation/providers/journal_provider.dart';
import 'package:mobile/features/reports/presentation/providers/reports_provider.dart';
import 'package:mobile/features/tasks/presentation/providers/tasks_provider.dart';

/// Проход живого фермера по продукту закончился на том, что он завёл первую
/// клетку, получил «Клетка добавлена», вернулся на карту фермы и увидел там
/// пусто, а на главном экране прежний ноль. Завёл вторую, снова пусто — и
/// решил, что программа теряет записи.
///
/// Причина была не в сохранении: запись доезжала до сервера. Просто форма
/// перечитывала только тот список, который сама же и открыла, а карту фермы
/// и сводку не трогал никто.
void main() {
  group('что перечитывается после записи', () {
    test('клетка обновляет карту фермы, а не только список клеток', () {
      final providers = providersAfter(FarmRecord.cage);

      expect(providers, contains(cageRowsProvider),
          reason: 'на карту фермы человек и возвращается после формы');
      expect(providers, contains(cageStatisticsProvider));
      expect(providers, contains(cageOptionsProvider),
          reason: 'клетку сразу выбирают в форме кролика и кормления');
    });

    test('сводка «Ферма сейчас» обновляется почти любой записью', () {
      for (final record in FarmRecord.values) {
        final providers = providersAfter(record);
        if (record == FarmRecord.note) {
          expect(providers, isNot(contains(dashboardReportProvider)),
              reason: 'заметка не меняет ни одного счётчика');
        } else {
          expect(providers, contains(dashboardReportProvider),
              reason: 'счётчики на главном показывают именно эти записи: '
                  '${record.name}');
        }
      }
    });

    test('кролик занимает место, поэтому клетки перечитываются тоже', () {
      expect(providersAfter(FarmRecord.rabbit), contains(cageRowsProvider));
      expect(
          providersAfter(FarmRecord.rabbit), contains(cageStatisticsProvider));
    });

    test('кормление списывает корм, поэтому остаток перечитывается', () {
      final providers = providersAfter(FarmRecord.feeding);

      expect(providers, contains(feedsProvider));
      expect(providers, contains(feedHasLowStockProvider),
          reason: 'предупреждение «корм заканчивается» висит на главном');
    });

    test('в журнал попадает сделанное за день, но не справочники', () {
      expect(providersAfter(FarmRecord.feeding), contains(journalFeedProvider));
      expect(providersAfter(FarmRecord.task), contains(journalFeedProvider));
      expect(providersAfter(FarmRecord.note), contains(journalFeedProvider));

      expect(providersAfter(FarmRecord.cage),
          isNot(contains(journalFeedProvider)));
      expect(providersAfter(FarmRecord.breed),
          isNot(contains(journalFeedProvider)));
    });

    test('задача обновляет и список на сегодня, и счётчик', () {
      final providers = providersAfter(FarmRecord.task);

      expect(providers, contains(todayTasksProvider));
      expect(providers, contains(taskStatisticsProvider));
    });

    test('у каждого вида записи есть что перечитать', () {
      for (final record in FarmRecord.values) {
        expect(providersAfter(record), isNotEmpty,
            reason: 'вид записи без обновления снова даст «ничего не '
                'сохранилось»: ${record.name}');
      }
    });

    test('в списке нет повторов', () {
      for (final record in FarmRecord.values) {
        final providers = providersAfter(record);
        expect(providers.toSet().length, providers.length,
            reason: 'двойное обновление это второй сетевой запрос на том же '
                'экране: ${record.name}');
      }
    });
  });
}
