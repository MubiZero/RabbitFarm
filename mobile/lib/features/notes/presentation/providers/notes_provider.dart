import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return NotesRepository(ref.watch(apiClientProvider));
});

/// Provider для одной заметки по id — переход по тапу из push-уведомления
final noteByIdProvider =
    FutureProvider.autoDispose.family<NoteModel, int>((ref, id) async {
  final repository = ref.watch(notesRepositoryProvider);
  return await repository.getNoteById(id);
});
