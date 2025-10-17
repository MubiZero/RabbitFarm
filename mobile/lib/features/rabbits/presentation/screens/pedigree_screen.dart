import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/pedigree_model.dart';
import '../providers/pedigree_provider.dart';

/// Экран отображения родословной кролика
///
/// Показывает древо предков в вертикальном списке по поколениям
class PedigreeScreen extends ConsumerWidget {
  final int rabbitId;
  final String rabbitName;

  const PedigreeScreen({
    super.key,
    required this.rabbitId,
    required this.rabbitName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedigreeAsync = ref.watch(pedigreeProvider(rabbitId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Родословная: $rabbitName'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: pedigreeAsync.when(
        data: (pedigree) => _buildPedigreeContent(context, pedigree),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _buildErrorWidget(context, error, stack),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stack) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'Ошибка загрузки родословной',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Вернуться назад'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedigreeContent(BuildContext context, PedigreeModel pedigree) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Заголовок
        _buildGenerationHeader('Кролик', 0),
        const SizedBox(height: 12),

        // Сам кролик
        _buildRabbitCard(context, pedigree, isPrimary: true),

        // Родители (Поколение 1)
        if (pedigree.father != null || pedigree.mother != null) ...[
          const SizedBox(height: 32),
          _buildGenerationHeader('Родители', 1),
          const SizedBox(height: 12),

          if (pedigree.father != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildRabbitCard(context, pedigree.father!, label: 'Отец'),
            ),

          if (pedigree.mother != null)
            _buildRabbitCard(context, pedigree.mother!, label: 'Мать'),
        ],

        // Бабушки и дедушки (Поколение 2)
        if (_hasGrandparents(pedigree)) ...[
          const SizedBox(height: 32),
          _buildGenerationHeader('Бабушки и дедушки', 2),
          const SizedBox(height: 12),

          // Родители отца
          if (pedigree.father != null) ...[
            if (pedigree.father!.father != null || pedigree.father!.mother != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildParentsGroup(
                  context,
                  'Родители отца',
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
                'Родители матери',
                pedigree.mother!.father,
                pedigree.mother!.mother,
              ),
          ],
        ],

        const SizedBox(height: 32),

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
                    'Нажмите на карточку кролика, чтобы открыть его детали',
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
    final colors = [
      Colors.green[700]!,
      Colors.blue[700]!,
      Colors.purple[700]!,
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors[generation % colors.length],
          ),
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        if (father != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRabbitCard(context, father, label: 'Дедушка', isSmall: true),
          ),
        if (mother != null)
          _buildRabbitCard(context, mother, label: 'Бабушка', isSmall: true),
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
    Color? cardColor;
    Color? borderColor;
    IconData sexIcon;

    if (rabbit.sex == 'male') {
      cardColor = Colors.blue[50];
      borderColor = Colors.blue[300];
      sexIcon = Icons.male;
    } else if (rabbit.sex == 'female') {
      cardColor = Colors.pink[50];
      borderColor = Colors.pink[300];
      sexIcon = Icons.female;
    } else {
      cardColor = Colors.grey[50];
      borderColor = Colors.grey[300];
      sexIcon = Icons.help_outline;
    }

    return InkWell(
      onTap: () {
        context.push('/rabbits/${rabbit.id}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(
            color: isPrimary ? Colors.green : borderColor!,
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
                color: rabbit.sex == 'male'
                    ? Colors.blue[100]
                    : rabbit.sex == 'female'
                        ? Colors.pink[100]
                        : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                sexIcon,
                size: isSmall ? 24 : 32,
                color: rabbit.sex == 'male'
                    ? Colors.blue[700]
                    : rabbit.sex == 'female'
                        ? Colors.pink[700]
                        : Colors.grey[700],
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
                        style: TextStyle(
                          fontSize: isSmall ? 11 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  // Имя
                  Text(
                    rabbit.name,
                    style: TextStyle(
                      fontSize: isSmall ? 15 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Tag ID
                  if (rabbit.tagId != null && rabbit.tagId!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.tag,
                          size: isSmall ? 14 : 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rabbit.tagId!,
                          style: TextStyle(
                            fontSize: isSmall ? 12 : 14,
                            color: Colors.grey[700],
                          ),
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
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              rabbit.breed!,
                              style: TextStyle(
                                fontSize: isSmall ? 12 : 14,
                                color: Colors.grey[700],
                              ),
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
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(rabbit.birthDate!),
                            style: TextStyle(
                              fontSize: isSmall ? 11 : 13,
                              color: Colors.grey[600],
                            ),
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
              color: Colors.grey[400],
              size: isSmall ? 20 : 24,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'янв', 'фев', 'мар', 'апр', 'май', 'июн',
        'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
