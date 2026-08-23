import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/pedigree_repository.dart';
import '../../domain/services/inbreeding_analyzer.dart';
import '../providers/rabbits_provider.dart';
import '../../../../core/theme/theme.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n/l10n_context.dart';

/// Экран планирования случек с анализом инбридинга
///
/// Позволяет выбрать самца и самку, получить родословную
/// и проанализировать риски родственного скрещивания
class BreedingPlannerScreen extends ConsumerStatefulWidget {
  const BreedingPlannerScreen({super.key});

  @override
  ConsumerState<BreedingPlannerScreen> createState() => _BreedingPlannerScreenState();
}

class _BreedingPlannerScreenState extends ConsumerState<BreedingPlannerScreen> {
  int? _selectedMaleId;
  int? _selectedFemaleId;

  InbreedingAnalysis? _analysis;

  bool _isLoadingPedigrees = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.plannerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        context.l10n.plannerIntro,
                        style: AppTypography.labelSm.copyWith(color: AppColors.accentOcean),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Выбор самца
            _buildRabbitSelector(
              label: context.l10n.breedingMale,
              sex: 'male',
              icon: Icons.male,
              color: AppColors.accentOcean,
              selectedId: _selectedMaleId,
              rabbits: rabbitsState.rabbits.where((r) => r.sex == 'male').toList(),
              onChanged: (id) {
                setState(() {
                  _selectedMaleId = id;
                  _analysis = null;
                });
                if (id != null && _selectedFemaleId != null) {
                  _analyzeBreeding();
                }
              },
            ),

            const SizedBox(height: 16),

            // Выбор самки
            _buildRabbitSelector(
              label: context.l10n.breedingFemale,
              sex: 'female',
              icon: Icons.female,
              color: AppColors.accentRose,
              selectedId: _selectedFemaleId,
              rabbits: rabbitsState.rabbits.where((r) => r.sex == 'female').toList(),
              onChanged: (id) {
                setState(() {
                  _selectedFemaleId = id;
                  _analysis = null;
                });
                if (id != null && _selectedMaleId != null) {
                  _analyzeBreeding();
                }
              },
            ),

            const SizedBox(height: 32),

            // Результаты анализа
            if (_isLoadingPedigrees)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              Card(
                color: AppColors.error.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.plannerAnalysisFailed,
                        style: AppTypography.titleLg.copyWith(color: AppColors.error),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              )
            else if (_analysis != null)
              _buildAnalysisResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildRabbitSelector({
    required String label,
    required String sex,
    required IconData icon,
    required Color color,
    required int? selectedId,
    required List rabbits,
    required Function(int?) onChanged,
  }) {
    final selectedRabbit = rabbits.where((r) => r.id == selectedId).firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTypography.titleMd,
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: selectedId,
              decoration: InputDecoration(
                hintText: context.l10n.rabbitPickerTitle,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
              ),
              items: rabbits.map<DropdownMenuItem<int>>((rabbit) {
                return DropdownMenuItem(
                  value: rabbit.id,
                  child: Text('${rabbit.name} (${rabbit.tagId})'),
                );
              }).toList(),
              onChanged: onChanged,
            ),
            if (selectedRabbit != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  if (selectedRabbit.breed != null)
                    Chip(
                      avatar: const Icon(Icons.pets, size: 16),
                      label: Text(selectedRabbit.breed!.name),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (selectedRabbit.birthDate != null)
                    Chip(
                      avatar: const Icon(Icons.cake, size: 16),
                      label: Text(_formatDate(selectedRabbit.birthDate!)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    if (_analysis == null) return const SizedBox.shrink();

    final riskLevel = _analysis!.riskLevel;
    final color = Color(riskLevel.colorValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Заголовок результатов
        Text(
          context.l10n.plannerResults,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Карточка с коэффициентом инбридинга
        Card(
          color: color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  _getRiskIcon(riskLevel),
                  size: 64,
                  color: color,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.plannerCoefficient,
                  style: AppTypography.bodyMd.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  _analysis!.coefficientPercent,
                  style: AppTypography.displayLg.copyWith(color: color),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    riskLevel.label.toUpperCase(),
                    style: AppTypography.titleMd.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  riskLevel.description,
                  style: AppTypography.bodyMd.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Общие предки
        if (_analysis!.hasCommonAncestors) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.family_restroom),
                      SizedBox(width: 8),
                      Text(
                        context.l10n.plannerCommonAncestors,
                        style: AppTypography.titleMd,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._analysis!.commonAncestors.map((ancestor) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ancestor.name,
                              style: AppTypography.bodyMd,
                            ),
                          ),
                          Text(
                            context.l10n.plannerGenerations(ancestor.closestGeneration),
                            style: AppTypography.labelSm.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Рекомендации
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(width: 8),
                    Text(
                      context.l10n.plannerAdvice,
                      style: AppTypography.titleMd,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._analysis!.recommendations.map((recommendation) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      recommendation,
                      style: AppTypography.bodyMd,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Кнопка "Запланировать случку"
        if (riskLevel != InbreedingRiskLevel.critical)
          ElevatedButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final router = GoRouter.of(context);
              // Тексты снимаются до перехода: экран может закрыться, пока
              // пользователь заполняет форму случки.
              final pickBoth = context.l10n.plannerPickBoth;
              final planned = context.l10n.plannerPlanned;

              if (_selectedMaleId == null || _selectedFemaleId == null) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(pickBoth),
                    backgroundColor: AppColors.warning,
                  ),
                );
                return;
              }

              // Переход к форме создания случки с предзаполненными данными
              final result = await router.push(
                '/breeding/new',
                extra: {
                  'male_id': _selectedMaleId,
                  'female_id': _selectedFemaleId,
                  'analysis': _analysis,
                },
              );

              if (result == true) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(planned),
                    backgroundColor: AppColors.success,
                  ),
                );
                // Можно вернуться назад или обновить данные
                router.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              ),
            icon: const Icon(Icons.add),
            label: Text(
              context.l10n.plannerPlan,
              style: AppTypography.titleMd,
            ),
          ),
      ],
    );
  }

  IconData _getRiskIcon(InbreedingRiskLevel level) {
    switch (level) {
      case InbreedingRiskLevel.none:
        return Icons.check_circle;
      case InbreedingRiskLevel.low:
        return Icons.info;
      case InbreedingRiskLevel.medium:
        return Icons.warning_amber;
      case InbreedingRiskLevel.high:
        return Icons.warning;
      case InbreedingRiskLevel.critical:
        return Icons.dangerous;
    }
  }

  Future<void> _analyzeBreeding() async {
    if (_selectedMaleId == null || _selectedFemaleId == null) return;

    setState(() {
      _isLoadingPedigrees = true;
      _error = null;
    });

    try {
      final repository = ref.read(pedigreeRepositoryProvider);

      // Загружаем родословные обоих кроликов
      final malePedigree = await repository.getPedigree(_selectedMaleId!, generations: 5);
      final femalePedigree = await repository.getPedigree(_selectedFemaleId!, generations: 5);

      // Анализируем инбридинг
      final analysis = InbreedingAnalyzer.analyze(malePedigree, femalePedigree);

      setState(() {
        _analysis = analysis;
        _isLoadingPedigrees = false;
      });
    } catch (e) {
      setState(() {
        _error = '${context.l10n.plannerPedigreeFailed}: $e';
        _isLoadingPedigrees = false;
      });
    }
  }

  /// Форматировщик дат знает сокращения месяцев для каждого языка — своя
  /// таблица здесь была лишней.
  String _formatDate(DateTime date) => DateFormat('d MMM y', 'ru').format(date);
}
