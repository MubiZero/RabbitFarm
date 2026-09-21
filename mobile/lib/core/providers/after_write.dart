import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/breeding/presentation/providers/breeding_provider.dart';
import '../../features/cages/presentation/providers/cages_provider.dart';
import '../../features/cages/presentation/providers/herd_cages_provider.dart';
import '../../features/feeding/presentation/providers/feeding_records_provider.dart';
import '../../features/feeding/presentation/providers/feeds_provider.dart';
import '../../features/finance/presentation/providers/transactions_provider.dart';
import '../../features/health/presentation/providers/medical_records_provider.dart';
import '../../features/health/presentation/providers/vaccinations_provider.dart';
import '../../features/home/presentation/providers/journal_provider.dart';
import '../../features/rabbits/presentation/providers/births_provider.dart';
import '../../features/rabbits/presentation/providers/breeds_provider.dart';
import '../../features/reports/presentation/providers/reports_provider.dart';
import '../../features/tasks/presentation/providers/tasks_provider.dart';

/// Вид записи, которую человек только что внёс.
enum FarmRecord {
  cage,
  rabbit,
  breed,
  feed,
  feeding,
  breeding,
  birth,
  vaccination,
  medicalRecord,
  transaction,
  task,
  note,
}

/// Что перечитать после того, как запись ушла на сервер.
///
/// Это знание раньше было размазано: каждая форма инвалидировала свой набор
/// провайдеров, очередь отправки — свой, а сводку «Ферма сейчас» не обновлял
/// никто. Половина форм не обновляла вообще ничего.
///
/// Стоило это дорого. Человек заводил первую клетку, получал «Клетка
/// добавлена», возвращался на карту фермы и видел там пусто, а на главном
/// экране прежний ноль. Он заводил её второй раз, снова видел пусто и решал,
/// что программа теряет записи. Проверять обратное после такого никто не
/// станет.
///
/// Здесь один список на каждый вид записи, и им пользуются все, кто пишет: и
/// формы, и очередь. Появился экран со сводкой — дописали его сюда один раз,
/// а не в двадцати местах.
///
/// Провайдеры, которых сейчас никто не слушает, от этого не поднимаются:
/// `invalidate` лишь помечает их устаревшими, и запрос уйдёт, только когда
/// экран действительно откроют.
List<Object> providersAfter(FarmRecord record) {
  return [
    // Сводка «Ферма сейчас» стоит на главном экране и отвечает на вопрос
    // «сколько у меня всего». Её меняет почти любая запись; заметка не
    // меняет ни одного счётчика.
    if (record != FarmRecord.note) dashboardReportProvider,

    // Журнал это лента сделанного за день.
    if (_inJournal.contains(record)) journalFeedProvider,

    ...switch (record) {
      // Карта фермы и выпадающие списки клеток живут отдельно от списка на
      // экране клеток: именно на карту человек и возвращается.
      FarmRecord.cage => [
          cageRowsProvider,
          cageOptionsProvider,
          cageStatisticsProvider,
        ],
      // Занятость клеток меняется вместе с кроликом: поселили, место занято.
      FarmRecord.rabbit => [
          cageRowsProvider,
          cageOptionsProvider,
          cageStatisticsProvider,
        ],
      FarmRecord.breed => [breedsProvider],
      FarmRecord.feed => [
          feedsProvider,
          feedOptionsProvider,
          feedStatisticsProvider,
          feedHasLowStockProvider,
        ],
      // Кормление списывает корм со склада, поэтому остаток и предупреждение
      // «корм заканчивается» перечитываются вместе с записью.
      FarmRecord.feeding => [
          feedsProvider,
          feedOptionsProvider,
          feedStatisticsProvider,
          feedHasLowStockProvider,
          feedingStatisticsProvider,
        ],
      FarmRecord.breeding => [breedingListProvider, breedingStatisticsProvider],
      FarmRecord.birth => [birthsProvider, breedingListProvider],
      FarmRecord.vaccination => [
          vaccinationsProvider,
          upcomingVaccinationsProvider,
          vaccinationStatisticsProvider,
        ],
      FarmRecord.medicalRecord => [
          medicalRecordsProvider,
          recentMedicalRecordsProvider,
        ],
      FarmRecord.transaction => [
          transactionsProvider,
          financialStatisticsProvider,
        ],
      FarmRecord.task => [
          tasksListProvider,
          todayTasksProvider,
          upcomingTasksProvider,
          taskStatisticsProvider,
        ],
      FarmRecord.note => const <Object>[],
    },
  ];
}

const _inJournal = {
  FarmRecord.feeding,
  FarmRecord.breeding,
  FarmRecord.birth,
  FarmRecord.vaccination,
  FarmRecord.medicalRecord,
  FarmRecord.task,
  FarmRecord.note,
};

/// Обновление с экрана: форма сохранилась, и человек сейчас вернётся назад.
extension RefreshAfterWrite on WidgetRef {
  void refreshAfter(FarmRecord record) {
    for (final provider in providersAfter(record)) {
      invalidate(provider as dynamic);
    }
  }
}

/// Обновление из фона: очередь дослала запись, накопленную без связи.
extension RefreshAfterWriteFromRef on Ref {
  void refreshAfter(FarmRecord record) {
    for (final provider in providersAfter(record)) {
      invalidate(provider as dynamic);
    }
  }
}
