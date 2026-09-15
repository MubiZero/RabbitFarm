import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../breeding/presentation/providers/breeding_provider.dart';
import '../../../feeding/presentation/providers/feeding_records_provider.dart';
import '../../../finance/presentation/providers/transactions_provider.dart';
import '../../../health/data/repositories/vaccinations_repository.dart';
import '../../../staff/presentation/providers/staff_provider.dart';
import '../../data/first_steps.dart';

/// Сделан ли шаг.
///
/// Запрашивается по одной записи: чек-листу нужен признак «хоть что-то
/// есть», а не список. И спрашивается только про те шаги, что реально
/// показаны, — `autoDispose` гасит запрос, как только пункт ушёл с экрана.
///
/// Клетки и кролики сюда не попадают: их количество уже приехало в сводке
/// «Сегодня», и второй запрос за тем же числом был бы лишним.
final firstStepDoneProvider = FutureProvider.autoDispose
    .family<bool, FirstStep>((ref, step) async {
      switch (step) {
        case FirstStep.cages:
        case FirstStep.rabbits:
          return false;

        case FirstStep.breeding:
          final page = await ref
              .watch(breedingRepositoryProvider)
              .getBreedings(limit: 1);
          return page.items.isNotEmpty;

        case FirstStep.feeding:
          final records = await ref.watch(
            recentFeedingRecordsProvider(1).future,
          );
          return records.isNotEmpty;

        case FirstStep.health:
          final shots = await ref
              .watch(vaccinationsRepositoryProvider)
              .getVaccinations(limit: 1);
          return shots.isNotEmpty;

        case FirstStep.money:
          final entries = await ref
              .watch(transactionsRepositoryProvider)
              .getTransactions(limit: 1);
          return entries.isNotEmpty;

        case FirstStep.helpers:
          final members = await ref.watch(farmMembersProvider.future);
          // Владелец в списке есть всегда — помощник появился, если людей
          // стало больше одного.
          return members.length > 1;
      }
    });
