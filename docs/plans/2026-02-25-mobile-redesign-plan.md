# RabbitFarm Mobile — Total Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Full redesign of the Flutter mobile app — Design System Dark, onboarding, product tour, 4-tab navigation, accent color customization, Settings/Profile screen.

**Architecture:** Token-based design system (AppColors, AppTypography, AppRadius) + ThemeProvider (Riverpod) for dark/light/accent. Onboarding stored in SharedPreferences. Product tour via CoachMark overlay system. Navigation refactored to 4 tabs.

**Tech Stack:** Flutter 3.x, Riverpod 2, GoRouter 12, SharedPreferences, Material3

**Design Doc:** `docs/plans/2026-02-25-mobile-redesign-design.md`

---

## Phase 1: Design System Foundation

### Task 1: Add Inter font to project

**Files:**
- Modify: `mobile/pubspec.yaml`
- Download: Inter font files to `mobile/fonts/`

**Step 1: Download Inter font**
```bash
cd mobile
mkdir -p fonts
curl -L "https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip" -o /tmp/inter.zip
unzip /tmp/inter.zip -d /tmp/inter
cp /tmp/inter/Inter\ Desktop/Inter-Regular.otf fonts/
cp /tmp/inter/Inter\ Desktop/Inter-Medium.otf fonts/
cp /tmp/inter/Inter\ Desktop/Inter-SemiBold.otf fonts/
cp /tmp/inter/Inter\ Desktop/Inter-Bold.otf fonts/
```

**Step 2: Register font in pubspec.yaml**

Add after `uses-material-design: true`:
```yaml
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/Inter-Regular.otf
        - asset: fonts/Inter-Medium.otf
          weight: 500
        - asset: fonts/Inter-SemiBold.otf
          weight: 600
        - asset: fonts/Inter-Bold.otf
          weight: 700
```

**Step 3: Verify**
```bash
cd mobile && flutter pub get
```
Expected: no errors.

**Step 4: Commit**
```bash
git add mobile/pubspec.yaml mobile/fonts/
git commit -m "feat(design): add Inter font family"
```

---

### Task 2: Create AppColors token file

**Files:**
- Create: `mobile/lib/core/theme/app_colors.dart`
- Delete content of: `mobile/lib/core/theme/app_theme.dart` (will be rebuilt in Task 5)

**Step 1: Create `app_colors.dart`**
```dart
import 'package:flutter/material.dart';

/// Design token: color primitives and semantic aliases.
/// All UI code must use these tokens, never hardcode hex values.
abstract class AppColors {
  // === DARK MODE TOKENS ===
  static const darkBackground     = Color(0xFF0A0D14);
  static const darkSurface        = Color(0xFF131720);
  static const darkSurfaceVariant = Color(0xFF1C2130);
  static const darkBorder         = Color(0xFF2A3142);
  static const darkTextPrimary    = Color(0xFFF0F4FF);
  static const darkTextSecondary  = Color(0xFF8B95B0);
  static const darkTextHint       = Color(0xFF4A5168);

  // === LIGHT MODE TOKENS ===
  static const lightBackground     = Color(0xFFF4F6FB);
  static const lightSurface        = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFEEF0F6);
  static const lightBorder         = Color(0xFFE0E4EE);
  static const lightTextPrimary    = Color(0xFF0F172A);
  static const lightTextSecondary  = Color(0xFF64748B);
  static const lightTextHint       = Color(0xFF94A3B8);

  // === ACCENT COLORS (user selects one) ===
  static const accentEmerald = Color(0xFF10B981);
  static const accentOcean   = Color(0xFF3B82F6);
  static const accentSunset  = Color(0xFFF59E0B);
  static const accentRose    = Color(0xFFEC4899);
  static const accentViolet  = Color(0xFF8B5CF6);

  static const List<Color> accentOptions = [
    accentEmerald,
    accentOcean,
    accentSunset,
    accentRose,
    accentViolet,
  ];

  static const List<String> accentNames = [
    'Emerald',
    'Ocean',
    'Sunset',
    'Rose',
    'Violet',
  ];

  // === SEMANTIC COLORS (same in both modes) ===
  static const error   = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const info    = Color(0xFF3B82F6);

  // === CHART COLORS ===
  static const List<Color> chart = [
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];
}
```

**Step 2: Verify file is valid Dart**
```bash
cd mobile && dart analyze lib/core/theme/app_colors.dart
```
Expected: no issues.

