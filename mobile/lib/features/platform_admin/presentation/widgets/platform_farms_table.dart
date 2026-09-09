import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import 'platform_farm_card.dart';

final _dayFormat = DateFormat('dd.MM.yyyy');

/// Список ферм табличным видом — замена столбику [PlatformFarmCard] на
/// широком экране (см. `AppBreakpoints.wideScreen`).
///
/// Карточки хорошо читаются одна под другой на телефоне, но на большом
/// экране браузера (`rabbitfarm-web`, см. docs/plans/PLATFORM-ADMIN.md)
/// превращают тридцать ферм в тридцать экранов прокрутки, хотя вопрос
/// админа обычно один — «у кого что с тарифом», а это вопрос про сравнение
/// строк взглядом, не про карточки.
///
/// Своя горизонтальная прокрутка — подстраховка на нижней границе
/// брейкпоинта: колонок семь плюс действие, и на 900px они местами тесны.
class PlatformFarmsTable extends StatelessWidget {
  const PlatformFarmsTable({
    super.key,
    required this.farms,
    required this.onChangePlan,
    required this.onOpen,
  });

  final List<PlatformFarm> farms;
  final ValueChanged<PlatformFarm> onChangePlan;
  final ValueChanged<PlatformFarm> onOpen;

  static const _minWidth = AppBreakpoints.wideScreen - 2 * AppSpacing.screenH;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _minWidth),
          child: SizedBox(
            width: _minWidth,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _TableHeaderRow(),
                  const Divider(height: 1),
                  for (var i = 0; i < farms.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    _TableRow(
                      farm: farms[i],
                      onChangePlan: () => onChangePlan(farms[i]),
                      onOpen: () => onOpen(farms[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ширины колонок в долях [Expanded] — общие для заголовка и строк, чтобы
/// значения не съезжали относительно подписи над ними.
class _Columns {
  static const name = 3;
  static const owner = 3;
  static const plan = 2;
  static const rabbits = 2;
  static const staff = 2;
  static const lastActive = 2;
  static const createdAt = 2;

  /// Ширина колонки действия — фиксированная, под один `IconButton`, а не
  /// доля: остальные колонки не должны ужиматься ради пустого места вокруг
  /// иконки.
  static const actionWidth = 48.0;
}

class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = AppTypography.labelSm
        .copyWith(color: context.colors.onSurfaceVariant);

    Widget cell(int flex, String text) => Expanded(
          flex: flex,
          child: Text(text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          cell(_Columns.name, l10n.platformFarmTitleFallback),
          cell(_Columns.owner, l10n.staffOwner),
          cell(_Columns.plan, l10n.platformFarmSectionPlan),
          cell(_Columns.rabbits, l10n.platformRabbits),
          cell(_Columns.staff, l10n.platformStaff),
          cell(_Columns.lastActive, l10n.platformFarmLastActive),
          cell(_Columns.createdAt, l10n.platformFarmCreatedAt),
          SizedBox(width: _Columns.actionWidth),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.farm,
    required this.onChangePlan,
    required this.onOpen,
  });

  final PlatformFarm farm;
  final VoidCallback onChangePlan;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final owner = farm.owner;
    final bodyStyle =
        AppTypography.bodyMd.copyWith(color: context.colors.onSurface);
    final mutedStyle = AppTypography.bodyMd
        .copyWith(color: context.colors.onSurfaceVariant);

    Widget text(int flex, String value, {TextStyle? style}) => Expanded(
          flex: flex,
          child: Text(
            value,
            style: style ?? bodyStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );

    return InkWell(
      onTap: onOpen,
      child: Container(
        // Та же тревожная полоса слева, что и у карточки в этом же
        // состоянии (AppCardVariant.error) — упёршуюся в предел ферму
        // видно с первого взгляда вдоль всей таблицы, не только заглянув в
        // числа.
        decoration: farm.isAtLimit
            ? const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.error, width: 4)),
              )
            : null,
        padding: EdgeInsets.only(
          left: farm.isAtLimit ? AppSpacing.lg - 4 : AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            text(_Columns.name, farm.name, style: bodyStyle.copyWith(fontWeight: FontWeight.w600)),
            Expanded(
              flex: _Columns.owner,
              child: owner == null
                  ? Text(l10n.platformOwnerMissing, style: mutedStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
                  : Tooltip(
                      // Контакт целиком доступен по наведению/долгому тапу —
                      // колонка слишком узкая для «имя · почта · телефон»
                      // одной строкой, а имя одно достаточно, чтобы узнать
                      // ферму в списке.
                      message: [owner.fullName, owner.email, owner.phone]
                          .whereType<String>()
                          .where((part) => part.trim().isNotEmpty)
                          .join(' · '),
                      child: Text(owner.fullName, style: bodyStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
            ),
            Expanded(flex: _Columns.plan, child: PlanChip(plan: farm.plan)),
            Expanded(
              flex: _Columns.rabbits,
              child: _UsageCell(used: farm.rabbitsCount, limit: farm.plan?.maxRabbits),
            ),
            Expanded(
              flex: _Columns.staff,
              child: _UsageCell(used: farm.staffCount, limit: farm.plan?.maxStaff),
            ),
            text(
              _Columns.lastActive,
              farm.lastActiveAt == null ? l10n.platformFarmNeverActive : _dayFormat.format(farm.lastActiveAt!),
              style: mutedStyle,
            ),
            text(_Columns.createdAt, _dayFormat.format(farm.createdAt), style: mutedStyle),
            SizedBox(
              width: _Columns.actionWidth,
              child: IconButton(
                icon: const Icon(Icons.sell_outlined, size: 20),
                tooltip: farm.plan == null ? l10n.platformAssignPlan : l10n.platformChangePlan,
                onPressed: onChangePlan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «48 из 200» с той же цветовой логикой, что и полоса на карточке
/// ([FarmUsageRow]) — таблице просто не хватает ширины строки под саму
/// полосу, число говорит то же самое компактнее.
class _UsageCell extends StatelessWidget {
  const _UsageCell({required this.used, required this.limit});

  final int used;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (limit == null || limit! <= 0) {
      return Text(
        l10n.platformUsageUnlimited(used),
        style: AppTypography.bodyMd.copyWith(color: context.colors.onSurfaceVariant),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final fraction = used / limit!;
    final color = fraction >= 1
        ? AppColors.error
        : fraction >= 0.8
            ? AppColors.warning
            : context.colors.onSurface;

    return Text(
      l10n.platformUsageOfLimit(used, limit!),
      style: AppTypography.bodyMd.copyWith(color: color, fontWeight: fraction >= 0.8 ? FontWeight.w600 : null),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
