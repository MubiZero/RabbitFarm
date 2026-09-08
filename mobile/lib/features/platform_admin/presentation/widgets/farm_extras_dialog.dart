import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';

/// Что админ решил про поблажку.
///
/// Три пустых значения — это «снять совсем»: снятая поблажка и есть отсутствие
/// добавок, и отдельного признака для неё не нужно.
typedef FarmExtrasChoice = ({
  int? extraRabbits,
  int? extraStaff,
  DateTime? extrasUntil,
});

/// Разовая поблажка сверх тарифа: сколько добавить и до какого дня.
///
/// Возвращает выбор или `null`, если диалог закрыли, ничего не решив.
Future<FarmExtrasChoice?> showFarmExtrasDialog(
  BuildContext context, {
  required PlatformFarmDetail farm,
}) {
  return showDialog<FarmExtrasChoice>(
    context: context,
    builder: (_) => _FarmExtrasDialog(farm: farm),
  );
}

class _FarmExtrasDialog extends StatefulWidget {
  const _FarmExtrasDialog({required this.farm});

  final PlatformFarmDetail farm;

  @override
  State<_FarmExtrasDialog> createState() => _FarmExtrasDialogState();
}

class _FarmExtrasDialogState extends State<_FarmExtrasDialog> {
  final _rabbits = TextEditingController();
  final _staff = TextEditingController();

  DateTime? _until;
  bool _showEmptyError = false;

  @override
  void initState() {
    super.initState();
    final farm = widget.farm;
    // Форма показывает поблажку целиком, а не «сколько добавить сверх уже
    // добавленного»: иначе «+50» дважды подряд означало бы «+100», чего никто
    // не ожидает от поля с текущим значением.
    _rabbits.text = farm.extraRabbits?.toString() ?? '';
    _staff.text = farm.extraStaff?.toString() ?? '';
    _until = farm.extrasUntil;
  }

  @override
  void dispose() {
    _rabbits.dispose();
    _staff.dispose();
    super.dispose();
  }

  static int? _amountOf(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final value = int.tryParse(trimmed);
    // Ноль — это не добавка, а её отсутствие; так и уходит на сервер.
    return (value == null || value <= 0) ? null : value;
  }

  void _submit() {
    final rabbits = _amountOf(_rabbits.text);
    final staff = _amountOf(_staff.text);

    // Пустая форма неоднозначна: это может быть и «снять поблажку», и
    // забытый ввод. Снятие есть отдельной кнопкой, поэтому здесь — отказ.
    if (rabbits == null && staff == null) {
      setState(() => _showEmptyError = true);
      return;
    }

    Navigator.pop(context, (
      extraRabbits: rabbits,
      extraStaff: staff,
      extrasUntil: _until,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final farm = widget.farm;
    final today = DateTime.now();

    return AlertDialog(
      title: Text(l10n.platformFarmExtrasFormTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.platformFarmExtrasFormBody,
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            _AmountField(
              controller: _rabbits,
              label: l10n.platformFarmExtrasFormRabbits,
              hint: l10n.platformFarmExtrasFormAmountHint,
              icon: Icons.pets_outlined,
              onChanged: () => setState(() => _showEmptyError = false),
            ),
            const SizedBox(height: AppSpacing.md),
            _AmountField(
              controller: _staff,
              label: l10n.platformFarmExtrasFormStaff,
              hint: l10n.platformFarmExtrasFormAmountHint,
              icon: Icons.groups_outlined,
              onChanged: () => setState(() => _showEmptyError = false),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_until == null)
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () => setState(
                    () => _until = today.add(const Duration(days: 30)),
                  ),
                  icon: const Icon(Icons.event_outlined, size: 18),
                  label: Text(l10n.platformFarmExtrasFormSetDeadline),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AppDateField(
                      label: l10n.platformFarmExtrasFormUntil,
                      value: _until!,
                      // Срок в прошлом означал бы поблажку, истёкшую в момент
                      // выдачи, — выбрать такое нельзя.
                      firstDate: DateTime(today.year, today.month, today.day),
                      onChanged: (value) => setState(() => _until = value),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.platformFarmExtrasEndless,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _until = null),
                  ),
                ],
              ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.platformFarmExtrasFormEndlessHint,
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            if (_showEmptyError) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.platformFarmExtrasFormEmpty,
                style: AppTypography.labelSm.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        // Снятие предлагается только там, где есть что снимать: у фермы без
        // поблажки эта кнопка ничего бы не делала.
        if (farm.extraRabbits != null || farm.extraStaff != null)
          TextButton(
            onPressed: () => Navigator.pop(context, (
              extraRabbits: null,
              extraStaff: null,
              extrasUntil: null,
            )),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.platformFarmExtrasClear),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}

/// Добавка по одному ресурсу: целое число или пусто.
class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