**Step 3: Commit**
```bash
git add mobile/lib/core/theme/app_colors.dart
git commit -m "feat(design): add AppColors token file"
```

---

### Task 3: Create AppTypography token file

**Files:**
- Create: `mobile/lib/core/theme/app_typography.dart`

**Step 1: Create `app_typography.dart`**
```dart
import 'package:flutter/material.dart';

/// Design token: text styles.
/// Always use these — never inline fontSize/fontWeight.
abstract class AppTypography {
  static const String _font = 'Inter';

  static const displayLg = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const displayMd = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const titleLg = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const titleMd = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const bodyLg = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodyMd = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const labelLg = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const labelSm = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );
}
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/theme/app_typography.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/theme/app_typography.dart
git commit -m "feat(design): add AppTypography token file"
```

---

### Task 4: Create AppRadius token file

**Files:**
- Create: `mobile/lib/core/theme/app_radius.dart`

**Step 1: Create `app_radius.dart`**
```dart
import 'package:flutter/material.dart';

/// Design token: border radius values.
abstract class AppRadius {
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double full = 999;

  static const sm_  = BorderRadius.all(Radius.circular(sm));
  static const md_  = BorderRadius.all(Radius.circular(md));
  static const lg_  = BorderRadius.all(Radius.circular(lg));
  static const xl_  = BorderRadius.all(Radius.circular(xl));
  static const full_ = BorderRadius.all(Radius.circular(full));
}
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/theme/app_radius.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/theme/app_radius.dart
git commit -m "feat(design): add AppRadius token file"
```

---

### Task 5: Rewrite AppTheme with dark/light + accent support

**Files:**
- Modify: `mobile/lib/core/theme/app_theme.dart`

**Step 1: Replace entire content of `app_theme.dart`**

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

