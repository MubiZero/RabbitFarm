import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/pedigree_model.dart';
import '../providers/pedigree_provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../utils/rabbit_labels.dart';

/// Экран отображения родословной кролика
///
/// Показывает древо предков в вертикальном списке по поколениям
class PedigreeScreen extends ConsumerWidget {
  final int rabbitId;
  /// Кличка для подзаголовка. Может отсутствовать: экран открывают и по
  /// прямой ссылке, где её негде взять.
  final String? rabbitName;

  const PedigreeScreen({
    super.key,
    required this.rabbitId,
    this.rabbitName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedigreeAsync = ref.watch(pedigreeProvider(rabbitId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.pedigreeTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.screenH,
              bottom: AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                rabbitName?.trim().isNotEmpty == true
                    ? rabbitName!
                    : context.l10n.commonNameMissing,
                style: AppTypography.bodyMd
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
          ),
        ),
      ),
      body: pedigreeAsync.when(
        data: (pedigree) => _buildPedigreeContent(context, pedigree),
        loading: () => const SkeletonList(itemHeight: 96),
        // Раньше здесь был тупик: сообщение и кнопка «назад», без повтора.
        error: (error, _) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(pedigreeProvider(rabbitId)),
        ),
      ),
    );
  }

  Widget _buildPedigreeContent(BuildContext context, PedigreeModel pedigree) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Заголовок
        _buildGenerationHeader(context.l10n.pedigreeSelf, 0),
        const SizedBox(height: 12),

        // Сам кролик
        _buildRabbitCard(context, pedigree, isPrimary: true),

        // Родители (Поколение 1)
        if (pedigree.father != null || pedigree.mother != null) ...[
          const SizedBox(height: 32),
          _buildGenerationHeader(context.l10n.rabbitParents, 1),
          const SizedBox(height: 12),

          if (pedigree.father != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildRabbitCard(context, pedigree.father!, label: context.l10n.rabbitFather),
            ),

          if (pedigree.mother != null)
            _buildRabbitCard(context, pedigree.mother!, label: context.l10n.rabbitMother),
        ],

        // Бабушки и дедушки (Поколение 2)
        if (_hasGrandparents(pedigree)) ...[
          const SizedBox(height: 32),
          _buildGenerationHeader(context.l10n.pedigreeGrandparents, 2),
          const SizedBox(height: 12),

          // Родители отца
          if (pedigree.father != null) ...[
            if (pedigree.father!.father != null || pedigree.father!.mother != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildParentsGroup(
                  context,
                  context.l10n.pedigreeFathersParents,
                  pedigree.father!.father,
                  pedigree.father!.mother,
                ),
              ),
          ],

          // Родители матери
          if (pedigree.mother != null) ...[
            if (pedigree.mother!.father != null || pedigree.mother!.mother != null)
              _buildParentsGroup(
                context,
                context.l10n.pedigreeMothersParents,
                pedigree.mother!.father,
                pedigree.mother!.mother,
              ),
          ],
        ],

        const SizedBox(height: 32),

        // Информационная карточка
        Card(
          color: AppColors.accentOcean.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.accentOcean),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.pedigreeHint,
                    style: AppTypography.labelSm.copyWith(color: AppColors.accentOcean),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _hasGrandparents(PedigreeModel pedigree) {
    if (pedigree.father != null) {
      if (pedigree.father!.father != null || pedigree.father!.mother != null) {
        return true;
      }
    }
    if (pedigree.mother != null) {
      if (pedigree.mother!.father != null || pedigree.mother!.mother != null) {
        return true;
      }
    }
    return false;
  }

  Widget _buildGenerationHeader(String title, int generation) {
    // Поколения различаются оттенком одного семейства, а не тремя разными
    // цветами: цвет здесь — порядок, а не смысл.
    const colors = [
      AppColors.domainLivestock,
      AppColors.info,
      AppColors.domainBreeding,
    ];

    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: colors[generation % colors.length],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTypography.titleLg
              .copyWith(color: colors[generation % colors.length]),
        ),
      ],
    );
  }

  Widget _buildParentsGroup(
    BuildContext context,
    String groupTitle,
    PedigreeModel? father,
    PedigreeModel? mother,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            groupTitle,
            style: AppTypography.labelLg
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
        ),
        if (father != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRabbitCard(context, father, label: context.l10n.pedigreeGrandfather, isSmall: true),
          ),
        if (mother != null)
          _buildRabbitCard(context, mother, label: context.l10n.pedigreeGrandmother, isSmall: true),
      ],
    );
  }

  Widget _buildRabbitCard(
    BuildContext context,
    PedigreeModel rabbit, {
    String? label,
    bool isPrimary = false,
    bool isSmall = false,
  }) {
    // Цвет в зависимости от пола
    Color cardColor;
    Color borderColor;
    IconData sexIcon;

    final accent = sexColor(context, rabbit.sex);
    cardColor = accent.withValues(alpha: 0.06);
    borderColor = accent.withValues(alpha: 0.4);
    sexIcon = rabbitSexIcon(rabbit.sex);

    return InkWell(
      onTap: () {
        context.push('/rabbits/${rabbit.id}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(
            color: isPrimary ? AppColors.domainLivestock : borderColor,
            width: isPrimary ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Row(
          children: [
            // Иконка пола
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sexIcon,
                size: isSmall ? 24 : 32,
                color: accent,
              ),
            ),

            const SizedBox(width: 16),

            // Информация о кролике
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Метка (Отец, Мать и т.д.)
                  if (label != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        label,
                        style: AppTypography.labelSm
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ),

                  // Имя
                  Text(
                    rabbit.name?.trim().isNotEmpty == true
                        ? rabbit.name!
                        : context.l10n.commonNameMissing,
                    style: (isSmall
                            ? AppTypography.titleMd
                            : AppTypography.titleLg)
                        .copyWith(color: context.colors.onSurface),
                  ),

                  const SizedBox(height: 4),

                  // Tag ID
                  if (rabbit.tagId != null && rabbit.tagId!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.tag,
                          size: isSmall ? 14 : 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rabbit.tagId!,
                          style: AppTypography.bodyMd.copyWith(
                              color: context.colors.onSurfaceVariant),
                        ),
                      ],
                    ),

                  // Порода
                  if (rabbit.breed != null && rabbit.breed!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pets,
                            size: isSmall ? 14 : 16,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              rabbit.breed!,
                              style: AppTypography.bodyMd.copyWith(
                                  color: context.colors.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Дата рождения
                  if (rabbit.birthDate != null && rabbit.birthDate!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cake,
                            size: isSmall ? 14 : 16,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(rabbit.birthDate!),
                            style: AppTypography.labelSm.copyWith(
                                color: context.colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Стрелка для перехода
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: isSmall ? 20 : 24,
            ),
          ],
        ),
      ),
    );
  }

  /// Раньше здесь была собственная таблица сокращений месяцев — при живом
  /// форматировщике дат, который знает их для каждого языка.
  String _formatDate(String raw) {
    final date = DateTime.tryParse(raw);
    return date == null ? raw : DateFormat('d MMM y', 'ru').format(date);
  }
}
