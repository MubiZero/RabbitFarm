import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';
import 'rabbit_picker.dart';

/// Поле «выбрать несколько кроликов» — для продажи партией.
///
/// Тридцать голов уходят в ресторан одной сделкой. Пока выбрать можно было
/// ровно одного, такую продажу оформляли либо тридцатью строками в книге,
/// либо одной строкой без связи с поголовьем — и кролики оставались живыми.
class RabbitMultiPickerField extends StatelessWidget {
  final List<RabbitModel> selected;
  final ValueChanged<List<RabbitModel>> onChanged;
  final bool enabled;

  const RabbitMultiPickerField({
    super.key,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      borderRadius: AppRadius.mdAll,
      onTap: enabled
          ? () async {
              final picked = await showModalBottomSheet<List<RabbitModel>>(
                context: context,
                isScrollControlled: true,
                builder: (_) => RabbitMultiPickerSheet(selected: selected),
              );
              if (picked != null) onChanged(picked);
            }
          : null,
      child: InputDecorator(
        isEmpty: selected.isEmpty,
        decoration: InputDecoration(
          labelText: l10n.rabbitMultiPickerLabel,
          enabled: enabled,
          prefixIcon: const Icon(Icons.pets_outlined),
          suffixIcon: selected.isEmpty || !enabled
              ? const Icon(Icons.arrow_drop_down)
              : IconButton(
                  tooltip: l10n.rabbitPickerClear,
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(const []),
                ),
        ),
        child: selected.isEmpty
            ? null
            // Сколько и кто именно: одно число без имён не даёт проверить
            // себя перед тем, как списать из стада пять голов.
            : Text(
                '${l10n.rabbitMultiPickerSelected(selected.length)} · '
                '${selected.map((r) => r.label).join(', ')}',
                style: AppTypography.bodyLg
                    .copyWith(color: context.colors.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}

/// Шторка выбора нескольких кроликов.
///
/// Поиск идёт на сервере — тот же, что у одиночного выбора: на трёхстах
/// головах список, подгруженный страницами, половину животных просто не
/// показывает.
class RabbitMultiPickerSheet extends ConsumerStatefulWidget {
  final List<RabbitModel> selected;

  const RabbitMultiPickerSheet({super.key, required this.selected});

  @override
  ConsumerState<RabbitMultiPickerSheet> createState() =>
      _RabbitMultiPickerSheetState();
}

class _RabbitMultiPickerSheetState
    extends ConsumerState<RabbitMultiPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;

  late final Map<int, RabbitModel> _chosen = {
    for (final rabbit in widget.selected) rabbit.id: rabbit,
  };

  List<RabbitModel> _results = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(AppDuration.normal, () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(rabbitsRepositoryProvider).getRabbits(
            limit: 30,
            search: query.trim().isEmpty ? null : query.trim(),
          );
      if (!mounted) return;
      setState(() {
        // Проданных и павших в партию не предлагаем: их уже нет в стаде, и
        // продать их второй раз — значит увести деньги от поголовья.
        _results = page.items
            .where((r) => r.status != 'sold' && r.status != 'dead')
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.rabbitMultiPickerTitle,
                      style: AppTypography.titleLg
                          .copyWith(color: context.colors.onSurface),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_chosen.values.toList()),
                    child: Text(l10n.rabbitMultiPickerDone),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.rabbitPickerHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _onQueryChanged,
                onSubmitted: _search,
              ),
            ),
            // Счётчик всегда на виду: выбор переживает смену поискового
            // запроса, и без него легко потерять счёт уже отмеченным.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _chosen.isEmpty
                      ? l10n.rabbitMultiPickerEmpty
                      : l10n.rabbitMultiPickerSelected(_chosen.length),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ),
            ),
            Expanded(child: _resultsView(context)),
          ],
        ),
      ),
    );
  }

  Widget _resultsView(BuildContext context) {
    if (_loading) return const DelayedSpinner();
    if (_error != null) {
      return AppErrorState(
        message: _error!,
        onRetry: () => _search(_controller.text),
      );
    }
    if (_results.isEmpty) {
      return AppEmptyState(
        icon: Icons.search_off,
        title: context.l10n.rabbitPickerNothingFound,
        subtitle: context.l10n.rabbitPickerNothingFoundBody,
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final rabbit = _results[index];
        final checked = _chosen.containsKey(rabbit.id);

        return CheckboxListTile(
          value: checked,
          onChanged: (value) => setState(() {
            if (value == true) {
              _chosen[rabbit.id] = rabbit;
            } else {
              _chosen.remove(rabbit.id);
            }
          }),
          secondary: RabbitAvatar(photoUrl: rabbit.photoUrl),
          title: Text(rabbit.label),
          subtitle:
              rabbit.breed?.name == null ? null : Text(rabbit.breed!.name),
        );
      },
    );
  }
}