class AppTheme {
  /// Build a ThemeData for the given brightness and accent color.
  static ThemeData build({
    required Brightness brightness,
    required Color accent,
  }) {
    final isDark = brightness == Brightness.dark;

    final bg     = isDark ? AppColors.darkBackground     : AppColors.lightBackground;
    final surface= isDark ? AppColors.darkSurface        : AppColors.lightSurface;
    final surfaceVar = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final border = isDark ? AppColors.darkBorder         : AppColors.lightBorder;
    final txtPri = isDark ? AppColors.darkTextPrimary    : AppColors.lightTextPrimary;
    final txtSec = isDark ? AppColors.darkTextSecondary  : AppColors.lightTextSecondary;
    final txtHint= isDark ? AppColors.darkTextHint       : AppColors.lightTextHint;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      primaryContainer: accent.withOpacity(0.15),
      onPrimaryContainer: accent,
      secondary: accent,
      onSecondary: Colors.white,
      secondaryContainer: accent.withOpacity(0.1),
      onSecondaryContainer: accent,
      error: AppColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: txtPri,
      onSurfaceVariant: txtSec,
      outline: border,
      outlineVariant: border.withOpacity(0.5),
      shadow: Colors.black,
      scrim: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter',

      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: txtPri,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLg.copyWith(color: txtPri),
        iconTheme: IconThemeData(color: txtPri),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lg_,
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVar,
        border: OutlineInputBorder(
          borderRadius: AppRadius.md_,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.md_,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.md_,
          borderSide: BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.md_,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.md_,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.bodyMd.copyWith(color: txtSec),
        hintStyle: AppTypography.bodyMd.copyWith(color: txtHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
          elevation: 0,
          textStyle: AppTypography.labelLg,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
          textStyle: AppTypography.labelLg,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: AppTypography.labelLg,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: txtSec,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSm,
        unselectedLabelStyle: AppTypography.labelSm,
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      textTheme: TextTheme(
        displayLarge:  AppTypography.displayLg.copyWith(color: txtPri),
        displayMedium: AppTypography.displayMd.copyWith(color: txtPri),
        displaySmall:  AppTypography.titleLg.copyWith(color: txtPri),
        headlineMedium:AppTypography.titleLg.copyWith(color: txtPri),
        titleLarge:    AppTypography.titleMd.copyWith(color: txtPri),
        titleMedium:   AppTypography.titleMd.copyWith(color: txtPri),
        bodyLarge:     AppTypography.bodyLg.copyWith(color: txtPri),
        bodyMedium:    AppTypography.bodyMd.copyWith(color: txtPri),
        labelLarge:    AppTypography.labelLg.copyWith(color: txtPri),
        labelSmall:    AppTypography.labelSm.copyWith(color: txtSec),
      ),
    );
  }

  // Convenience shortcuts for common color lookups via BuildContext.
  static Color bg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color surfaceVar(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer;
  static Color border(BuildContext context) =>
      Theme.of(context).colorScheme.outline;
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
}
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/theme/app_theme.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/theme/app_theme.dart
git commit -m "feat(design): rewrite AppTheme with dark/light + accent support"
```

---

### Task 6: Create ThemeProvider (Riverpod)

**Files:**
- Create: `mobile/lib/core/providers/theme_provider.dart`

**Step 1: Add `riverpod_annotation` import and create provider**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

// Keys for SharedPreferences
const _kThemeMode = 'theme_mode'; // 'dark' | 'light' | 'system'
const _kAccentIndex = 'accent_index'; // 0-4

class ThemeState {
  final ThemeMode mode;
  final int accentIndex;

  const ThemeState({
    this.mode = ThemeMode.dark,
    this.accentIndex = 0,
  });

  Color get accent => AppColors.accentOptions[accentIndex];

  ThemeState copyWith({ThemeMode? mode, int? accentIndex}) => ThemeState(
        mode: mode ?? this.mode,
        accentIndex: accentIndex ?? this.accentIndex,
      );
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    _loadFromPrefs();
    return const ThemeState();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_kThemeMode) ?? 'dark';
    final accentIdx = prefs.getInt(_kAccentIndex) ?? 0;

    final mode = switch (modeStr) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };

    state = ThemeState(mode: mode, accentIndex: accentIdx);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = state.copyWith(mode: mode);
    final prefs = await SharedPreferences.getInstance();
    final str = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      _ => 'dark',
    };
    await prefs.setString(_kThemeMode, str);
  }

  Future<void> setAccent(int index) async {
    assert(index >= 0 && index < AppColors.accentOptions.length);
    state = state.copyWith(accentIndex: index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kAccentIndex, index);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

/// Convenience provider — gives you the MaterialApp theme config.
final lightThemeProvider = Provider<ThemeData>((ref) {
  final accent = ref.watch(themeProvider).accent;
  return AppTheme.build(brightness: Brightness.light, accent: accent);
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final accent = ref.watch(themeProvider).accent;
  return AppTheme.build(brightness: Brightness.dark, accent: accent);
});
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/providers/theme_provider.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/providers/theme_provider.dart
git commit -m "feat(design): add ThemeProvider with dark/light + accent persistence"
```

---

### Task 7: Wire ThemeProvider into MaterialApp

**Files:**
- Modify: `mobile/lib/main.dart`

**Step 1: Read current main.dart first**, then update `MaterialApp.router` to use theme providers:

Find the `MaterialApp.router(...)` call and update:
```dart
// Add imports at top:
import 'core/providers/theme_provider.dart';

// In your ConsumerWidget build:
final themeState = ref.watch(themeProvider);
final darkTheme  = ref.watch(darkThemeProvider);
final lightTheme = ref.watch(lightThemeProvider);

// MaterialApp.router:
return MaterialApp.router(
  title: 'RabbitFarm',
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: themeState.mode,
  routerConfig: ref.watch(routerProvider),
  // ... rest unchanged
);
```

**Step 2: Run app and verify it starts in dark mode**
```bash
cd mobile && flutter run
```
Expected: app launches with dark background `#0A0D14`.

**Step 3: Commit**
```bash
git add mobile/lib/main.dart
git commit -m "feat(design): wire ThemeProvider into MaterialApp"
```

---

## Phase 2: Core Reusable Widgets

### Task 8: Create AppCard widget

**Files:**
- Create: `mobile/lib/core/widgets/app_card.dart`

**Step 1: Create widget**
```dart
import 'package:flutter/material.dart';

enum AppCardVariant { default_, highlighted, error }

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final Color? borderColor; // override

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.variant = AppCardVariant.default_,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final surface = scheme.surface;
    final effectiveBorder = borderColor ??
        switch (variant) {
          AppCardVariant.highlighted => scheme.primary,
          AppCardVariant.error => scheme.error,
          AppCardVariant.default_ => scheme.outline,
        };

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: effectiveBorder, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/widgets/app_card.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/widgets/app_card.dart
git commit -m "feat(widgets): add AppCard component"
```

---

### Task 9: Create StatusBadge widget

**Files:**
- Create: `mobile/lib/core/widgets/status_badge.dart`

**Step 1: Create widget**
```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum RabbitStatus { active, inactive, sick, pregnant, sold }

class StatusBadge extends StatelessWidget {
  final RabbitStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      RabbitStatus.active   => ('Активен',   AppColors.success),
      RabbitStatus.inactive => ('Неактивен', AppColors.darkTextSecondary),
      RabbitStatus.sick     => ('Болен',     AppColors.error),
      RabbitStatus.pregnant => ('Беременна', AppColors.accentRose),
      RabbitStatus.sold     => ('Продан',    AppColors.warning),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/widgets/status_badge.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/widgets/status_badge.dart
git commit -m "feat(widgets): add StatusBadge component"
```

---

### Task 10: Create AlertCard widget

**Files:**
- Create: `mobile/lib/core/widgets/alert_card.dart`

**Step 1: Create widget**
```dart
import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

class AlertCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final outline = Theme.of(context).colorScheme.outline;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 4)),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTypography.titleMd.copyWith(color: color)),
                    const SizedBox(height: 2),
                    Text(description,
                        style: AppTypography.bodyMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/core/widgets/alert_card.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/core/widgets/alert_card.dart
git commit -m "feat(widgets): add AlertCard component"
```

---

## Phase 3: Onboarding

### Task 11: Create OnboardingProvider

**Files:**
- Create: `mobile/lib/features/onboarding/presentation/providers/onboarding_provider.dart`

**Step 1: Create provider**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingDone = 'onboarding_done';
const _kFarmName       = 'farm_name';
const _kFarmType       = 'farm_type'; // 'solo' | 'team'
const _kTourDone       = 'tour_done';

class OnboardingState {
  final bool isDone;
  final String farmName;
  final String farmType; // 'solo' | 'team'
  final bool tourDone;

  const OnboardingState({
    this.isDone   = false,
    this.farmName = '',
    this.farmType = 'solo',
    this.tourDone = false,
  });

  OnboardingState copyWith({
    bool? isDone,
    String? farmName,
    String? farmType,
    bool? tourDone,
  }) =>
      OnboardingState(
        isDone:    isDone    ?? this.isDone,
        farmName:  farmName  ?? this.farmName,
        farmType:  farmType  ?? this.farmType,
        tourDone:  tourDone  ?? this.tourDone,
      );
}

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return OnboardingState(
      isDone:   prefs.getBool(_kOnboardingDone) ?? false,
      farmName: prefs.getString(_kFarmName) ?? '',
      farmType: prefs.getString(_kFarmType) ?? 'solo',
      tourDone: prefs.getBool(_kTourDone) ?? false,
    );
  }

