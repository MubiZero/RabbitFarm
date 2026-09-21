import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_providers.dart';
import '../../data/models/plan_option.dart';
import '../../data/repositories/plans_repository.dart';

final plansRepositoryProvider = Provider<PlansRepository>((ref) {
  return PlansRepository(ref.watch(apiClientProvider));
});

/// Тарифы для экрана в конце знакомства. Сбой не должен мешать заводить
/// ферму: экран с ценами в этом случае просто не показывается.
final plansProvider = FutureProvider<List<PlanOption>>((ref) async {
  return ref.watch(plansRepositoryProvider).getPlans();
});
