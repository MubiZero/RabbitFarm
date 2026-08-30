import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/repositories/notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return NotesRepository(ref.watch(apiClientProvider));
});