  Future<void> saveFarmName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFarmName, name);
    state = AsyncData(state.value!.copyWith(farmName: name));
  }

  Future<void> saveFarmType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFarmType, type);
    state = AsyncData(state.value!.copyWith(farmType: type));
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDone, true);
    state = AsyncData(state.value!.copyWith(isDone: true));
  }

  Future<void> completeTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourDone, true);
    state = AsyncData(state.value!.copyWith(tourDone: true));
  }
}

final onboardingProvider =
    AsyncNotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
```

**Step 2: Verify**
```bash
cd mobile && dart analyze lib/features/onboarding/presentation/providers/onboarding_provider.dart
```

**Step 3: Commit**
```bash
git add mobile/lib/features/onboarding/
git commit -m "feat(onboarding): add OnboardingProvider"
```

---

### Task 12: Create SplashScreen

**Files:**
- Create: `mobile/lib/features/onboarding/presentation/screens/splash_screen.dart`

**Step 1: Create screen**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final authState   = ref.read(authProvider);
    final onboarding  = await ref.read(onboardingProvider.future);

    if (!mounted) return;

    if (authState.isAuthenticated) {
      context.go('/today');
    } else if (!onboarding.isDone) {
      context.go('/onboarding');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo placeholder — replace with SVG/Lottie later
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets,
                  size: 40,
                  color: AppColors.accentEmerald,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RabbitFarm',
                style: AppTypography.displayMd.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Управление фермой',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Add `/splash` route to `app_router.dart`** (add before existing routes):
```dart
GoRoute(
  path: '/splash',
  name: 'splash',
  builder: (context, state) => const SplashScreen(),
),
```
Also change `initialLocation: '/login'` → `initialLocation: '/splash'`

**Step 3: Verify**
```bash
cd mobile && dart analyze lib/features/onboarding/presentation/screens/splash_screen.dart
```

**Step 4: Commit**
```bash
git add mobile/lib/features/onboarding/ mobile/lib/core/router/app_router.dart
git commit -m "feat(onboarding): add SplashScreen with auth redirect"
```

---

### Task 13: Create Onboarding Welcome screen

**Files:**
- Create: `mobile/lib/features/onboarding/presentation/screens/onboarding_welcome_screen.dart`

**Step 1: Create screen**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // Illustration placeholder
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.accentEmerald.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    size: 80,
                    color: AppColors.accentEmerald,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Управляйте фермой умно',
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Кролики, кормление, здоровье\nи финансы — всё в одном месте',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => context.go('/onboarding/farm-name'),
                child: const Text('Начать'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Уже есть аккаунт? Войти',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Add routes to `app_router.dart`**:
```dart
GoRoute(
  path: '/onboarding',
  name: 'onboarding',
  builder: (context, state) => const OnboardingWelcomeScreen(),
),
```

**Step 3: Verify + Commit**
```bash
cd mobile && dart analyze lib/features/onboarding/
git add mobile/lib/features/onboarding/ mobile/lib/core/router/app_router.dart
git commit -m "feat(onboarding): add Welcome screen"
```

---

### Task 14: Create Onboarding FarmName + FarmType screens

**Files:**
- Create: `mobile/lib/features/onboarding/presentation/screens/onboarding_farm_name_screen.dart`
- Create: `mobile/lib/features/onboarding/presentation/screens/onboarding_farm_type_screen.dart`
- Create: `mobile/lib/features/onboarding/presentation/screens/onboarding_ready_screen.dart`
- Create: `mobile/lib/features/onboarding/presentation/widgets/onboarding_progress.dart`

**Step 1: Progress indicator widget**
```dart
// onboarding_progress.dart
import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int current; // 1-based
  final int total;

  const OnboardingProgress({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).colorScheme.outline;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? accent : inactive,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
```

**Step 2: FarmName screen**
```dart
// onboarding_farm_name_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingFarmNameScreen extends ConsumerStatefulWidget {
  const OnboardingFarmNameScreen({super.key});

  @override
  ConsumerState<OnboardingFarmNameScreen> createState() =>
      _OnboardingFarmNameScreenState();
}

