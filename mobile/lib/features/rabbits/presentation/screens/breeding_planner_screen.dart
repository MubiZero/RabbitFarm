import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pedigree_model.dart';
import '../../data/repositories/pedigree_repository.dart';
import '../../domain/services/inbreeding_analyzer.dart';
import '../providers/rabbits_provider.dart';

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

  PedigreeModel? _malePedigree;
  PedigreeModel? _femalePedigree;
  InbreedingAnalysis? _analysis;

  bool _isLoadingPedigrees = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Планирование случек'),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Информационная карточка
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Выберите самца и самку для автоматического анализа родословной и оценки рисков инбридинга',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Выбор самца
            _buildRabbitSelector(
              label: 'Самец',
              sex: 'male',
              icon: Icons.male,
              color: Colors.blue,
              selectedId: _selectedMaleId,
              rabbits: rabbitsState.rabbits.where((r) => r.sex == 'male').toList(),
              onChanged: (id) {
                setState(() {
                  _selectedMaleId = id;
                  _malePedigree = null;
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
              label: 'Самка',
              sex: 'female',
              icon: Icons.female,
              color: Colors.pink,
              selectedId: _selectedFemaleId,
              rabbits: rabbitsState.rabbits.where((r) => r.sex == 'female').toList(),
              onChanged: (id) {
                setState(() {
                  _selectedFemaleId = id;
                  _femalePedigree = null;
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
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[700]),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка анализа',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[800]),
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
      elevation: 2,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: selectedId,
              decoration: const InputDecoration(
                hintText: 'Выберите кролика',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          'Результаты анализа',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Карточка с коэффициентом инбридинга
        Card(
          color: color.withOpacity(0.1),
          elevation: 4,
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
                  'Коэффициент инбридинга',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _analysis!.coefficientPercent,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  riskLevel.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
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
                  const Row(
                    children: [
                      Icon(Icons.family_restroom),
                      SizedBox(width: 8),
                      Text(
                        'Общие предки',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '${ancestor.closestGeneration} пок.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(width: 8),
                    Text(
                      'Рекомендации',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._analysis!.recommendations.map((recommendation) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      recommendation,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Кнопка "Запланировать случку"
        if (riskLevel != InbreedingRiskLevel.critical)
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Переход к созданию случки
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Функция планирования случки будет добавлена'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.purple[700],
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'Запланировать случку',
              style: TextStyle(fontSize: 16),
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
        _malePedigree = malePedigree;
        _femalePedigree = femalePedigree;
        _analysis = analysis;
        _isLoadingPedigrees = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Не удалось загрузить родословную: $e';
        _isLoadingPedigrees = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    try {
      final months = [
        'янв', 'фев', 'мар', 'апр', 'май', 'июн',
        'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return date.toString();
    }
  }
}
