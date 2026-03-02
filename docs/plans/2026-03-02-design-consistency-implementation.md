# Design Consistency — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Привести весь Flutter-UI к единому дизайн-духу: тема/типографика через токены, навигация Задачи вместо Аналитики, устранить дублирование и мусор в роутере.

**Architecture:** Каждый экран использует `Theme.of(context).colorScheme.*` и `AppTypography.*` — никаких хардкодов. Общий код вынесен в `shared/widgets/` и `core/utils/`. Навигация: 4 вкладки с Задачами как постоянным рабочим инструментом.

**Tech Stack:** Flutter 3.16+, Riverpod, GoRouter, Material 3

---

## Task 1: Создать shared-утилиты

**Files:**
- Create: `mobile/lib/core/utils/string_utils.dart`
- Create: `mobile/lib/shared/widgets/logout_dialog.dart`

**Step 1: Создать `string_utils.dart`**

```dart
// mobile/lib/core/utils/string_utils.dart

/// Returns up to 2 initials from a display name.
/// Examples: "Ivan Petrov" → "IP", "Anna" → "A", null → "?"
String initials(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return parts[0][0].toUpperCase();
}
```

**Step 2: Создать `logout_dialog.dart`**

```dart
// mobile/lib/shared/widgets/logout_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Выйти из аккаунта?'),
      content: const Text('Вы действительно хотите выйти?'),
      actions: [
        TextButton(
          onPressed: () => ctx.pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () async {
            ctx.pop();
            await ref.read(authProvider.notifier).logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: const Text('Выйти'),
        ),
      ],
    ),
  );
}
```

**Step 3: Проверить анализ**

```bash
cd mobile && flutter analyze lib/core/utils/string_utils.dart lib/shared/widgets/logout_dialog.dart
```
Ожидаем: `No issues found!`

**Step 4: Commit**

```bash
git add mobile/lib/core/utils/string_utils.dart mobile/lib/shared/widgets/logout_dialog.dart
git commit -m "feat: add shared initials() util and showLogoutDialog()"
```

---

## Task 2: Исправить LoginScreen — убрать хардкод тёмных цветов

**Files:**
- Modify: `mobile/lib/features/auth/presentation/screens/login_screen.dart`

**Контекст:** Экран всегда тёмный из-за `backgroundColor: AppColors.darkBackground`. Поля ввода использует `AppColors.darkTextPrimary` напрямую.

**Step 1: Открыть файл и внести изменения**

Найти строку `backgroundColor: AppColors.darkBackground,` в `Scaffold` — удалить её целиком.

Найти все вхождения `AppColors.darkTextPrimary` в LoginScreen — заменить на `Theme.of(context).colorScheme.onSurface`.

Найти все вхождения `AppColors.darkTextSecondary` — заменить на `Theme.of(context).colorScheme.onSurfaceVariant`.

Найти все вхождения `AppColors.darkTextHint` — заменить на `Theme.of(context).colorScheme.onSurfaceVariant`.

В блоке иконки-логотипа:
```dart
// До:
color: AppColors.accentEmerald.withValues(alpha: 0.15),
// ...
color: AppColors.accentEmerald,

// После:
color: Theme.of(context).colorScheme.primaryContainer,
// ...
color: Theme.of(context).colorScheme.primary,
```

Поле ввода (`TextFormField`):
```dart
// До:
style: AppTypography.bodyMd.copyWith(color: AppColors.darkTextPrimary),

// После: убрать style вообще — тема обрабатывает цвет текста
```

**Step 2: Проверить**

```bash
cd mobile && flutter analyze lib/features/auth/presentation/screens/login_screen.dart
```
Ожидаем: `No issues found!`

**Step 3: Commit**

```bash
git add mobile/lib/features/auth/presentation/screens/login_screen.dart
git commit -m "fix: LoginScreen uses theme tokens instead of hardcoded dark colors"
```

---

## Task 3: Исправить OnboardingWelcomeScreen

**Files:**
- Modify: `mobile/lib/features/onboarding/presentation/screens/onboarding_welcome_screen.dart`

**Step 1: Внести изменения**

