import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';

import '../support/contrast.dart';

/// Читаемость подписей — считаемая величина, а не дело вкуса.
///
/// Полевое испытание нашло это расчётом, а не глазами: надпись на кнопке
/// «Сохранить» давала 2.54 при норме 4.5, бейдж «Продан» — 1.91. Причём в
/// обеих темах сразу: они строятся одной функцией, и цвет надписи не
/// ветвился.
///
/// Тест сторожит не «красиво», а порог WCAG AA для обычного текста — 4.5:1.
/// Палитру правят по одному цвету за раз, и глазами такое не ловится.
const _minContrast = 4.5;

void main() {
  group('надпись на сплошной заливке акцентом', () {
    for (final entry in {
      'изумруд': AppColors.accentEmerald,
      'океан': AppColors.accentOcean,
      'закат': AppColors.accentSunset,
      'роза': AppColors.accentRose,
      'фиалка': AppColors.accentViolet,
    }.entries) {
      test('${entry.key} читается', () {
        final ratio = contrastRatio(AppColors.onAccent, entry.value);
        expect(
          ratio,
          greaterThanOrEqualTo(_minContrast),
          reason: 'надпись на кнопке «${entry.key}» даёт '
              '${ratio.toStringAsFixed(2)} при норме $_minContrast',
        );
      });
    }

    test('белая надпись на акценте не прошла бы — потому её и заменили', () {
      // Проверка от обратного: если кто-то вернёт Colors.white в onPrimary,
      // пусть будет видно, почему этого делать нельзя.
      const white = Color(0xFFFFFFFF);
      expect(
        contrastRatio(white, AppColors.accentEmerald),
        lessThan(_minContrast),
      );
    });
  });

  group('бейдж статуса: текст на своей же бледной подложке', () {
    // Так его и рисует StatusBadge: заливка — цвет с прозрачностью 15%.
    const badgeAlpha = 0.15;

    final surfaces = {
      Brightness.light: AppColors.lightSurface,
      Brightness.dark: AppColors.darkSurface,
    };

    final colors = {
      'здоров': AppColors.success,
      'продан': AppColors.warning,
      'болеет': AppColors.error,
      'случка': AppColors.domainBreeding,
      'здоровье': AppColors.info,
    };

    for (final surface in surfaces.entries) {
      for (final color in colors.entries) {
        test('«${color.key}» читается в теме ${surface.key.name}', () {
          final background = colorOver(color.value, surface.value, badgeAlpha);
          final text = AppColors.readableOn(color.value, surface.key);
          final ratio = contrastRatio(text, background);

          expect(
            ratio,
            greaterThanOrEqualTo(_minContrast),
            reason: 'бейдж «${color.key}» в теме ${surface.key.name} даёт '
                '${ratio.toStringAsFixed(2)} при норме $_minContrast',
          );
        });
      }
    }

    test('незнакомый цвет возвращается как есть, а не подменяется чужим', () {
      const custom = Color(0xFF123456);
      expect(AppColors.readableOn(custom, Brightness.light), custom);
    });
  });

  group('собранная тема, а не только палитра', () {
    // Кнопки задают цвет надписи сами, мимо ColorScheme.onPrimary: правка
    // одной схемы их не касается. Проверка палитры это пропускала — надпись
    // оставалась белой, хотя константы были верные.
    for (final brightness in Brightness.values) {
      for (final accent in AppColors.accentOptions) {
        test('кнопки читаются: ${brightness.name}, акцент $accent', () {
          final theme =
              AppTheme.build(brightness: brightness, accent: accent);

          final filled = theme.filledButtonTheme.style!.foregroundColor!
              .resolve(const <WidgetState>{})!;
          final elevated = theme.elevatedButtonTheme.style!.foregroundColor!
              .resolve(const <WidgetState>{})!;
          final fab = theme.floatingActionButtonTheme.foregroundColor!;

          for (final entry in {
            'FilledButton': filled,
            'ElevatedButton': elevated,
            'FloatingActionButton': fab,
          }.entries) {
            final ratio = contrastRatio(entry.value, accent);
            expect(
              ratio,
              greaterThanOrEqualTo(_minContrast),
              reason: '${entry.key} в теме ${brightness.name} даёт '
                  '${ratio.toStringAsFixed(2)} при норме $_minContrast',
            );
          }
        });
      }
    }

    test('надпись на красном тоже читается', () {
      final theme = AppTheme.build(
        brightness: Brightness.light,
        accent: AppColors.accentEmerald,
      );
      expect(
        contrastRatio(theme.colorScheme.onError, theme.colorScheme.error),
        greaterThanOrEqualTo(_minContrast),
      );
    });
  });

  group('основной текст на фоне экрана', () {
    test('светлая тема', () {
      expect(
        contrastRatio(AppColors.lightTextPrimary, AppColors.lightBackground),
        greaterThanOrEqualTo(_minContrast),
      );
    });

    test('тёмная тема', () {
      expect(
        contrastRatio(AppColors.darkTextPrimary, AppColors.darkBackground),
        greaterThanOrEqualTo(_minContrast),
      );
    });
  });
}
