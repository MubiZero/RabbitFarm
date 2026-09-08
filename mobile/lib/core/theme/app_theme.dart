import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  /// Собирает тему для указанной яркости и акцента.
  ///
  /// Здесь описан весь визуальный слой приложения: экраны настраивают
  /// компоновку, но не внешний вид элементов. Если кнопке или шторке
  /// понадобился локальный стиль — почти всегда это значит, что чего-то не
  /// хватает здесь.
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
      errorContainer: AppColors.error.withValues(alpha: 0.12),
      onErrorContainer: AppColors.error,
      surface: surface,
      onSurface: txtPri,
      surfaceContainerHighest: surfaceVar,
      onSurfaceVariant: txtSec,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.5),
      shadow: Colors.black,
      scrim: Colors.black,
    );

    // Форма и высота у всех крупных кнопок общие: на экране формы кнопки
    // стоят друг под другом, и разница даже в 4 пикселя читается как брак.
    final buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    const buttonSize = Size(double.infinity, 52);

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
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVar,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.bodyMd.copyWith(color: txtSec),
        hintStyle: AppTypography.bodyMd.copyWith(color: txtHint),
        // Подсказка и текст ошибки заданы явно: по умолчанию Material красит
        // их бледнее основного текста, и на цветной подложке они пропадают.
        helperStyle: AppTypography.labelSm.copyWith(color: txtSec),
        errorStyle: AppTypography.labelSm.copyWith(color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: accent.withValues(alpha: 0.3),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
          textStyle: AppTypography.labelLg,
        ),
      ),

      // FilledButton выглядит и ведёт себя как ElevatedButton: обе кнопки в
      // приложении означают «основное действие», и различать их на глаз
      // пользователь не должен.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: accent.withValues(alpha: 0.3),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
          textStyle: AppTypography.labelLg,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent),
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: AppTypography.labelLg,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          // Палец попадает по цели 44×44 даже в перчатке; у TextButton по
          // умолчанию высота меньше.
          minimumSize: const Size(0, 44),
          textStyle: AppTypography.labelLg,
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: txtPri),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        // Круглая форма здесь распространялась и на растянутые кнопки: фон
        // оставался кружком, а значок с подписью вылезали за него и наезжали
        // на текст. Скруглённый прямоугольник годится обеим формам и совпадает
        // со скруглением карточек.
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        extendedTextStyle: AppTypography.labelLg,
        extendedSizeConstraints: const BoxConstraints.tightFor(height: 52),
      ),

      // Приложение использует NavigationBar из Material 3. Раньше здесь стоял
      // bottomNavigationBarTheme, который к нему не применяется: панель
      // оставалась в стандартных цветах Material и не следовала за акцентом.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent.withValues(alpha: 0.15),
        indicatorShape: const StadiumBorder(),
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected) ? accent : txtSec,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTypography.labelSm.copyWith(
            color: states.contains(WidgetState.selected) ? accent : txtSec,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: border,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: border),
        ),
        titleTextStyle: AppTypography.titleLg.copyWith(color: txtPri),
        contentTextStyle: AppTypography.bodyMd.copyWith(color: txtSec),
      ),

      // Всплывающие сообщения плавают над плавающей кнопкой и панелью навигации,
      // поэтому им нужна собственная форма, а не полоса во всю ширину экрана.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? surfaceVar : AppColors.lightTextPrimary,
        contentTextStyle: AppTypography.bodyMd.copyWith(
          color: isDark ? txtPri : AppColors.lightSurface,
        ),
        actionTextColor: accent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surfaceVar,
        selectedColor: accent.withValues(alpha: 0.12),
        checkmarkColor: accent,
        side: BorderSide(color: border),
        shape: const StadiumBorder(),
        labelStyle: AppTypography.labelSm.copyWith(color: txtSec),
        secondaryLabelStyle: AppTypography.labelSm.copyWith(color: accent),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: txtSec,
        textColor: txtPri,
        titleTextStyle: AppTypography.bodyLg.copyWith(color: txtPri),
        subtitleTextStyle: AppTypography.bodyMd.copyWith(color: txtSec),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        headerBackgroundColor: accent,
        headerForegroundColor: Colors.white,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: surfaceVar,
        circularTrackColor: Colors.transparent,
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? surfaceVar : AppColors.lightTextPrimary,
          borderRadius: AppRadius.smAll,
        ),
        textStyle: AppTypography.labelSm.copyWith(
          color: isDark ? txtPri : AppColors.lightSurface,
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
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

}