Удалить строку `backgroundColor: AppColors.darkBackground,` из `Scaffold`.

Заменить:
```dart
// До:
color: AppColors.accentEmerald.withValues(alpha: 0.1),
// icon color:
color: AppColors.accentEmerald,
// Text color:
color: AppColors.darkTextPrimary,
color: AppColors.darkTextSecondary,

// После:
color: Theme.of(context).colorScheme.primaryContainer,
color: Theme.of(context).colorScheme.primary,
color: Theme.of(context).colorScheme.onSurface,
color: Theme.of(context).colorScheme.onSurfaceVariant,
```

Кнопка "Уже есть аккаунт?":
```dart
// До:
color: AppColors.darkTextSecondary,

// После: убрать — TextButton цвет берёт из темы
```

**Step 2: Проверить**

```bash
cd mobile && flutter analyze lib/features/onboarding/presentation/screens/onboarding_welcome_screen.dart
```
Ожидаем: `No issues found!`

**Step 3: Commit**

```bash
git add mobile/lib/features/onboarding/presentation/screens/onboarding_welcome_screen.dart
git commit -m "fix: OnboardingWelcomeScreen uses theme tokens"
```

---

## Task 4: Рефакторинг RabbitsListScreen — тема, типографика, AppBar

**Files:**
- Modify: `mobile/lib/features/rabbits/presentation/screens/rabbits_list_screen.dart`

Это самый объёмный файл. Делаем последовательно.

**Step 1: Заменить SliverAppBar на AppBar с bottom-поиском**

Удалить метод `_buildSliverAppBar(Color primary)` целиком.

Изменить `Scaffold`:
```dart
// До: Scaffold(body: CustomScrollView(slivers: [_buildSliverAppBar(primary), ...]))

// После:
return Scaffold(
  appBar: AppBar(
    title: const Text('Мои Кролики'),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: _buildSearchField(context),
      ),
    ),
  ),
  body: CustomScrollView(
    controller: _scrollController,
    slivers: [
      _buildFilters(),
      // ... остальные slivers без изменений
    ],
  ),
  // FAB убираем полностью (MainNavigationScreen обеспечивает FAB)
);
```

**Step 2: Создать `_buildSearchField`**

```dart
Widget _buildSearchField(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    height: 44,
    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: 'Поиск по имени или клейму...',
        hintStyle: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),
        prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: cs.onSurfaceVariant),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              )
            : null,
      ),
    ),
  );
}
```

**Step 3: Обновить `_buildFilters` — убрать параметр `primary`**

```dart
// До: Widget _buildFilters(Color primary) {
// После:
Widget _buildFilters() {
  final primary = Theme.of(context).colorScheme.primary;
  // остальной код без изменений, но убрать AppColors.darkTextSecondary и AppColors.darkBorder:
  // labelStyle: TextStyle(color: ...) → AppColors.darkTextSecondary → cs.onSurfaceVariant
  // side: BorderSide(color: isSelected ? primary : AppColors.darkBorder)
  //   → BorderSide(color: isSelected ? primary : cs.outline)
```

Полный `_buildFilterChip`:
```dart
Widget _buildFilterChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final cs = Theme.of(context).colorScheme;
  return FilterChip(
    label: Text(label),
    selected: isSelected,
    onSelected: (_) => onTap(),
    backgroundColor: cs.surface,
    selectedColor: cs.primary.withValues(alpha: 0.2),
    checkmarkColor: cs.primary,
    labelStyle: AppTypography.labelSm.copyWith(
      color: isSelected ? cs.primary : cs.onSurfaceVariant,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: isSelected ? cs.primary : cs.outline),
    ),
  );
}
```

В `_buildFilters()` убрать передачу `primary` в чипы — теперь `_buildFilterChip` сам берёт его из темы.

**Step 4: Исправить `_buildRabbitCard` — типографика и цвета**

