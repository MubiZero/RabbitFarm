import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/farm_status_labels.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/models/platform_admin_models.dart';

/// Строка журнала человеческим языком.
///
/// Сервер пишет в журнал сырые снимки полей (`before`/`after`), своей формы у
/// каждого действия: у `plan.update` это тариф целиком, у `farm.status` —
/// одно поле, у `farm.impersonate` — объяснение админа. Показывать их дампом
/// JSON значит оставить работу разбора человеку, который пришёл за ответом
/// «что тут вообще случилось». Поэтому разбор живёт здесь — один раз, отдельно
/// от карточки.
///
/// Незнакомое действие не скрывается и не ломает список: у него остаётся
/// заголовок с самим кодом, потому что сервер заводит новые действия раньше
/// приложения.

final _dayFormat = DateFormat('dd.MM.yyyy');

/// Что за действие — словами.
String auditActionTitle(BuildContext context, String action) {
  final l10n = context.l10n;
  return switch (action) {
    'plan.create' => l10n.platformAuditActionPlanCreate,
    'plan.update' => l10n.platformAuditActionPlanUpdate,
    'plan.delete' => l10n.platformAuditActionPlanDelete,
    'plan.assign' => l10n.platformAuditActionPlanAssign,
    'farm.status' => l10n.platformAuditActionFarmStatus,
    'farm.extras' => l10n.platformAuditActionFarmExtras,
    'farm.extend_plan' => l10n.platformAuditActionFarmExtendPlan,
    'farm.export' => l10n.platformAuditActionFarmExport,
    'farm.impersonate' => l10n.platformAuditActionFarmImpersonate,
    'farm.delete' => l10n.platformAuditActionFarmDelete,
    'farm.restore' => l10n.platformAuditActionFarmRestore,
    'announcement.send' => l10n.platformAuditActionAnnouncementSend,
    'support_request.resolve' => l10n.platformAuditActionSupportResolve,
    'support_contact.update' => l10n.platformAuditActionSupportContact,
    _ => l10n.platformAuditActionUnknown(action),
  };
}

IconData auditActionIcon(String action) => switch (action) {
      'plan.create' || 'plan.update' || 'plan.delete' => Icons.sell_outlined,
      'plan.assign' => Icons.swap_horiz,
      'farm.status' => Icons.lock_outline,
      'farm.extras' => Icons.add_circle_outline,
      'farm.extend_plan' => Icons.event_available_outlined,
      'farm.export' => Icons.download_outlined,
      'farm.impersonate' => Icons.visibility_outlined,
      'farm.delete' => Icons.delete_forever_outlined,
      'farm.restore' => Icons.restore_from_trash_outlined,
      'announcement.send' => Icons.campaign_outlined,
      'support_request.resolve' => Icons.support_agent_outlined,
      'support_contact.update' => Icons.contact_support_outlined,
      _ => Icons.history,
    };

/// Тревожность действия. Подкрашены только необратимые и те, за которые
/// спрашивают отдельно: вход под клиентом и удаление фермы. Остальные —
/// обычная работа, и красить их значило бы приучить глаз скользить мимо
/// красного.
Color? auditActionColor(String action) => switch (action) {
      'farm.delete' => AppColors.error,
      'farm.impersonate' => AppColors.warning,
      _ => null,
    };

