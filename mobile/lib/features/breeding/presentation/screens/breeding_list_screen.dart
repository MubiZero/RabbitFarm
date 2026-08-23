import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../providers/breeding_provider.dart';

/// Список случек.
///
/// Раньше экран разбирал состояние четырьмя независимыми условиями, и первая
/// загрузка не подходила ни под одно из них: пока список ехал с сервера,
/// пользователь видел пустой экран без заголовка, подсказки и индикатора.
/// Теперь состояния разбирает [PagedListView] — одинаково на всех списках.
class BreedingListScreen extends ConsumerWidget {
  const BreedingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(breedingListProvider);
    final notifier = ref.read(breedingListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Случки')),
      body: PagedListView<BreedingModel>(
        items: state.breedings,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        empty: AppEmptyState(
          icon: Icons.favorite_border,
          title: 'Случек пока нет',
          subtitle: 'Запишите случку, и приложение подскажет ожидаемую '
              'дату окрола.',
          actionLabel: 'Записать случку',
          onAction: () => context.push('/breeding/new'),
        ),
        itemBuilder: (context, breeding, _) => _BreedingCard(
          breeding: breeding,
          onTap: () => context.push('/breeding/${breeding.id}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/breeding/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BreedingCard extends StatelessWidget {
  final BreedingModel breeding;
  final VoidCallback onTap;

  const _BreedingCard({required this.breeding, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = BreedingStatus.fromValue(breeding.status);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusChip(status: status),
              Text(
                _formatDate(breeding.breedingDate),
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Parent(
                  icon: Icons.male,
                  color: AppColors.info,
                  role: 'Самец',
                  name: breeding.male?.name,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(Icons.favorite,
                    color: AppColors.domainBreeding, size: 20),
              ),
              Expanded(
                child: _Parent(
                  icon: Icons.female,
                  color: AppColors.domainBreeding,
                  role: 'Самка',
                  name: breeding.female?.name,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          if (breeding.expectedBirthDate != null) ...[
            const Divider(height: AppSpacing.xl * 1.5),
            Row(
              children: [
                Icon(Icons.event_outlined,
                    size: 16, color: context.colors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Окрол ожидается ${_formatDate(breeding.expectedBirthDate!)}',
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    final date = DateTime.tryParse(raw);
    return date == null ? raw : DateFormat('d MMMM y', 'ru').format(date);
  }
}

class _StatusChip extends StatelessWidget {
  final BreedingStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BreedingStatus.planned => AppColors.info,
      BreedingStatus.completed => AppColors.success,
      BreedingStatus.failed => AppColors.error,
      BreedingStatus.cancelled => context.colors.onSurfaceVariant,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        status.label,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}

class _Parent extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String role;
  final String? name;
  final bool alignEnd;

  const _Parent({
    required this.icon,
    required this.color,
    required this.role,
    required this.name,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: AppSpacing.xs),
      Text(
        role,
        style: AppTypography.labelSm
            .copyWith(color: context.colors.onSurfaceVariant),
      ),
    ];

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: alignEnd ? label.reversed.toList() : label,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          // Раньше вместо неизвестного имени показывался номер записи в базе
          // («ID: 42») — для фермера это не подсказка, а мусор.
          name?.trim().isNotEmpty == true ? name!.trim() : 'Имя не указано',
          style: AppTypography.titleMd.copyWith(color: context.colors.onSurface),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}