```dart
Widget _buildRabbitCard(RabbitModel rabbit) {
  final cs = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: AppCard(
      onTap: () => context.push('/rabbits/${rabbit.id}'),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Hero(
            tag: 'rabbit_photo_${rabbit.id}',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: cs.surfaceContainerHighest,          // было: AppColors.darkSurfaceVariant
                image: rabbit.photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(rabbit.photoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: rabbit.photoUrl == null
                  ? Icon(Icons.pets, size: 40, color: cs.onSurfaceVariant)  // было: AppColors.darkTextHint
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        rabbit.name,
                        style: AppTypography.titleMd.copyWith(color: cs.onSurface),  // было: inline TextStyle
                      ),
                    ),
                    StatusBadge(status: RabbitStatusX.fromString(rabbit.status)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Клеймо: ${rabbit.tagId.isEmpty ? "Нет" : rabbit.tagId}',
                  style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),  // было: inline TextStyle
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoBadge(
                      icon: rabbit.sex == 'male' ? Icons.male : Icons.female,
                      label: rabbit.sex == 'male' ? 'Самец' : 'Самка',
                      color: rabbit.sex == 'male'
                          ? AppColors.accentOcean
                          : AppColors.accentRose,
                    ),
                    if (rabbit.breed?.name != null) ...[
                      const SizedBox(width: 8),
                      _buildInfoBadge(
                        icon: Icons.category,
                        label: rabbit.breed!.name,
                        color: AppColors.accentViolet,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: cs.onSurfaceVariant),  // было: AppColors.darkTextHint
        ],
      ),
    ),
  );
}
```

`_buildInfoBadge` — типографика:
```dart
// В Text() внутри _buildInfoBadge:
// До: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)
// После:
style: AppTypography.labelSm.copyWith(color: color),
```

**Step 5: Убрать FloatingActionButton из Scaffold**

В `build()` удалить:
```dart
floatingActionButton: FloatingActionButton.extended(
  onPressed: () => context.push('/rabbits/new'),
  icon: const Icon(Icons.add),
  label: const Text('Добавить'),
),
```

**Step 6: Убрать импорт `primary` из `build()`**

```dart
// До:
final primary = Theme.of(context).colorScheme.primary;
// Вызовы: _buildSliverAppBar(primary), _buildFilters(primary)

// После:
// Переменная primary не нужна — убрать
// Вызовы: _buildFilters() (без аргументов)
```

**Step 7: Проверить**

```bash
cd mobile && flutter analyze lib/features/rabbits/presentation/screens/rabbits_list_screen.dart
```
Ожидаем: `No issues found!`

**Step 8: Commit**

```bash
git add mobile/lib/features/rabbits/presentation/screens/rabbits_list_screen.dart
git commit -m "fix: RabbitsListScreen uses theme tokens, AppTypography, flat AppBar, no own FAB"
```

---

## Task 5: Исправить CustomizableDashboardScreen AppBar

**Files:**
- Modify: `mobile/lib/features/reports/presentation/screens/customizable_dashboard_screen.dart`

**Step 1: Найти метод `_buildAppBar` и обновить**

```dart
Widget _buildAppBar(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;
  return SliverAppBar(
    expandedHeight: 120,
    floating: false,
    pinned: true,
    elevation: 0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // было: Colors.transparent
    flexibleSpace: FlexibleSpaceBar(
      titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RabbitFarm',
            style: AppTypography.displayMd.copyWith(color: cs.onSurface),  // было: inline TextStyle + AppColors.darkTextPrimary
          ),
          Text(
            'Управление фермой',
            style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),  // было: inline TextStyle + AppColors.darkTextSecondary
          ),
        ],
      ),
    ),
    // ... actions без изменений
  );
}
```

Добавить импорт `AppTypography` если его нет:
```dart
import '../../../../core/theme/app_typography.dart';
```

**Step 2: Проверить**

```bash
cd mobile && flutter analyze lib/features/reports/presentation/screens/customizable_dashboard_screen.dart
```
Ожидаем: `No issues found!`

**Step 3: Commit**

```bash
git add mobile/lib/features/reports/presentation/screens/customizable_dashboard_screen.dart
git commit -m "fix: CustomizableDashboardScreen AppBar uses theme tokens and AppTypography"
```

---

## Task 6: Убрать дубль `+` из TasksListScreen

