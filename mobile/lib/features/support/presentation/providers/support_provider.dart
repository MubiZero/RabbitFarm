import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_providers.dart';
import '../../data/repositories/support_repository.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository(ref.watch(apiClientProvider));
});

/// Официальный контакт поддержки. Молча падает в пустой контакт при ошибке
/// сети — это дополнение к внутренней фиче «Обращения», а не критичный путь,
/// не стоит перекрывать экран поддержки баннером ошибки из-за него.
final supportContactProvider = FutureProvider<SupportContact>((ref) async {
  try {
    return await ref.watch(supportRepositoryProvider).getContact();
  } catch (_) {
    return const SupportContact();
  }
});
