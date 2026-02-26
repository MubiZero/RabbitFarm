import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

// Keys for SharedPreferences
const _kThemeMode = 'theme_mode';    // 'dark' | 'light' | 'system'
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
