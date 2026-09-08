import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';

/// Выбор фермы-адресата объявления.
///
/// Возвращает ферму или `null`, если лист закрыли, ничего не выбрав. В отличие
/// от листа выбора тарифа, здесь есть поиск: ферм на платформе десятки, и
/// искать нужную глазами в общем списке — работа, которую должен делать
/// интерфейс.
Future<PlatformFarm?> showAnnouncementFarmPicker(
  BuildContext context, {
  PlatformFarm? current,
}) {
  return showModalBottomSheet<PlatformFarm>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _AnnouncementFarmPickerSheet(current: current),
  );
}

class _AnnouncementFarmPickerSheet extends ConsumerStatefulWidget {
  const _AnnouncementFarmPickerSheet({this.current});

  final PlatformFarm? current;

  @override
  ConsumerState<_AnnouncementFarmPickerSheet> createState() =>
      _AnnouncementFarmPickerSheetState();
}

class _AnnouncementFarmPickerSheetState
    extends ConsumerState<_AnnouncementFarmPickerSheet> {
  final _search = TextEditingController();

  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      AppDuration.normal,
      () {
        if (mounted) setState(() => _query = value.trim());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentId = widget.current?.id;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                l10n.platformAnnouncementFarmSheetTitle,
                style: AppTypography.titleMd
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.sm,
              ),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.platformFarmsSearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                // Поиск уходит на сервер: в памяти лежат только показанные
                // фермы, и ферма из следующей страницы «не находилась» бы.
                onChanged: _onSearchChanged,
                onSubmitted: (value) => setState(() => _query = value.trim()),
              ),
            ),
            Flexible(
              child: AppAsyncView<List<PlatformFarm>>(
                value: ref.watch(announcementFarmChoicesProvider(_query)),
                onRetry: () =>
                    ref.invalidate(announcementFarmChoicesProvider(_query)),
                builder: (farms) => farms.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Text(
                          l10n.platformFarmsNothingFoundBody,
                          style: AppTypography.bodyMd
                              .copyWith(color: context.colors.onSurfaceVariant),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          for (final farm in farms)
                            ListTile(
                              leading: Icon(
                                farm.id == currentId
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: farm.id == currentId
                                    ? context.accent
                                    : context.colors.onSurfaceVariant,
                              ),
                              title: Text(farm.name),
                              // Владелец — то, по чему ферму узнают, когда
                              // названия похожи.
                              subtitle: Text(
                                farm.owner?.fullName ??
                                    l10n.platformOwnerMissing,
                              ),
                              onTap: () => Navigator.pop(context, farm),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
