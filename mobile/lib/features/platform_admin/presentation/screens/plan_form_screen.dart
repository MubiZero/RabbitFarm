import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';

/// Карточка тарифа.
///
/// Пустое поле предела — это «без ограничения», а не ноль, и так подписано
/// прямо в подсказке: тариф с нулём кроликов не имел бы смысла, а угадывать,
/// что означает пустота, пользователь не должен.
class PlanFormScreen extends ConsumerStatefulWidget {
  const PlanFormScreen({super.key, this.plan});

  final Plan? plan;

  @override
  ConsumerState<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends ConsumerState<PlanFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _maxRabbits = TextEditingController();
  final _maxStaff = TextEditingController();

  late bool _isActive;
  bool _touched = false;

  Plan? get _plan => widget.plan;
  bool get _isEditing => _plan != null;

  @override
  void initState() {
    super.initState();
    final plan = _plan;
    _name.text = plan?.name ?? '';
    // Не `toString()`: цена приходит дробной, и в поле оказывалось «150.0».
    // `formatQuantity` даёт «150», а `parseDecimal` при сохранении принимает
    // и запятую, и разделители разрядов обратно.
    final price = plan?.price;
    _price.text = price == null ? '' : formatQuantity(price);
    _maxRabbits.text = plan?.maxRabbits?.toString() ?? '';
    _maxStaff.text = plan?.maxStaff?.toString() ?? '';
    _isActive = plan?.isActive ?? true;

    for (final c in [_name, _price, _maxRabbits, _maxStaff]) {
      c.addListener(() => _touched = true);
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _price, _maxRabbits, _maxStaff]) {
      c.dispose();
    }
    super.dispose();
  }

  static int? _limitOf(String raw) {
    final trimmed = raw.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
  }

  Future<Object?> _save() async {
    final repository = ref.read(platformAdminRepositoryProvider);
    final draft = PlanDraft(
      name: _name.text.trim(),
      price: parseDecimal(_price.text),
      maxRabbits: _limitOf(_maxRabbits.text),
      maxStaff: _limitOf(_maxStaff.text),
      isActive: _isActive,
    );

    try {
      if (_isEditing) {
        await repository.updatePlan(_plan!.id, draft);
      } else {
        await repository.createPlan(draft);
      }
      ref.invalidate(platformPlansProvider);
      // Пределы могли измениться у тарифа, который уже кому-то назначен, —
      // карточки ферм показывали бы прежние.
      ref.invalidate(platformFarmsProvider);
      return null;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFormScaffold(
      title: _isEditing
          ? l10n.platformPlanFormEditTitle
          : l10n.platformPlanFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing ? l10n.commonSave : l10n.commonAdd,
      successMessage: _isEditing
          ? l10n.platformPlanFormUpdated
          : l10n.platformPlanFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      children: [
        AppFormSection(
          title: l10n.commonSectionMain,
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.platformPlanFormName,
                hintText: l10n.platformPlanFormNameHint,
                prefixIcon: const Icon(Icons.sell_outlined),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.platformPlanFormNameEmpty
                  : null,
            ),
            TextFormField(
              controller: _price,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.platformPlanFormPrice,
                hintText: l10n.platformPlanFormPriceHint,
                prefixIcon: const Icon(Icons.payments_outlined),
                suffixText: kCurrencySymbol,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final value = parseDecimal(v);
                return (value == null || value < 0)
                    ? l10n.commonNumberInvalid
                    : null;
              },
            ),
          ],
        ),
        AppFormSection(
          title: l10n.platformPlanFormSectionLimits,
          children: [
            _LimitField(
              controller: _maxRabbits,
              label: l10n.platformPlanFormMaxRabbits,
              hint: l10n.platformPlanFormLimitHint,
              icon: Icons.pets_outlined,
            ),
            _LimitField(
              controller: _maxStaff,
              label: l10n.platformPlanFormMaxStaff,
              hint: l10n.platformPlanFormLimitHint,
              icon: Icons.groups_outlined,
            ),
          ],
        ),
        AppCard(
          child: SwitchListTile(
            value: _isActive,
            onChanged: (value) => setState(() {
              _isActive = value;
              _touched = true;
            }),
            contentPadding: EdgeInsets.zero,
            title: Text(
              l10n.platformPlanFormActive,
              style: AppTypography.bodyLg
                  .copyWith(color: context.colors.onSurface),
            ),
            subtitle: Text(
              l10n.platformPlanFormActiveHint,
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
        ),
      ],
    );
  }
}

/// Предел по одному ресурсу: целое число или пусто.
class _LimitField extends StatelessWidget {
  const _LimitField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        final value = int.tryParse(v.trim());
        // Ноль сервер не примет (предел должен быть положительным), и это
        // правильно: тариф, запрещающий даже одного кролика, — не тариф.
        return (value == null || value <= 0)
            ? context.l10n.commonNumberInvalid
            : null;
      },
    );
  }
}