**Files:**
- Modify: `mobile/lib/features/tasks/presentation/screens/tasks_list_screen.dart`

**Step 1: Найти и удалить `+` в actions**

```dart
// До:
actions: [
  IconButton(
    icon: const Icon(Icons.filter_list),
    onPressed: _showFilters,
  ),
  IconButton(
    icon: const Icon(Icons.add),
    onPressed: () => context.push('/tasks/form'),
  ),
],

// После:
actions: [
  IconButton(
    icon: const Icon(Icons.filter_list),
    onPressed: _showFilters,
  ),
],
```

**Step 2: Проверить**

```bash
cd mobile && flutter analyze lib/features/tasks/presentation/screens/tasks_list_screen.dart
```

**Step 3: Commit**

```bash
git add mobile/lib/features/tasks/presentation/screens/tasks_list_screen.dart
git commit -m "fix: remove duplicate + button from TasksListScreen (MainNav FAB handles it)"
```

---

## Task 7: Обновить MainNavigationScreen — Задачи вместо Аналитики

**Files:**
- Modify: `mobile/lib/features/home/presentation/screens/main_navigation_screen.dart`

**Step 1: Обновить `destinations` в `NavigationBar`**

```dart
// До:
destinations: const [
  NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Сегодня'),
  NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Кролики'),
  NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Аналитика'),
  NavigationDestination(icon: Icon(Icons.menu), selectedIcon: Icon(Icons.menu_open), label: 'Меню'),
],

// После:
destinations: const [
  NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Сегодня'),
  NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Кролики'),
  NavigationDestination(icon: Icon(Icons.check_box_outline_blank), selectedIcon: Icon(Icons.check_box), label: 'Задачи'),
  NavigationDestination(icon: Icon(Icons.menu), selectedIcon: Icon(Icons.menu_open), label: 'Меню'),
],
```

**Step 2: Обновить `_calculateSelectedIndex`**

```dart
int _calculateSelectedIndex(String path) {
  if (path.startsWith('/today')) return 0;
  if (path.startsWith('/rabbits')) return 1;
  if (path.startsWith('/tasks')) return 2;        // было: /dashboard → 2
  if (path.startsWith('/menu') || path.startsWith('/more')) return 3;
  return 0;
}
```

**Step 3: Обновить `_onItemTapped`**

```dart
void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0: context.go('/today');
    case 1: context.go('/rabbits');
    case 2: context.go('/tasks');      // было: /dashboard
    case 3: context.go('/menu');
  }
}
```

**Step 4: Обновить `_buildFab` — добавить case для Tasks**

```dart
Widget? _buildFab(BuildContext context, int currentIndex) {
  switch (currentIndex) {
    case 0:
    case 1:
      // Existing quick-actions modal
      return FloatingActionButton(
        onPressed: () => _showQuickActions(context, currentIndex),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      );
    case 2:
      // Tasks: direct navigation
      return FloatingActionButton(
        onPressed: () => context.push('/tasks/form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      );
    default:
      return null;
  }
}
```

Изменить старый `if (currentIndex != 0 && currentIndex != 1) return null;` на switch выше.

**Step 5: Проверить**

```bash
cd mobile && flutter analyze lib/features/home/presentation/screens/main_navigation_screen.dart
```
Ожидаем: `No issues found!`

**Step 6: Commit**

```bash
git add mobile/lib/features/home/presentation/screens/main_navigation_screen.dart
git commit -m "feat: swap Analytics tab to Tasks tab in bottom nav; FAB works on all 3 tabs"
```

---

## Task 8: MenuScreen и SettingsScreen — использовать shared-утилиты

**Files:**
- Modify: `mobile/lib/features/home/presentation/screens/menu_screen.dart`
- Modify: `mobile/lib/features/settings/presentation/screens/settings_screen.dart`

**Step 1: Обновить MenuScreen**

Добавить импорты:
```dart
import '../../../../core/utils/string_utils.dart';
import '../../../../shared/widgets/logout_dialog.dart';
```

Удалить метод `_initials(String? name)` из `MenuScreen`.

Заменить `_initials(user?.fullName)` → `initials(user?.fullName)`.

