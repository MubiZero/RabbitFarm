import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_colors.dart';

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

double _relativeLuminance(Color color) {
  double channel(double value) {
    final c = value;
    return c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4) as double;
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

double contrastRatio(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// Цвет поверх подложки: бейдж рисуется прозрачностью, и считать контраст
/// нужно с тем, что получилось, а не с самим цветом.
Color _over(Color foreground, Color background, double alpha) => Color.fromARGB(
      255,
      ((foreground.r * alpha + background.r * (1 - alpha)) * 255).round(),
      ((foreground.g * alpha + background.g * (1 - alpha)) * 255).round(),
      ((foreground.b * alpha + background.b * (1 - alpha)) * 255).round(),
    );

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
          final background = _over(color.value, surface.value, badgeAlpha);
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