class _OnboardingFarmNameScreenState
    extends ConsumerState<OnboardingFarmNameScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const OnboardingProgress(current: 1, total: 2),
              const Spacer(flex: 2),
              Text(
                'Как называется\nваша ферма?',
                style: AppTypography.displayMd.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _ctrl,
                autofocus: true,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: 'Например: Ферма "Берёзки"',
                ),
                onSubmitted: (_) => _next(),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: _next,
                child: const Text('Далее'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/onboarding/farm-type'),
                child: Text(
                  'Пропустить',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _next() async {
    if (_ctrl.text.isNotEmpty) {
      await ref.read(onboardingProvider.notifier).saveFarmName(_ctrl.text.trim());
    }
    if (mounted) context.go('/onboarding/farm-type');
  }
}
```

**Step 3: FarmType screen**
```dart
// onboarding_farm_type_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingFarmTypeScreen extends ConsumerStatefulWidget {
  const OnboardingFarmTypeScreen({super.key});

  @override
  ConsumerState<OnboardingFarmTypeScreen> createState() =>
      _OnboardingFarmTypeScreenState();
}

class _OnboardingFarmTypeScreenState
    extends ConsumerState<OnboardingFarmTypeScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const OnboardingProgress(current: 2, total: 2),
              const Spacer(flex: 2),
              Text(
                'Как вы управляете\nфермой?',
                style: AppTypography.displayMd.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 32),
              _TypeCard(
                icon: Icons.person,
                title: 'Один хозяин',
                subtitle: 'Я управляю фермой самостоятельно',
                selected: _selected == 'solo',
                onTap: () => setState(() => _selected = 'solo'),
              ),
              const SizedBox(height: 12),
              _TypeCard(
                icon: Icons.group,
                title: 'Команда',
                subtitle: 'У меня есть сотрудники с разными ролями',
                selected: _selected == 'team',
                onTap: () => setState(() => _selected = 'team'),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: _selected != null ? _next : null,
                child: const Text('Далее'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/onboarding/ready'),
                child: Text(
                  'Пропустить',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _next() async {
    await ref.read(onboardingProvider.notifier).saveFarmType(_selected!);
    if (mounted) context.go('/onboarding/ready');
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final border = selected ? accent : Theme.of(context).colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(0.08) : surface,
          border: Border.all(color: border, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (selected ? accent : AppColors.darkTextSecondary)
                    .withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: selected ? accent : AppColors.darkTextSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.titleMd.copyWith(
                        color: selected
                            ? accent
                            : AppColors.darkTextPrimary,
                      )),
                  Text(subtitle,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.darkTextSecondary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 4: Ready screen**
```dart
// onboarding_ready_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingReadyScreen extends ConsumerWidget {
  const OnboardingReadyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider).valueOrNull;
    final farmName = onboarding?.farmName.isNotEmpty == true
        ? onboarding!.farmName
        : 'ваша ферма';

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.accentEmerald.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 56,
                    color: AppColors.accentEmerald,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '"$farmName"\nготова к работе!',
                style: AppTypography.displayMd.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Настроим остальное вместе — \nмы покажем как пользоваться приложением',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).completeOnboarding();
                  if (context.mounted) context.go('/register');
                },
                child: const Text('Зарегистрироваться'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).completeOnboarding();
                  if (context.mounted) context.go('/login');
                },
                child: Text(
                  'Уже есть аккаунт? Войти',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 5: Add routes to `app_router.dart`**
```dart
GoRoute(path: '/onboarding/farm-name', builder: (_, __) => const OnboardingFarmNameScreen()),
GoRoute(path: '/onboarding/farm-type', builder: (_, __) => const OnboardingFarmTypeScreen()),
GoRoute(path: '/onboarding/ready',     builder: (_, __) => const OnboardingReadyScreen()),
```

**Step 6: Verify + Commit**
```bash
cd mobile && dart analyze lib/features/onboarding/
git add mobile/lib/features/onboarding/ mobile/lib/core/router/app_router.dart
git commit -m "feat(onboarding): add FarmName, FarmType, Ready screens"
```

---

## Phase 4: Auth Screens Redesign

### Task 15: Redesign LoginScreen

**Files:**
- Modify: `mobile/lib/features/auth/presentation/screens/login_screen.dart`

**Goal:** Dark background, logo, Google/Apple buttons, email/password form, remove test-credentials block.

Full replacement — see design doc Section 3. Key changes:
- Remove test credentials container
- Add Google/Apple sign-in buttons (UI only, wired to TODO for now)
- Use AppColors for all colors
- Use AppTypography for text styles

**Step 1: Replace LoginScreen build method** (keep logic, redesign UI)

**Step 2: Verify app builds**
```bash
cd mobile && flutter build apk --debug 2>&1 | tail -5
```

**Step 3: Commit**
```bash
git add mobile/lib/features/auth/presentation/screens/login_screen.dart
git commit -m "feat(auth): redesign LoginScreen — dark theme, Google/Apple buttons"
```

---

## Phase 5: Navigation Redesign

### Task 16: Refactor bottom nav to 4 tabs

**Files:**
- Modify: `mobile/lib/features/home/presentation/screens/main_navigation_screen.dart`
- Modify: `mobile/lib/core/router/app_router.dart`

**Changes:**
- Remove Tasks tab (index 3), keep: Today(0), Rabbits(1), Analytics(2), Menu(3)
- Change `/more` → `/menu`
- Pill indicator under active tab
- Border top instead of shadow

**Step 1: Update nav items and routing logic**

**Step 2: Create `/menu` route (rename from `/more`)**

**Step 3: Verify**
```bash
cd mobile && flutter analyze
```

**Step 4: Commit**
```bash
git add mobile/lib/features/home/presentation/screens/main_navigation_screen.dart \
         mobile/lib/core/router/app_router.dart
git commit -m "feat(nav): refactor to 4-tab bottom navigation"
```

---

### Task 17: Redesign MenuScreen (replaces MoreScreen)

**Files:**
- Create: `mobile/lib/features/home/presentation/screens/menu_screen.dart`

**Structure:** Profile card at top, structured list sections (not icon grid), clean rows with icons.

**Step 1: Create MenuScreen**

**Step 2: Wire in router**

**Step 3: Commit**
```bash
git commit -m "feat(nav): add MenuScreen replacing MoreScreen"
```

---

## Phase 6: Today Screen Redesign

### Task 18: Redesign TodayScreen

**Files:**
- Modify: `mobile/lib/features/home/presentation/screens/today_screen.dart`

**Changes:**
- Remove gradient header
- Add personalized greeting ("Добрый день, [Имя]!")
- Use AppCard + AlertCard widgets
- Use AppColors tokens — no hardcoded hex
- Summary widget row (2 cards, configurable in future)

**Step 1: Refactor TodayScreen**

**Step 2: Verify**
```bash
cd mobile && flutter analyze
```

**Step 3: Commit**
```bash
git commit -m "feat(today): redesign TodayScreen with Design System tokens"
```

---

## Phase 7: Settings & Profile

### Task 19: Create SettingsScreen

**Files:**
- Create: `mobile/lib/features/settings/presentation/screens/settings_screen.dart`

**Sections:** Profile card → Appearance (theme mode, accent color) → Dashboard → Notifications → About → Logout

**Step 1: Create SettingsScreen with ThemeProvider wired up**

**Step 2: Add route `/settings`**

**Step 3: Wire from MenuScreen**

**Step 4: Commit**
```bash
git commit -m "feat(settings): add SettingsScreen with theme/accent pickers"
```

---

## Phase 8: Product Tour

### Task 20: Create CoachMark system

**Files:**
- Create: `mobile/lib/core/widgets/coach_mark.dart`
- Create: `mobile/lib/features/onboarding/presentation/providers/tour_provider.dart`

**CoachMark:** Dark scrim overlay, highlighted cutout, tooltip, Next/Skip buttons.

**TourProvider:** Tracks which step (0–5) is shown, completes when all done.

**Step 1: Create CoachMark widget**

**Step 2: Create TourProvider**

**Step 3: Wire TourProvider into TodayScreen (show after first login)**

**Step 4: Commit**
```bash
git commit -m "feat(tour): add CoachMark product tour system"
```

---

## Phase 9: Feature Screens Token Migration

### Task 21: Remove hardcoded colors from all feature screens

**Files:** All `*/presentation/screens/*.dart` files

**Step 1: Global search for hardcoded hex colors**
```bash
cd mobile && grep -rn "Color(0x" lib/features/ | grep -v "app_colors" | grep -v ".g.dart" | grep -v ".freezed.dart"
```

**Step 2: Replace each hardcoded color with the appropriate AppColors token**

**Step 3: Verify no regressions**
```bash
cd mobile && flutter analyze && flutter build apk --debug
```

**Step 4: Commit**
```bash
git commit -m "refactor: replace all hardcoded colors with AppColors tokens"
```

---

## Progress Tracking

| Phase | Task | Status |
|---|---|---|
| 1 | Task 1: Inter font | ⬜ |
| 1 | Task 2: AppColors | ⬜ |
| 1 | Task 3: AppTypography | ⬜ |
| 1 | Task 4: AppRadius | ⬜ |
| 1 | Task 5: AppTheme rewrite | ⬜ |
| 1 | Task 6: ThemeProvider | ⬜ |
| 1 | Task 7: Wire MaterialApp | ⬜ |
| 2 | Task 8: AppCard widget | ⬜ |
| 2 | Task 9: StatusBadge widget | ⬜ |
| 2 | Task 10: AlertCard widget | ⬜ |
| 3 | Task 11: OnboardingProvider | ⬜ |
| 3 | Task 12: SplashScreen | ⬜ |
| 3 | Task 13: Welcome screen | ⬜ |
| 3 | Task 14: FarmName/FarmType/Ready | ⬜ |
| 4 | Task 15: LoginScreen redesign | ⬜ |
| 5 | Task 16: 4-tab navigation | ⬜ |
| 5 | Task 17: MenuScreen | ⬜ |
| 6 | Task 18: TodayScreen redesign | ⬜ |
| 7 | Task 19: SettingsScreen | ⬜ |
| 8 | Task 20: CoachMark / Product Tour | ⬜ |
| 9 | Task 21: Token migration | ⬜ |
