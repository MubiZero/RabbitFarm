import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_providers.dart';
import '../../../../core/providers/session.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return JournalRepository(ref.watch(apiClientProvider));
});

/// За какой срок показывать записи.
///
/// Общий StatsPeriod здесь не подходит: он считает месяцами и годами для
/// отчётов, а журнал отвечает на вопрос «что я записал за смену» — дальше
/// прошлой недели в нём смотреть нечего.
enum JournalPeriod {
  today(1),
  week(7);

  const JournalPeriod(this.days);

  final int days;

  /// Начало периода — полночь местного времени.
  ///
  /// Округление до дня здесь обязательно: значение уходит в ключ провайдера,
  /// и время с точностью до миллисекунды давало бы новый ключ на каждой
  /// перестройке — экран уходил бы в бесконечную загрузку.
  DateTime from(DateTime now) => DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: days - 1));

  /// Конец периода — последняя миллисекунда сегодняшнего дня.
  DateTime to(DateTime now) =>
      DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
}

/// Лента записей за выбранный срок.
final journalFeedProvider = FutureProvider.autoDispose
    .family<List<JournalEntry>, JournalPeriod>((ref, period) async {
  final now = DateTime.now();
  return ref.watch(journalRepositoryProvider).load(
        from: period.from(now),
        to: period.to(now),
      );
});