Заменить метод `_showLogoutDialog`:
```dart
// До: void _showLogoutDialog(BuildContext context, WidgetRef ref) { showDialog(...) }
// После: убрать метод полностью

// Вызов:
// До: onTap: () => _showLogoutDialog(context, ref),
// После: onTap: () => showLogoutDialog(context, ref),
```

**Step 2: Обновить SettingsScreen**

Добавить импорты:
```dart
import '../../../../core/utils/string_utils.dart';
import '../../../../shared/widgets/logout_dialog.dart';
```

Удалить метод `_showLogoutDialog` из `SettingsScreen`.

В `_ProfileCard` удалить метод `_initials(String n)` — заменить вызов:
```dart
// До: final initials = _initials(displayName);
// После: final displayInitials = initials(displayName);
// И использовать displayInitials в Text()
```

Заменить вызов logout:
```dart
// До: onPressed: () => _showLogoutDialog(context, ref),
// После: onPressed: () => showLogoutDialog(context, ref),
```

**Step 3: Проверить**

```bash
cd mobile && flutter analyze lib/features/home/presentation/screens/menu_screen.dart lib/features/settings/presentation/screens/settings_screen.dart
```
Ожидаем: `No issues found!`

**Step 4: Commit**

```bash
git add mobile/lib/features/home/presentation/screens/menu_screen.dart \
        mobile/lib/features/settings/presentation/screens/settings_screen.dart
git commit -m "refactor: MenuScreen and SettingsScreen use shared initials() and showLogoutDialog()"
```

---

## Task 9: Чистка роутера

**Files:**
- Modify: `mobile/lib/core/router/app_router.dart`

**Step 1: Удалить импорты мёртвых экранов**

Найти и удалить строки:
```dart
import '../../features/reports/presentation/screens/dashboard_screen.dart';
import '../../features/reports/presentation/screens/modern_dashboard_screen.dart';
```

**Step 2: Удалить мёртвые маршруты**

Удалить полностью блоки:
```dart
// Удалить:
GoRoute(
  path: '/dashboard/modern',
  name: 'dashboard-modern',
  builder: (context, state) => const ModernDashboardScreen(),
),

GoRoute(
  path: '/dashboard/old',
  name: 'dashboard-old',
  builder: (context, state) => const DashboardScreen(),
),

GoRoute(
  path: '/matings',
  name: 'matings',
  builder: (context, state) => const BreedingPlannerScreen(),
),
```

**Step 3: Заменить `/reports` на redirect**

```dart
// До:
GoRoute(
  path: '/reports',
  name: 'reports',
  builder: (context, state) => const CustomizableDashboardScreen(),
),

// После:
GoRoute(
  path: '/reports',
  name: 'reports',
  redirect: (_, __) => '/dashboard',
),
```

**Step 4: Убедиться что `/tasks` в ShellRoute**

Проверить, что маршрут `/tasks` остаётся внутри `ShellRoute` (он туда уже добавлен в существующем роутере).

**Step 5: Проверить**

```bash
cd mobile && flutter analyze lib/core/router/app_router.dart
```
Ожидаем: `No issues found!`

**Step 6: Финальная проверка всего проекта**

```bash
cd mobile && flutter analyze
```
Ожидаем: `No issues found!`

**Step 7: Commit**

```bash
git add mobile/lib/core/router/app_router.dart
git commit -m "chore: remove dead routes (old/modern dashboard, matings); /reports → redirect"
```

---

## Финальная верификация

```bash
cd mobile && flutter analyze
```
Ожидаем: `No issues found!`

Проверить вручную:
- [ ] Login экран в светлой теме выглядит светлым
- [ ] Onboarding в светлой теме выглядит светлым
- [ ] Вкладка "Кролики" — один FAB (MainNav), без дублирования
- [ ] Вкладка "Задачи" — FAB ведёт на форму создания задачи
- [ ] На экране Задач подсвечивается 3-я вкладка (не 1-я)
- [ ] Меню и Настройки: диалог выхода одинаковый
- [ ] RabbitsListScreen AppBar плоский, соответствует остальным
