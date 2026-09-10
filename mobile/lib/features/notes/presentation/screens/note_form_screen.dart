import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/offline_queue/offline_queue.dart';
import '../../../../core/providers/connectivity.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../cages/presentation/providers/cages_provider.dart';
import '../../../home/presentation/providers/journal_provider.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/note_model.dart';
import '../providers/notes_provider.dart';

/// Заметка по ферме — необязательно привязанная к кролику или клетке.
class NoteFormScreen extends ConsumerStatefulWidget {
  final NoteModel? note;

  const NoteFormScreen({super.key, this.note});

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _content;
  bool _touched = false;

  // Эффективные значения, которые уходят на сервер. Пикер кролика отдаёт
  // полную модель только когда выбор поменяли — при правке существующей
  // заметки её нет, есть только имя. Если хранить привязку исключительно
  // в модели пикера, непотроганное поле на сохранении отправило бы null
  // и молча отвязало бы кролика, которого никто не трогал.
  int? _rabbitId;
  RabbitModel? _rabbitModel;
  String? _rabbitLabel;
  int? _cageId;

  NoteModel? get _note => widget.note;
  bool get _isEditing => _note != null;

  @override
  void initState() {
    super.initState();
    _content = TextEditingController(text: _note?.content);
    _content.addListener(() {
      if (!_touched) _touched = true;
    });

    _rabbitId = _note?.rabbitId;
    _rabbitLabel = _note?.rabbit?.label;
    _cageId = _note?.cageId;
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  Future<String?> _save() async {
    final l10n = context.l10n;
    final repo = ref.read(notesRepositoryProvider);
    try {
      if (_isEditing) {
        await repo.updateNote(
          _note!.id,
          NoteUpdate(
            content: _content.text.trim(),
            rabbitId: _rabbitId,
            cageId: _cageId,
          ),
        );
      } else {
        final note = NoteCreate(
          content: _content.text.trim(),
          rabbitId: _rabbitId,
          cageId: _cageId,
        );

        if (!(ref.read(isOnlineProvider).value ?? true)) {
          // Нет сети — заметка не теряется, а уходит в офлайн-очередь и
          // досылается сама, как только связь вернётся.
          await ref
              .read(offlineQueueProvider.notifier)
              .enqueue(OfflineActionType.note, note.toJson());
          return null;
        }

        await repo.createNote(note);
      }
      ref.invalidate(journalFeedProvider);
      return null;
    } catch (e) {
      return errorText(l10n, e);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.noteFormDeleteTitle),
        content: Text(context.l10n.noteFormDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = context.l10n.noteFormDeleted;
    final failed = context.l10n.noteFormDeleteFailed;

    try {
      await ref.read(notesRepositoryProvider).deleteNote(_note!.id);
      ref.invalidate(journalFeedProvider);
      messenger.showSnackBar(SnackBar(content: Text(done)));
      if (navigator.canPop()) navigator.pop();
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(failed), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = ref.watch(canProvider(FarmCapability.deleteDailyRecords));
    final online = ref.watch(isOnlineProvider).value ?? true;

    return AppFormScaffold(
      title: _isEditing
          ? context.l10n.noteFormEditTitle
          : context.l10n.noteFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing
          ? context.l10n.commonSave
          : context.l10n.noteFormCreate,
      // Пока связи нет, заметка при сохранении уйдёт в очередь, а не на
      // сервер — сообщение об успехе должно говорить именно это.
      successMessage: _isEditing
          ? context.l10n.noteFormUpdated
          : (online
                ? context.l10n.noteFormCreated
                : context.l10n.offlineActionQueued),
      onSubmit: _save,
      isDirty: () => _touched,
      actions: [
        if (_isEditing && canDelete)
          IconButton(
            tooltip: context.l10n.commonDelete,
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
            onPressed: _delete,
          ),
      ],
      children: [
        AppFormSection(
          title: context.l10n.noteFormSectionMain,
          children: [
            TextFormField(
              controller: _content,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: context.l10n.noteFormContentLabel,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? context.l10n.noteFormContentEmpty
                  : null,
            ),
          ],
        ),
        AppFormSection(
          title: context.l10n.noteFormSectionLink,
          children: [
            RabbitPickerField(
              label: context.l10n.noteFormRabbitLabel,
              selected: _rabbitModel,
              selectedLabel: _rabbitLabel,
              onChanged: (rabbit) => setState(() {
                _rabbitModel = rabbit;
                _rabbitLabel = null;
                _rabbitId = rabbit?.id;
                _touched = true;
              }),
            ),
            Consumer(
              builder: (context, ref, _) {
                final cagesAsync = ref.watch(cageOptionsProvider);
                final cages = cagesAsync.value ?? const [];

                return DropdownButtonFormField<int?>(
                  initialValue: _cageId,
                  decoration: InputDecoration(
                    labelText: context.l10n.noteFormCageLabel,
                    prefixIcon: const Icon(Icons.grid_view_outlined),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(context.l10n.noteFormCageNone),
                    ),
                    for (final cage in cages)
                      DropdownMenuItem(
                        value: cage.id,
                        child: Text(cage.number),
                      ),
                  ],
                  onChanged: (value) => setState(() {
                    _cageId = value;
                    _touched = true;
                  }),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
