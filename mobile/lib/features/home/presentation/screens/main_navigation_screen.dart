import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../widgets/quick_entry_sheet.dart';

/// Вкладка нижнего меню.
class NavTab {
  /// Постоянное имя вкладки для аналитики. Не подпись (её переводят) и не
  /// путь: «Хозяйство» владельца и «Профиль» работника живут на одном
  /// `/farm`, а в отчёте это разные места.
  final String id;
  final String path;
  final IconData icon;
  final IconData active;
  final String Function(BuildContext) label;

  const NavTab({
    required this.id,
    required this.path,
    required this.icon,
    required this.active,
    required this.label,
  });
}

/// Каркас с вкладками и кнопкой записи.
///
/// Вкладки собираются по роли: у работника нет ни стада, ни разведения —
/// заводить их ему нечем, а «Хозяйство» это деньги и люди, куда его и так
/// не пускает сервер. Показывать вкладку, за которой для человека пусто,
/// хуже, чем не показывать её вовсе.
class MainNavigationScreen extends ConsumerStatefulWidget {
  final Widget child;
  final String currentPath;

  const MainNavigationScreen({
    super.key,
    required this.currentPath,
    required this.child,
  });

  static final _today = NavTab(
    id: 'today',
    path: '/today',
    icon: Icons.today_outlined,
    active: Icons.today,
    label: (c) => c.l10n.navToday,
  );

  static final _herd = NavTab(
    id: 'herd',
    path: '/herd',
    icon: Icons.pets_outlined,
    active: Icons.pets,
    label: (c) => c.l10n.navHerd,
  );

  static final _breeding = NavTab(
    id: 'breeding',
    path: '/breeding',
    icon: Icons.favorite_outline,
    active: Icons.favorite,
    label: (c) => c.l10n.navBreeding,
  );

  static final _farm = NavTab(
    id: 'farm',
    path: '/farm',
    icon: Icons.inventory_outlined,
    active: Icons.inventory,
    label: (c) => c.l10n.navFarm,
  );

  static final _journal = NavTab(
    id: 'journal',
    path: '/journal',
    icon: Icons.assignment_outlined,
    active: Icons.assignment,
    label: (c) => c.l10n.navJournal,
  );

  static final _profile = NavTab(
    id: 'profile',
    path: '/farm',
    icon: Icons.person_outline,
    active: Icons.person,
    label: (c) => c.l10n.navProfile,
  );

  /// Работнику — три вкладки: смена, что он записал, и он сам.
  static List<NavTab> tabsFor(FarmRoleAccess role) =>
      role == FarmRoleAccess.worker
          ? [_today, _journal, _profile]
          : [_today, _herd, _breeding, _farm];

  /// Совпадение по началу пути: карточки и формы лежат под теми же
  /// префиксами, и подсветка вкладки не должна с них слетать.
  static int selectedIndex(List<NavTab> tabs, String path) {
    for (var i = tabs.length - 1; i >= 0; i--) {
      if (path.startsWith(tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  /// Вкладка, о посещении которой уже отправлено событие. Считаем именно
  /// вкладку, а не путь: переход из списка стада в карточку кролика — это
  /// та же вкладка, второе событие там было бы шумом.
  String? _reportedTab;

  void _reportTab(NavTab tab) {
    if (_reportedTab == tab.id) return;
    _reportedTab = tab.id;
    Analytics.tabViewed(tab.id);
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(farmRoleProvider);
    final tabs = MainNavigationScreen.tabsFor(role);
    final index = MainNavigationScreen.selectedIndex(tabs, widget.currentPath);

    // Вкладку открывают не только нижним меню: на неё уводят карточки
    // «Сегодня», уведомления и лист быстрой записи — поэтому событие пишется
    // по факту показанной вкладки, а не по нажатию на кнопку меню.
    _reportTab(tabs[index]);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(tabs[i].path),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.active),
              label: tab.label(context),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: context.l10n.navRecord,
        onPressed: () => showQuickEntrySheet(context, role),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
