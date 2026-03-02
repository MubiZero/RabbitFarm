# Design Consistency Review — RabbitFarm Mobile
**Date:** 2026-03-02
**Approach:** Variant C — Full consistency pass + navigation restructure

---

## Problems Found

### 1. Hardcoded dark theme (critical)
- `LoginScreen` and `OnboardingWelcomeScreen` use `AppColors.darkBackground` as scaffold background — always dark regardless of user theme setting
- `RabbitsListScreen` uses `AppColors.darkTextPrimary`, `darkTextSecondary`, `darkTextHint`, `darkSurfaceVariant`, `darkBorder` everywhere — ignores light mode
- `CustomizableDashboardScreen` AppBar uses `AppColors.darkTextPrimary` inline

### 2. Typography tokens not used
- `RabbitsListScreen`: inline `TextStyle(fontSize: 18, fontWeight: FontWeight.bold)` instead of `AppTypography.titleMd`
- `RabbitsListScreen`: inline `TextStyle(fontSize: 14)` instead of `AppTypography.bodyMd`
- `RabbitsListScreen`: inline `TextStyle(fontSize: 11)` instead of `AppTypography.labelSm`
- `CustomizableDashboardScreen` AppBar: `TextStyle(fontSize: 24, fontWeight: bold)` and `TextStyle(fontSize: 13)`

### 3. Accent-colored SliverAppBar (design mismatch)
- `RabbitsListScreen` has `SliverAppBar(backgroundColor: primary, expandedHeight: 120)` — all other screens use the flat themed AppBar or no AppBar at all

### 4. Navigation bugs
- `/tasks` is inside `ShellRoute` but has no `NavigationDestination` → "Сегодня" tab lights up when on Tasks screen (wrong)
- Two FABs on Rabbits tab: `MainNavigationScreen` shows a FAB + `RabbitsListScreen` has its own `FloatingActionButton.extended`
- `TodayScreen` mixes `context.go()` and `context.push()` inconsistently

### 5. Code duplication
- `_showLogoutDialog()` — identical implementation in `MenuScreen` and `SettingsScreen`
- Profile card widget — duplicated in `MenuScreen` and `SettingsScreen`
- `_initials(String?)` helper method — duplicated in `MenuScreen`, `SettingsScreen`, and `MenuScreen` again

### 6. Router clutter
- `/dashboard/old` → `DashboardScreen` (dead screen, legacy)
- `/dashboard/modern` → `ModernDashboardScreen` (dead screen, legacy)
- `/matings` → duplicate alias for `/breeding/planner`
- `/reports` → duplicate alias for `/dashboard`
- `TasksListScreen` has `+` IconButton in AppBar AND MainNav provides FAB for same action

---

## Design Decisions

### Navigation restructure
**Before:** Сегодня | Кролики | Аналитика | Меню
**After:**  Сегодня | Кролики | Задачи | Меню

Rationale: Tasks are used daily; Analytics is used occasionally and already exists in Menu → Управление → Отчеты.

FAB behaviour per tab:
- Tab 0 (Сегодня): existing quick-actions modal sheet — unchanged
- Tab 1 (Кролики): existing quick-actions modal sheet — unchanged; RabbitsListScreen loses its own FAB
- Tab 2 (Задачи): FAB navigates directly to `/tasks/form`
- Tab 3 (Меню): no FAB

### Theme
All screens must use `Theme.of(context).colorScheme.*` tokens. Hardcoded `AppColors.darkXxx` values outside `app_colors.dart` and `app_theme.dart` are forbidden in screen code.

Auth and Onboarding screens: remove explicit `backgroundColor` override — the theme handles it.

### Typography
All text styles must use `AppTypography.*` constants. Inline `TextStyle(fontSize: ...)` calls in screen code are forbidden.

### Shared code
- `lib/shared/widgets/logout_dialog.dart` — `Future<void> showLogoutDialog(BuildContext, WidgetRef)`
- `lib/core/utils/string_utils.dart` — `String initials(String? name)`

### Router
- Remove routes: `/dashboard/old`, `/dashboard/modern`, `/matings`
- `/reports` → `redirect: (_, __) => '/dashboard'`
- `/more` → `redirect: (_, __) => '/menu'` (keep for safety)
- Remove `DashboardScreen` and `ModernDashboardScreen` imports from router

---

## Files to Change

| File | Change |
|------|--------|
| `features/home/screens/main_navigation_screen.dart` | Swap tab 2 to Tasks; update FAB logic |
| `features/auth/screens/login_screen.dart` | Remove hardcoded dark colors |
| `features/onboarding/screens/onboarding_welcome_screen.dart` | Remove hardcoded dark colors |
| `features/rabbits/screens/rabbits_list_screen.dart` | Full theme + typography fix; remove own FAB; simplify AppBar |
| `features/reports/screens/customizable_dashboard_screen.dart` | Fix AppBar typography and colors |
| `features/tasks/screens/tasks_list_screen.dart` | Remove `+` IconButton from AppBar |
| `features/home/screens/menu_screen.dart` | Use shared logout dialog and initials |
| `features/settings/screens/settings_screen.dart` | Use shared logout dialog and initials |
| `core/router/app_router.dart` | Clean up dead routes and aliases |

## New Files

| File | Purpose |
|------|---------|
| `lib/shared/widgets/logout_dialog.dart` | Shared logout confirmation dialog |
| `lib/core/utils/string_utils.dart` | `initials()` helper |
