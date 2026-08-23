import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';

/// Кружок с фотографией кролика или значком-заглушкой.
class RabbitAvatar extends StatelessWidget {
  final String? photoUrl;
  final double size;

  const RabbitAvatar({super.key, this.photoUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final url = ImageUrlHelper.getFullImageUrl(photoUrl);

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: url == null
            ? _placeholder(context)
            // Фото грузится через кэш: списки кроликов открывают по многу раз
            // за день, и каждый раз тянуть картинку заново незачем.
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholder(context),
                errorWidget: (_, __, ___) => _placeholder(context),
              ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => ColoredBox(
        color: AppColors.domainLivestock.withValues(alpha: 0.12),
        child: Icon(
          Icons.pets,
          size: size * 0.5,
          color: AppColors.domainLivestock,
        ),
      );
}

/// Поле формы «выбрать кролика».
///
/// Раньше каждый экран подставлял в выпадающий список тех кроликов, что уже
/// подгрузились в постраничный список, — то есть первые десять или сто. На
/// ферме из трёхсот голов половину животных просто нельзя было выбрать, и
/// выглядело это как «кролика нет в системе». Поиск идёт на сервере.
class RabbitPickerField extends ConsumerWidget {
  final String label;
  final RabbitModel? selected;
  final ValueChanged<RabbitModel?> onChanged;

  /// Показать только самцов (`male`) или только самок (`female`).
  final String? sex;

  /// Кого не предлагать — например, самого кролика при выборе его родителя.
  final int? excludeId;

  final bool enabled;
  final bool required;
  final IconData icon;

  const RabbitPickerField({
    super.key,
    required this.label,
    required this.selected,
    required this.onChanged,
    this.sex,
    this.excludeId,
    this.enabled = true,
    this.required = false,
    this.icon = Icons.pets_outlined,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormField<RabbitModel>(
      initialValue: selected,
      validator: (_) => required && selected == null
          ? context.l10n.rabbitPickerRequired
          : null,
      builder: (field) => InkWell(
        borderRadius: AppRadius.mdAll,
        onTap: enabled
            ? () async {
                final picked = await showModalBottomSheet<RabbitModel>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      RabbitPickerSheet(sex: sex, excludeId: excludeId),
                );
                if (picked != null) {
                  field.didChange(picked);
                  onChanged(picked);
                }
              }
            : null,
        child: InputDecorator(
          isEmpty: selected == null,
          decoration: InputDecoration(
            labelText: label,
            enabled: enabled,
            errorText: field.errorText,
            prefixIcon: Icon(icon),
            suffixIcon: selected != null && enabled
                ? IconButton(
                    tooltip: context.l10n.rabbitPickerClear,
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      field.didChange(null);
                      onChanged(null);
                    },
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
          child: selected == null
              ? null
              : Text(
                  '${selected!.name} · ${selected!.tagId}',
                  style: AppTypography.bodyLg
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ),
    );
  }
}

/// Шторка поиска кролика.
class RabbitPickerSheet extends ConsumerStatefulWidget {
  final String? sex;
  final int? excludeId;

  /// Не предлагать кроликов, уже находящихся в этой клетке.
  final int? excludeCageId;

  const RabbitPickerSheet({
    super.key,
    this.sex,
    this.excludeId,
    this.excludeCageId,
  });

  @override
  ConsumerState<RabbitPickerSheet> createState() => _RabbitPickerSheetState();
}

class _RabbitPickerSheetState extends ConsumerState<RabbitPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;

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
            sex: widget.sex,
          );
      if (!mounted) return;
      setState(() {
        _results = page.items
            .where((r) => r.id != widget.excludeId)
            .where((r) => widget.excludeCageId == null ||
                r.cageId != widget.excludeCageId)
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
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.md,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n.rabbitPickerTitle,
                  style: AppTypography.titleLg
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: context.l10n.rabbitPickerHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _onQueryChanged,
                onSubmitted: _search,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
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

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.xl,
      ),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final rabbit = _results[i];
        final cage = rabbit.cage?.number;

        return AppCard(
          onTap: () => Navigator.pop(context, rabbit),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              RabbitAvatar(photoUrl: rabbit.photoUrl),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rabbit.name,
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cage != null
                          ? context.l10n.rabbitPickerInCage(cage)
                          : context.l10n.rabbitPickerNoCage,
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                rabbit.tagId,
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }
}
