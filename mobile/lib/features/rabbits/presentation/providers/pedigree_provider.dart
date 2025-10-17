import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pedigree_model.dart';
import '../../data/repositories/pedigree_repository.dart';

/// Provider для получения родословной кролика
///
/// Параметры: (rabbitId, generations)
final pedigreeProvider =
    FutureProvider.family<PedigreeModel, int>((ref, rabbitId) async {
  final repository = ref.watch(pedigreeRepositoryProvider);
  return repository.getPedigree(rabbitId, generations: 3);
});