/// Что именно изменилось — по строке на изменение.
///
/// [plans] нужны, потому что сервер пишет в журнал `plan_id`, а не название:
/// без них «Тариф: 1 → 2» ничего не сообщает. Тариф, удалённый с тех пор,
/// остаётся номером — придумывать ему имя нечем.
List<String> auditChangeLines(
  BuildContext context,
  AdminAuditEntry entry, {
  List<Plan> plans = const [],
}) {
  final l10n = context.l10n;
  final before = entry.before;
  final after = entry.after;

  String change(String field, String from, String to) =>
      l10n.platformAuditChange(field, from, to);
  String detail(String field, String value) =>
      l10n.platformAuditDetail(field, value);

  switch (entry.action) {
    case 'plan.create':
      return _planSnapshot(context, after);
    case 'plan.delete':
      return _planSnapshot(context, before);
    case 'plan.update':
      return _planDiff(context, before, after);

    case 'plan.assign':
      return [
        change(
          l10n.platformAuditFieldPlan,
          _planName(context, plans, before?['plan_id']),
          _planName(context, plans, after?['plan_id']),
        ),
      ];

    case 'farm.status':
      return [
        change(
          l10n.platformAuditFieldStatus,
          farmStatusLabel(context, _str(before?['status']) ?? ''),
          farmStatusLabel(context, _str(after?['status']) ?? ''),
        ),
      ];

    case 'farm.extend_plan':
      return [
        change(
          l10n.platformAuditFieldPlanExpiry,
          _dateOrEndless(context, before?['plan_expires_at']),
          _dateOrEndless(context, after?['plan_expires_at']),
        ),
      ];

    case 'farm.extras':
      final granted = _extrasSummary(context, after);
      return granted == null
          ? const []
          : [detail(l10n.platformAuditFieldExtras, granted)];

    case 'farm.impersonate':
      // Ради этой строки у админа и спрашивают объяснение при входе под
      // клиентом — без неё журнал знает только, что вход был.
      final reason = _str(after?['reason'])?.trim();
      return reason == null || reason.isEmpty
          ? const []
          : [detail(l10n.platformAuditFieldReason, reason)];

    case 'announcement.send':
      final farms = _int(after?['farms_count']) ?? 0;
      final recipients = _int(after?['recipients_count']) ?? 0;
      return [l10n.platformAnnouncementReach(farms, recipients)];

    case 'support_request.resolve':
      final id = _int(after?['id']);
      if (id == null) return const [];
      return [
        after?['answered'] == true
            ? l10n.platformAuditSupportAnswered(id)
            : l10n.platformAuditSupportClosed(id),
      ];

    case 'support_contact.update':
      return [
        if (before?['email'] != after?['email'])
          change(
            l10n.platformSupportContactEmail,
            _valueOrNone(context, before?['email']),
            _valueOrNone(context, after?['email']),
          ),
        if (before?['phone'] != after?['phone'])
          change(
            l10n.platformSupportContactPhone,
            _valueOrNone(context, before?['phone']),
            _valueOrNone(context, after?['phone']),
          ),
      ];

    // `farm.export`, `farm.delete`, `farm.restore` и всё незнакомое:
    // заголовок уже сказал всё, а `deleted_at` в снимке лишь повторяет время
    // самой записи журнала.
    default:
      return const [];
  }
}

/// Тариф целиком — когда его завели или удалили.
List<String> _planSnapshot(BuildContext context, Map<String, dynamic>? snap) {
  if (snap == null) return const [];
  final l10n = context.l10n;
  final name = _str(snap['name']);

  return [
    if (name != null)
      l10n.platformAuditDetail(l10n.platformAuditFieldName, name),
    l10n.platformAuditDetail(
      l10n.platformAuditFieldLimits,
      _limits(context, _int(snap['max_rabbits']), _int(snap['max_staff'])),
    ),
    l10n.platformAuditDetail(
      l10n.platformAuditFieldPrice,
      _price(context, snap['price']),
    ),
  ];
}

