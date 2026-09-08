import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/announcement_confirm_dialog.dart';
import '../widgets/announcement_farm_picker_sheet.dart';
import '../widgets/announcement_labels.dart';
import '../widgets/farm_filter_labels.dart';

/// Составление объявления: что написать, чем отправить и кому.
///
/// Экран собирает свой каркас сам, а не берёт [AppFormScaffold]: там кнопка
/// сохранения всегда активна и сразу после успеха показывает сообщение, а
/// здесь между нажатием и отправкой обязано встать подтверждение, от которого
/// можно отказаться, — «отменил» не должно выглядеть как «отправлено».
/// Панель кнопки и вопрос о несохранённом взяты оттуда же.
class AnnouncementFormScreen extends ConsumerStatefulWidget {
  const AnnouncementFormScreen({super.key});

  @override
  ConsumerState<AnnouncementFormScreen> createState() =>
      _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState
    extends ConsumerState<AnnouncementFormScreen> {
  static const _titleLimit = 255;
  static const _bodyLimit = 4000;

  final _title = TextEditingController();
  final _body = TextEditingController();

  /// Push и почта включены сразу: объявление, до которого не дошли обоими
  /// каналами, — обычно недоразумение, а не выбор.
  final _channels = <String>{...kAnnouncementChannels};

  String _target = 'all';
  PlatformFarm? _farm;
  PlatformFarmFilter? _filter;

  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Кнопка отправки включается по заполненности, а набор текста сам по себе
    // экран не перестраивает.
    for (final c in [_title, _body]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_title, _body]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Заполненное объявление или `null`, если чего-то не хватает.
  ///
  /// Одна проверка на две задачи: она же включает кнопку и она же собирает
  /// запрос — разойтись им негде. Сервер всё равно перепроверит, но узнавать о
  /// пустом заголовке из отказа сервера, отправив рассылку, поздно.
  AnnouncementDraft? get _draft {
    final title = _title.text.trim();
    final body = _body.text.trim();
    if (title.isEmpty || body.isEmpty || _channels.isEmpty) return null;
    if (_target == 'farm' && _farm == null) return null;
    if (_target == 'filter' && _filter == null) return null;

    return AnnouncementDraft(
      title: title,
      body: body,
      // Порядок каналов постоянный, а не в порядке нажатий: он виден в
      // подтверждении и в истории.
      channels: [
        for (final channel in kAnnouncementChannels)
          if (_channels.contains(channel)) channel,
      ],
      targetType: _target,
      targetFarmId: _target == 'farm' ? _farm!.id : null,
      targetFilter: _target == 'filter' ? _filter!.apiValue : null,
    );
  }

  bool get _isDirty =>
      _title.text.trim().isNotEmpty || _body.text.trim().isNotEmpty;

  String _audience(BuildContext context) => announcementAudience(
        context,
        targetType: _target,
        farmName: _farm?.name,
        targetFilter: _filter?.apiValue,
      );

  Future<void> _submit() async {
    final draft = _draft;
    if (draft == null || _sending) return;

    final l10n = context.l10n;
    final confirmed = await confirmAnnouncementSend(
      context,
      audience: _audience(context),
      channels: [
        for (final channel in draft.channels)
          announcementChannelLabel(context, channel),
      ].join(' · '),
    );
    if (!confirmed || !mounted) return;

    setState(() => _sending = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final notifier = ref.read(platformAnnouncementsProvider.notifier);

    final error = await notifier.send(draft);
    if (!mounted) return;
    setState(() => _sending = false);

    if (error != null) {
      // Форма остаётся открытой: набранный текст — единственная его копия.
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, error)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Отправленное лежит первым в истории — его туда и поставил notifier.
    // Подробности по каналам видны там же, поэтому снэкбар отвечает только на
    // «ушло ли и скольким».
    final sent = ref.read(platformAnnouncementsProvider).items.firstOrNull;
    messenger.showSnackBar(SnackBar(content: Text(_sentMessage(l10n, sent))));
    if (navigator.canPop()) navigator.pop();
  }

  /// Чем закончилась отправка — словами.
  ///
  /// «Отправлено» без оговорок сказать нельзя: получателей могло не оказаться
  /// вовсе, а часть сообщений — не дойти, и умолчать об этом значило бы
  /// соврать об успехе.
  String _sentMessage(AppLocalizations l10n, Announcement? sent) {
    if (sent == null) return l10n.platformAnnouncementSentPlain;
    if (sent.hasNoRecipients) return l10n.platformAnnouncementNobody;
    if (sent.stats?.hasFailures ?? false) {
      return l10n.platformAnnouncementSentPartly(sent.recipientsCount);
    }
    return l10n.platformAnnouncementSentOk(sent.recipientsCount);
  }

  Future<void> _pickFarm() async {
    final farm = await showAnnouncementFarmPicker(context, current: _farm);
    if (farm == null || !mounted) return;
    setState(() {
      _farm = farm;
      _target = 'farm';
    });
  }

  Future<void> _pickFilter() async {
    final filter = await showModalBottomSheet<PlatformFarmFilter>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.md,
              ),
              child: Text(
                sheetContext.l10n.platformAnnouncementFilterSheetTitle,
                style: AppTypography.titleMd
                    .copyWith(color: sheetContext.colors.onSurface),
              ),
            ),
            // Те же пять срезов, что и чипы в списке ферм, и теми же словами.
            for (final option in PlatformFarmFilter.values)
              ListTile(
                leading: Icon(
                  option == _filter
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: option == _filter
                      ? sheetContext.accent
                      : sheetContext.colors.onSurfaceVariant,
                ),
                title: Text(farmFilterLabel(sheetContext, option)),
                onTap: () => Navigator.pop(sheetContext, option),
              ),
          ],
        ),
      ),
    );
    if (filter == null || !mounted) return;
    setState(() {
      _filter = filter;
      _target = 'filter';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: !_isDirty && !_sending,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || _sending) return;
        if (await confirmDiscardChanges(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.platformAnnouncementFormTitle)),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          children: [
            AppFormSection(
              title: l10n.commonSectionMain,
              children: [
                TextField(
                  controller: _title,
                  enabled: !_sending,
                  maxLength: _titleLimit,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.platformAnnouncementFormSubject,
                    hintText: l10n.platformAnnouncementFormSubjectHint,
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                TextField(
                  controller: _body,
                  enabled: !_sending,
                  maxLength: _bodyLimit,
                  minLines: 4,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.platformAnnouncementFormBody,
                    hintText: l10n.platformAnnouncementFormBodyHint,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppFormSection(
              title: l10n.platformAnnouncementFormSectionChannels,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final channel in kAnnouncementChannels)
                        CheckboxListTile(
                          value: _channels.contains(channel),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            announcementChannelLabel(context, channel),
                            style: AppTypography.bodyLg
                                .copyWith(color: context.colors.onSurface),
                          ),
                          subtitle: Text(
                            announcementChannelHint(context, channel),
                            style: AppTypography.labelSm.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          onChanged: _sending
                              ? null
                              : (checked) => setState(() {
                                    if (checked == true) {
                                      _channels.add(channel);
                                    } else {
                                      _channels.remove(channel);
                                    }
                                  }),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      // Почему в списке только два канала — вопрос, который
                      // задаст каждый, кто откроет форму.
                      Text(
                        l10n.platformAnnouncementFormNoSms,
                        style: AppTypography.labelSm
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppFormSection(
              title: l10n.platformAnnouncementFormSectionTarget,
              children: [
                AppCard(
                  child: RadioGroup<String>(
                    groupValue: _target,
                    onChanged: (value) {
                      if (value == null || _sending) return;
                      setState(() => _target = value);
                      // Выбор без адресата — незаконченный выбор, и спросить
                      // о нём лучше сразу, а не оставлять человека наедине с
                      // погашенной кнопкой.
                      if (value == 'farm' && _farm == null) _pickFarm();
                      if (value == 'filter' && _filter == null) _pickFilter();
                    },
                    child: Column(
                      children: [
                        for (final target in kAnnouncementTargets)
                          RadioListTile<String>(
                            value: target,
                            enabled: !_sending,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              announcementTargetLabel(context, target),
                              style: AppTypography.bodyLg.copyWith(
                                color: context.colors.onSurface,
                              ),
                            ),
                            subtitle: Text(_targetSubtitle(context, target)),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_target == 'farm')
                  _ChoiceRow(
                    icon: Icons.holiday_village_outlined,
                    label: _farm?.name ??
                        l10n.platformAnnouncementFormPickFarm,
                    isEmpty: _farm == null,
                    onTap: _sending ? null : _pickFarm,
                  ),
                if (_target == 'filter')
                  _ChoiceRow(
                    icon: Icons.filter_alt_outlined,
                    label: _filter == null
                        ? l10n.platformAnnouncementFormPickFilter
                        : farmFilterLabel(context, _filter!),
                    isEmpty: _filter == null,
                    onTap: _sending ? null : _pickFilter,
                  ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: AppSubmitBar(
          label: l10n.platformAnnouncementSend,
          busy: _sending,
          // Пока объявление неполно, кнопка не работает: рассылку нельзя
          // отправить «на пробу» и поправить потом.
          onPressed: _draft == null ? null : _submit,
        ),
      ),
    );
  }

  /// Подпись под вариантом адресата. Для «одной ферме» и «по срезу» она
  /// заодно показывает, что уже выбрано.
  String _targetSubtitle(BuildContext context, String target) {
    if (target == 'farm' && _farm != null) return _farm!.name;
    if (target == 'filter' && _filter != null) {
      return farmFilterLabel(context, _filter!);
    }
    return announcementTargetHint(context, target);
  }
}

/// Выбранный адресат отдельной строкой — по ней же его и меняют.
class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.icon,
    required this.label,
    required this.isEmpty,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isEmpty;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isEmpty ? AppColors.warning : context.colors.onSurface;

    return AppCard(
      onTap: onTap,
      borderColor: isEmpty ? AppColors.warning : null,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyLg.copyWith(color: color),
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
