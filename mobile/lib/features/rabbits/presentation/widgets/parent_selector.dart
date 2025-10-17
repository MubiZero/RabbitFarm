import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rabbits_provider.dart';

/// Виджет для выбора родителя кролика
///
/// Фильтрует кроликов по полу и отображает удобный выбор
class ParentSelector extends ConsumerStatefulWidget {
  final String label;
  final String sex; // 'male' или 'female'
  final int? selectedParentId;
  final Function(int?) onChanged;
  final int? excludeRabbitId; // Исключить самого кролика из выбора (при редактировании)

  const ParentSelector({
    super.key,
    required this.label,
    required this.sex,
    this.selectedParentId,
    required this.onChanged,
    this.excludeRabbitId,
  });

  @override
  ConsumerState<ParentSelector> createState() => _ParentSelectorState();
}

class _ParentSelectorState extends ConsumerState<ParentSelector> {
  String _searchQuery = '';
  int? _selectedBreedFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Поле отображения выбранного родителя
        InkWell(
          onTap: () => _showParentDialog(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              prefixIcon: Icon(
                widget.sex == 'male' ? Icons.male : Icons.female,
                color: widget.sex == 'male' ? Colors.blue : Colors.pink,
              ),
              suffixIcon: widget.selectedParentId != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => widget.onChanged(null),
                    )
                  : const Icon(Icons.arrow_drop_down),
            ),
            child: widget.selectedParentId != null
                ? _buildSelectedParentInfo()
                : const Text('Не выбран'),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedParentInfo() {
    // Получаем информацию о выбранном родителе из списка
    final rabbitsState = ref.watch(rabbitsListProvider);

    try {
      final selectedRabbit = rabbitsState.rabbits.firstWhere(
        (r) => r.id == widget.selectedParentId,
      );

      return Row(
        children: [
          Expanded(
            child: Text(
              '${selectedRabbit.name} (${selectedRabbit.tagId})',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (selectedRabbit.breed != null)
            Chip(
              label: Text(
                selectedRabbit.breed!.name,
                style: const TextStyle(fontSize: 11),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
        ],
      );
    } catch (e) {
      // Родитель не найден в списке
      return Text('ID: ${widget.selectedParentId}');
    }
  }

  Future<void> _showParentDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              // Загружаем кроликов с фильтром по полу
              final rabbitsState = ref.watch(rabbitsListProvider);

              // Фильтруем кроликов по полу и исключаем текущего кролика
              final filteredRabbits = rabbitsState.rabbits.where((rabbit) {
                if (rabbit.sex != widget.sex) return false;
                if (widget.excludeRabbitId != null &&
                    rabbit.id == widget.excludeRabbitId) {
                  return false;
                }
                if (_searchQuery.isNotEmpty &&
                    !rabbit.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) &&
                    !rabbit.tagId
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase())) {
                  return false;
                }
                if (_selectedBreedFilter != null &&
                    rabbit.breedId != _selectedBreedFilter) {
                  return false;
                }
                return true;
              }).toList();

              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Row(
                      children: [
                        Icon(
                          widget.sex == 'male' ? Icons.male : Icons.female,
                          color: widget.sex == 'male'
                              ? Colors.blue
                              : Colors.pink,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Поиск
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Поиск',
                        hintText: 'Имя или номер бирки',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Список кроликов
                    Expanded(
                      child: rabbitsState.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filteredRabbits.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Нет подходящих кроликов',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Пол: ${widget.sex == 'male' ? 'самец' : 'самка'}',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredRabbits.length,
                                  itemBuilder: (context, index) {
                                    final rabbit = filteredRabbits[index];
                                    final isSelected =
                                        rabbit.id == widget.selectedParentId;

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: widget.sex == 'male'
                                            ? Colors.blue[100]
                                            : Colors.pink[100],
                                        child: Icon(
                                          widget.sex == 'male'
                                              ? Icons.male
                                              : Icons.female,
                                          color: widget.sex == 'male'
                                              ? Colors.blue
                                              : Colors.pink,
                                        ),
                                      ),
                                      title: Text(
                                        rabbit.name,
                                        style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Бирка: ${rabbit.tagId}'),
                                          if (rabbit.breed != null)
                                            Text(
                                              'Порода: ${rabbit.breed!.name}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: isSelected
                                          ? const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            )
                                          : null,
                                      selected: isSelected,
                                      onTap: () {
                                        widget.onChanged(rabbit.id);
                                        Navigator.of(dialogContext).pop();
                                      },
                                    );
                                  },
                                ),
                    ),

                    // Кнопка "Очистить выбор"
                    if (widget.selectedParentId != null) ...[
                      const Divider(),
                      TextButton.icon(
                        onPressed: () {
                          widget.onChanged(null);
                          Navigator.of(dialogContext).pop();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Очистить выбор'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
