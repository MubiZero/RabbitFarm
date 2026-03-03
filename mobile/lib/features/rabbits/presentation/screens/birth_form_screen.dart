import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/birth_model.dart';
import '../../data/models/breeding_model.dart';
import '../providers/births_provider.dart';
import '../providers/rabbits_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';

/// Экран формы регистрации окрола
class BirthFormScreen extends ConsumerStatefulWidget {
  final BirthModel? birth;
  final BreedingModel? breeding;

  const BirthFormScreen({
    super.key,
    this.birth,
    this.breeding,
  });

  @override
  ConsumerState<BirthFormScreen> createState() => _BirthFormScreenState();
}

class _BirthFormScreenState extends ConsumerState<BirthFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kitsBornAliveController;
  late TextEditingController _kitsBornDeadController;
  late TextEditingController _complicationsController;
  late TextEditingController _notesController;

  int? _selectedMotherId;
  DateTime _birthDate = DateTime.now();
  bool _isSubmitting = false;
  bool _createKits = true;

  @override
  void initState() {
    super.initState();
    _kitsBornAliveController = TextEditingController(
      text: widget.birth?.kitsBornAlive.toString() ?? '',
    );
    _kitsBornDeadController = TextEditingController(
      text: widget.birth?.kitsBornDead.toString() ?? '',
    );
    _complicationsController = TextEditingController(
      text: widget.birth?.complications ?? '',
    );
    _notesController = TextEditingController(
      text: widget.birth?.notes ?? '',
    );

    _selectedMotherId = widget.birth?.motherId ?? widget.breeding?.femaleId;
    if (widget.birth?.birthDate != null) {
      _birthDate = DateTime.parse(widget.birth!.birthDate);
    }
  }

  @override
  void dispose() {
    _kitsBornAliveController.dispose();
    _kitsBornDeadController.dispose();
    _complicationsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.birth != null;
    final rabbitsState = ref.watch(rabbitsListProvider);
    final females =
        rabbitsState.rabbits.where((r) => r.sex == 'female').toList();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEditing ? 'Редактировать окрол' : 'Зарегистрировать окрол'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Info card
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
                        'Зарегистрируйте окрол и автоматически создайте карточки для крольчат',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.accentOcean,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            AppFormSection(
              title: 'Основное',
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedMotherId,
                  decoration: const InputDecoration(
                    labelText: 'Самка (мать) *',
                    prefixIcon: Icon(Icons.female),
                  ),
                  items: females.map((rabbit) {
                    return DropdownMenuItem(
                      value: rabbit.id,
                      child: Text('${rabbit.name} (${rabbit.tagId})'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedMotherId = value),
                  validator: (value) =>
                      value == null ? 'Выберите самку' : null,
                ),
                AppDateField(
                  label: 'Дата окрола *',
                  value: _birthDate,
                  onChanged: (date) => setState(() => _birthDate = date),
                  prefixIcon: Icons.calendar_today,
                  lastDate: DateTime.now(),
                ),
              ],
            ),

            AppFormSection(
              title: 'Статистика помёта',
              children: [
                TextFormField(
                  controller: _kitsBornAliveController,
                  decoration: InputDecoration(
                    labelText: 'Родилось живыми *',
                    hintText: 'Количество',
                    prefixIcon:
                        Icon(Icons.child_care, color: AppColors.success),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите количество';
                    }
                    final num = int.tryParse(value);
                    if (num == null || num < 0) {
                      return 'Введите корректное число';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _kitsBornDeadController,
                  decoration: InputDecoration(
                    labelText: 'Родилось мертвыми',
                    hintText: 'Количество (опционально)',
                    prefixIcon: Icon(Icons.close, color: AppColors.error),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final num = int.tryParse(value);
                      if (num == null || num < 0) {
                        return 'Введите корректное число';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),

            AppFormSection(
              title: 'Дополнительно',
              children: [
                TextFormField(
                  controller: _complicationsController,
                  decoration: const InputDecoration(
                    labelText: 'Осложнения',
                    hintText: 'Опишите, если были осложнения',
                    prefixIcon: Icon(Icons.warning_amber_outlined),
                  ),
                  maxLines: 2,
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Заметки',
                    hintText: 'Дополнительная информация',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                ),
              ],
            ),

            if (!isEditing)
              Card(
                color: AppColors.success.withValues(alpha: 0.08),
                child: CheckboxListTile(
                  title: const Text(
                    'Автоматически создать карточки крольчат',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Builder(
                    builder: (context) => Text(
                      'Будет создано ${_kitsBornAliveController.text.isNotEmpty ? _kitsBornAliveController.text : "0"} карточек',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  value: _createKits,
                  onChanged: (value) =>
                      setState(() => _createKits = value ?? false),
                  secondary: Icon(Icons.auto_awesome, color: AppColors.success),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Сохранить' : 'Зарегистрировать'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final birthData = {
      'mother_id': _selectedMotherId,
      if (widget.breeding != null) 'breeding_id': widget.breeding!.id,
      'birth_date': _birthDate.toIso8601String().split('T')[0],
      'kits_born_alive': int.parse(_kitsBornAliveController.text),
      'kits_born_dead': _kitsBornDeadController.text.isNotEmpty
          ? int.parse(_kitsBornDeadController.text)
          : 0,
      if (_complicationsController.text.isNotEmpty)
        'complications': _complicationsController.text,
      if (_notesController.text.isNotEmpty) 'notes': _notesController.text,
    };

    final isEditing = widget.birth != null;
    BirthModel? birth;

    if (isEditing) {
      final success = await ref
          .read(birthsProvider.notifier)
          .updateBirth(widget.birth!.id, birthData);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Окрол обновлен')),
          );
          context.pop();
        } else {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  ref.read(birthsProvider).error ?? 'Ошибка обновления окрола'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } else {
      birth = await ref.read(birthsProvider.notifier).createBirth(birthData);

      if (mounted) {
        if (birth != null) {
          if (_createKits && int.parse(_kitsBornAliveController.text) > 0) {
            await _createKitsDialog(context, birth);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Окрол зарегистрирован')),
            );
            context.pop();
          }
        } else {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ref.read(birthsProvider).error ??
                  'Ошибка регистрации окрола'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _createKitsDialog(
      BuildContext context, BirthModel birth) async {
    final cs = Theme.of(context).colorScheme;
    final mother = ref.read(rabbitsListProvider).rabbits.firstWhere(
          (r) => r.id == birth.motherId,
        );

    final namePrefixController = TextEditingController(
      text: '${mother.name}-',
    );

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Создать карточки крольчат?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Будет создано ${birth.kitsBornAlive} карточек кроликов',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: namePrefixController,
              decoration: const InputDecoration(
                labelText: 'Префикс имени',
                hintText: 'Например: Белка-',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Крольчата будут названы: ${namePrefixController.text}1, ${namePrefixController.text}2, ...',
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Создать'),
          ),
        ],
      ),
    );

    if (shouldCreate == true && mounted) {
      final kits = await ref.read(birthsProvider.notifier).createKitsFromBirth(
            birthId: birth.id,
            motherId: birth.motherId,
            fatherId: widget.breeding?.maleId,
            breedId: mother.breed!.id,
            birthDate: birth.birthDate,
            count: birth.kitsBornAlive,
            namePrefix: namePrefixController.text,
          );

      if (mounted) {
        if (kits != null) {
          await ref.read(rabbitsListProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Окрол зарегистрирован! Создано ${kits.length} крольчат'),
              duration: const Duration(seconds: 4),
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  ref.read(birthsProvider).error ?? 'Ошибка создания крольчат'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Окрол зарегистрирован')),
      );
      context.pop();
    }

    setState(() => _isSubmitting = false);
  }
}