/// Что именно правили в тарифе — только изменившиеся поля.
///
/// Показывать весь тариф на каждой правке значит заставить сличать два
/// списка глазами: вопрос админа — «что поменяли», а не «каким тариф стал».
List<String> _planDiff(
  BuildContext context,
  Map<String, dynamic>? before,
  Map<String, dynamic>? after,
) {
  if (before == null || after == null) return _planSnapshot(context, after);
  final l10n = context.l10n;
  final lines = <String>[];

  if (before['name'] != after['name']) {
    lines.add(l10n.platformAuditChange(
      l10n.platformAuditFieldName,
      _valueOrNone(context, before['name']),
      _valueOrNone(context, after['name']),
    ));
  }
  if (_int(before['max_rabbits']) != _int(after['max_rabbits'])) {
    lines.add(l10n.platformAuditChange(
      l10n.platformAuditFieldRabbitsLimit,
      _limitOrUnlimited(context, _int(before['max_rabbits'])),
      _limitOrUnlimited(context, _int(after['max_rabbits'])),
    ));
  }
  if (_int(before['max_staff']) != _int(after['max_staff'])) {
    lines.add(l10n.platformAuditChange(
      l10n.platformAuditFieldStaffLimit,
      _limitOrUnlimited(context, _int(before['max_staff'])),
      _limitOrUnlimited(context, _int(after['max_staff'])),
    ));
  }
  // Цена приезжает от MySQL строкой ("150.00"), поэтому сравнивается числом:
  // "150" и "150.00" — одна и та же цена, а не правка.
  if (_double(before['price']) != _double(after['price'])) {
    lines.add(l10n.platformAuditChange(
      l10n.platformAuditFieldPrice,
      _price(context, before['price']),
      _price(context, after['price']),
    ));
  }
  if (before['is_active'] != after['is_active']) {
    lines.add(after['is_active'] == true
        ? l10n.platformAuditPlanEnabled
        : l10n.platformAuditPlanDisabled);
  }
  if (before['is_default'] != after['is_default']) {
    lines.add(after['is_default'] == true
        ? l10n.platformAuditPlanBecameDefault
        : l10n.platformAuditPlanNoLongerDefault);
  }

  return lines;
}

/// Название тарифа по его номеру. Пустой номер — «без тарифа», а не «номер
/// потерялся»: снятие тарифа записывается именно так.
String _planName(BuildContext context, List<Plan> plans, Object? rawId) {
  final id = _int(rawId);
  if (id == null) return context.l10n.platformNoPlan;

  final plan = plans.where((plan) => plan.id == id).firstOrNull;
  return plan?.name ?? context.l10n.platformAuditPlanRef(id);
}

String _limits(BuildContext context, int? rabbits, int? staff) {
  final l10n = context.l10n;
  final parts = [
    if (rabbits != null) l10n.platformPlanLimitRabbits(rabbits),
    if (staff != null) l10n.platformPlanLimitStaff(staff),
  ];
  return parts.isEmpty ? l10n.platformPlanUnlimited : parts.join(' · ');
}

String _limitOrUnlimited(BuildContext context, int? limit) =>
    limit == null ? context.l10n.platformPlanUnlimited : '$limit';

String _price(BuildContext context, Object? raw) {
  final price = _double(raw);
  return price == null || price == 0
      ? context.l10n.platformPlanFree
      : formatMoney(price);
}

/// Поблажка словами. Пустая тройка — это «снята», а не «ничего не
/// произошло»: так её и снимают.
String? _extrasSummary(BuildContext context, Map<String, dynamic>? snap) {
  if (snap == null) return null;
  final l10n = context.l10n;

  final rabbits = _int(snap['extra_rabbits']);
  final staff = _int(snap['extra_staff']);
  if (rabbits == null && staff == null) return l10n.platformFarmExtrasCleared;

  final until = _date(snap['extras_until']);
  return [
    if (rabbits != null) l10n.platformFarmExtrasRabbits(rabbits),
    if (staff != null) l10n.platformFarmExtrasStaff(staff),
    until == null
        ? l10n.platformFarmExtrasEndless
        : l10n.platformFarmExtrasUntil(_dayFormat.format(until)),
  ].join(' · ');
}

String _dateOrEndless(BuildContext context, Object? raw) {
  final date = _date(raw);
  return date == null
      ? context.l10n.platformFarmExtrasEndless
      : _dayFormat.format(date);
}

String _valueOrNone(BuildContext context, Object? raw) {
  final value = _str(raw)?.trim();
  return value == null || value.isEmpty
      ? context.l10n.platformAuditValueNone
      : value;
}

// Снимки в журнале — обычный JSON, и числа в них приходят то числом, то
// строкой (DECIMAL от MySQL). Разбор терпимый: сорвать показ всей страницы
// журнала из-за одного неожиданного поля нельзя.
int? _int(Object? value) => switch (value) {
      final int v => v,
      final num v => v.toInt(),
      final String v => int.tryParse(v),
      _ => null,
    };

double? _double(Object? value) => switch (value) {
      final num v => v.toDouble(),
      final String v => double.tryParse(v),
      _ => null,
    };

String? _str(Object? value) => value is String ? value : value?.toString();

DateTime? _date(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;
