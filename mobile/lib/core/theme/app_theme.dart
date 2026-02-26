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

    final bg         = isDark ? AppColors.darkBackground     : AppColors.lightBackground;
    final surface    = isDark ? AppColors.darkSurface        : AppColors.lightSurface;
    final surfaceVar = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final border     = isDark ? AppColors.darkBorder         : AppColors.lightBorder;
    final txtPri     = isDark ? AppColors.darkTextPrimary    : AppColors.lightTextPrimary;
    final txtSec     = isDark ? AppColors.darkTextSecondary  : AppColors.lightTextSecondary;
    final txtHint    = isDark ? AppColors.darkTextHint       : AppColors.lightTextHint;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      primaryContainer: accent.withValues(alpha: 0.15),
      onPrimaryContainer: accent,
      secondary: accent,
      onSecondary: Colors.white,
      secondaryContainer: accent.withValues(alpha: 0.1),
      onSecondaryContainer: accent,
      error: AppColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: txtPri,
      onSurfaceVariant: txtSec,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.5),
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
        displayLarge:   AppTypography.displayLg.copyWith(color: txtPri),
        displayMedium:  AppTypography.displayMd.copyWith(color: txtPri),
        displaySmall:   AppTypography.titleLg.copyWith(color: txtPri),
        headlineMedium: AppTypography.titleLg.copyWith(color: txtPri),
        titleLarge:     AppTypography.titleMd.copyWith(color: txtPri),
        titleMedium:    AppTypography.titleMd.copyWith(color: txtPri),
        bodyLarge:      AppTypography.bodyLg.copyWith(color: txtPri),
        bodyMedium:     AppTypography.bodyMd.copyWith(color: txtPri),
        labelLarge:     AppTypography.labelLg.copyWith(color: txtPri),
        labelSmall:     AppTypography.labelSm.copyWith(color: txtSec),
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
