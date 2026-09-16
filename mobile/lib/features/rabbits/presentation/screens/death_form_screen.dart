import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/offline_queue/offline_queue.dart';
import '../../../../core/providers/connectivity.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/voice/voice_input.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';
import '../utils/rabbit_labels.dart';
import '../widgets/rabbit_picker.dart';

/// Отметить падёж.
///
/// Отдельный экран, а не выбор статуса в общей форме кролика: падёж
/// записывают у клетки, одной рукой, и заставлять ради этого проходить форму
/// из десятка полей — значит не записать его вовсе. Заодно сюда наконец
/// попали дата и причина: сервер принимал их с самого начала, а приложение
/// не отправляло — в карточке павшего кролика оставался один статус без
/// объяснения.
class DeathFormScreen extends ConsumerStatefulWidget {
  const DeathFormScreen({super.key, this.rabbit});

  /// Кролик, с карточки которого пришли. Пусто — если открыли из быстрого
  /// ввода и выбирать его надо здесь.
  final RabbitModel? rabbit;

  @override
  ConsumerState<DeathFormScreen> createState() => _DeathFormScreenState();
}

class _DeathFormScreenState extends ConsumerState<DeathFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  RabbitModel? _rabbit;
  DateTime _date = DateTime.now();
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _rabbit = widget.rabbit;
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<Object?> _save() async {
    final rabbit = _rabbit;
    if (rabbit == null) return context.l10n.rabbitPickerRequired;

    final reason = _reason.text.trim();
    final data = <String, dynamic>{
      'status': rabbitStatusDead,
      'death_date': _date.toIso8601String().split('T').first,
      if (reason.isNotEmpty) 'death_reason': reason,
    };

    if (!(ref.read(isOnlineProvider).value ?? true)) {
      // В сарае связи нет, а павшего кролика отмечают именно там. Запись
      // уходит в очередь и досылается сама.
      await ref.read(offlineQueueProvider.notifier).enqueue(
        OfflineActionType.rabbitDeath,
        {'rabbit_id': rabbit.id, ...data},
      );
      return null;
    }

    try {
      await ref.read(rabbitsRepositoryProvider).updateRabbit(rabbit.id, data);
      ref.invalidate(rabbitsListProvider);
      ref.invalidate(rabbitDetailProvider(rabbit.id));
      return null;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final online = ref.watch(isOnlineProvider).value ?? true;

    return AppFormScaffold(
      title: l10n.deathFormTitle,
      formKey: _formKey,
      submitLabel: l10n.deathFormSubmit,
      // Падёж не отменить: запись меняет состояние кролика окончательно, и
      // «нажал не туда» здесь стоит дороже, чем лишнее движение пальцем.
      confirmBySlide: true,
      // Без связи запись уходит в очередь — сообщение обязано говорить это,
      // а не делать вид, что сервер уже знает.
      successMessage: online ? l10n.deathFormSaved : l10n.offlineActionQueued,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            RabbitPickerField(
              label: l10n.deathFormRabbit,
              selected: _rabbit,
              // С карточки кролика менять его незачем: человек пришёл
              // отметить падёж конкретного.
              enabled: widget.rabbit == null,
              required: true,
              onChanged: (rabbit) => setState(() {
                _rabbit = rabbit;
                _touched = true;
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppDateField(
              label: l10n.deathFormDate,
              value: _date,
              lastDate: DateTime.now(),
              prefixIcon: Icons.event_outlined,
              onChanged: (date) => setState(() {
                _date = date;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: l10n.commonSectionDetails,
          children: [
            TextFormField(
              controller: _reason,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => _touched = true,
              decoration: InputDecoration(
                labelText: l10n.deathFormReason,
                hintText: l10n.deathFormReasonHint,
                prefixIcon: const Icon(Icons.notes_outlined),
                suffixIcon: VoiceInputButton(
                  controller: _reason,
                  onChanged: () => _touched = true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
