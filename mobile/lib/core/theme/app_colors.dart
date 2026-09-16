import 'package:flutter/material.dart';

/// Design token: цвета приложения.
///
/// Цвет в приложении несёт ровно три роли, и смешивать их нельзя:
///
/// * **Акцент темы** ([accentOptions]) — всё, что нажимается: кнопки, ссылки,
///   плавающая кнопка, выделенная вкладка. Его выбирает пользователь.
/// * **Состояние** ([success], [warning], [error], [info]) — красный означает
///   «что-то не так», а не «раздел про здоровье».
/// * **Раздел** ([AppDomain]) — опознавательный цвет модуля: только значки и
///   ярлыки, чтобы работник находил нужный раздел, не вчитываясь в подписи.
///
/// Хардкодить hex в экранах нельзя: цвет, у которого нет имени, невозможно
/// поменять во всём приложении разом.
abstract class AppColors {
  // === DARK MODE TOKENS ===
  static const darkBackground = Color(0xFF0A0D14);
  static const darkSurface = Color(0xFF131720);
  static const darkSurfaceVariant = Color(0xFF1C2130);
  static const darkBorder = Color(0xFF2A3142);
  static const darkTextPrimary = Color(0xFFF0F4FF);
  static const darkTextSecondary = Color(0xFF8B95B0);
  static const darkTextHint = Color(0xFF4A5168);

  // === LIGHT MODE TOKENS ===
  static const lightBackground = Color(0xFFF4F6FB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFEEF0F6);
  static const lightBorder = Color(0xFFE0E4EE);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightTextHint = Color(0xFF94A3B8);

  // === ACCENT COLORS (user selects one) ===
  //
  // Все пять — средней светлоты, и белый текст на них не читается: 2.15–4.23
  // при норме 4.5. Поэтому надпись на сплошной заливке тёмная
  // ([onAccent]), а не белая, — так все пять дают 4.74 и выше.
  static const accentEmerald = Color(0xFF10B981);
  static const accentOcean = Color(0xFF3B82F6);
  static const accentSunset = Color(0xFFF59E0B);
  static const accentRose = Color(0xFFEC4899);

  /// Фиолетовый светлее исходного `8B5CF6` намеренно: тот единственный из
  /// пяти не проходил ни с белым текстом (4.23), ни с тёмным (4.22) — то
  /// есть подобрать читаемую надпись к нему было нельзя вовсе.
  static const accentViolet = Color(0xFFA78BFA);

  /// Надпись на сплошной заливке акцентом.
  static const onAccent = Color(0xFF0F172A);

  static const List<Color> accentOptions = [
    accentEmerald,
    accentOcean,
    accentSunset,
    accentRose,
    accentViolet,
  ];

  static const List<String> accentNames = [
    'Изумруд',
    'Океан',
    'Закат',
    'Роза',
    'Фиалка',
  ];

  // === SEMANTIC COLORS (same in both modes) ===
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Те же цвета, пригодные для ТЕКСТА на бледной подложке того же цвета
  // (бейджи статусов: фон — цвет с прозрачностью 15%).
  //
  // Сам цвет в роли текста не читается: «Продан» давал 1.91 на светлой теме,
  // «Здоров» — 2.19. Оттенок сохраняется, меняется только светлота, поэтому
  // бейдж остаётся узнаваемым.
  static const successText = Color(0xFF047857);
  static const warningText = Color(0xFF92400E);
  static const errorText = Color(0xFFB91C1C);
  static const infoText = Color(0xFF1D4ED8);
  static const breedingText = Color(0xFFBE185D);
  static const violetText = Color(0xFF6D28D9);

  // На тёмной подложке нужны светлые: тёмный текст на тёмном фоне не виден,
  // а исходные цвета дают 4.06–4.32 — тоже ниже нормы.
  static const successTextDark = Color(0xFF6EE7B7);
  static const warningTextDark = Color(0xFFFCD34D);
  static const errorTextDark = Color(0xFFFCA5A5);
  static const infoTextDark = Color(0xFF93C5FD);
  static const breedingTextDark = Color(0xFFF9A8D4);
  static const violetTextDark = Color(0xFFC4B5FD);

  /// Читаемый текст того же оттенка для бледной подложки.
  ///
  /// Бейдж рисуется цветом с прозрачностью 15% и тем же цветом в тексте —
  /// от этого он и не читался. Здесь подбирается вариант по светлоте темы;
  /// незнакомый цвет возвращается как есть, чтобы не подменять чужой оттенок
  /// произвольным.
  static Color readableOn(Color color, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (color.toARGB32()) {
      0xFF10B981 => dark ? successTextDark : successText,
      0xFFF59E0B => dark ? warningTextDark : warningText,
      0xFFEF4444 => dark ? errorTextDark : errorText,
      0xFF3B82F6 => dark ? infoTextDark : infoText,
      0xFFEC4899 => dark ? breedingTextDark : breedingText,
      0xFFA78BFA => dark ? violetTextDark : violetText,
      _ => color,
    };
  }

  /// Нет связи (`OfflineBanner`). Намеренно не жёлтый: с фермой всё в порядке,
  /// это состояние устройства. Тёмный нейтральный ещё и держит контраст с
  /// белым текстом, которого янтарному не хватает.
  static const offline = Color(0xFF475569);

  // === DOMAIN COLORS ===
  // Значения намеренно совпадают с палитрой акцентов, но живут отдельно:
  // если завтра поменяется набор акцентов, цвета разделов не должны поехать.
  static const domainLivestock = Color(0xFF10B981);
  static const domainBreeding = Color(0xFFEC4899);
  static const domainHealth = Color(0xFF3B82F6);
  static const domainFeeding = Color(0xFFF59E0B);
  static const domainTasks = Color(0xFF8B5CF6);

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

/// Раздел приложения. Цветом помечено только то, чем занимаются каждый день,
/// — по нему раздел узнают с расстояния вытянутой руки.
///
/// Служебные разделы ([admin]: финансы, работники, настройки) остаются
/// нейтральными: семи разноцветных значков в одном списке глаз уже не
/// различает, и «радуга» превращается в шум вместо подсказки. Внутри финансов
/// работает более точный сигнал — доход зелёный, расход красный.
enum AppDomain {
  /// Кролики, клетки, породы, родословная.
  livestock,

  /// Вязки, роды, планировщик пар.
  breeding,

  /// Вакцинации, медицинские карты.
  health,

  /// Запасы кормов, записи о кормлении.
  feeding,

  /// Задачи.
  tasks,

  /// Финансы, работники, настройки.
  admin,
}

extension AppDomainX on AppDomain {
  /// Цвет раздела. [admin] подстраивается под тему, поэтому нужен контекст.
  Color color(BuildContext context) => switch (this) {
        AppDomain.livestock => AppColors.domainLivestock,
        AppDomain.breeding => AppColors.domainBreeding,
        AppDomain.health => AppColors.domainHealth,
        AppDomain.feeding => AppColors.domainFeeding,
        AppDomain.tasks => AppColors.domainTasks,
        AppDomain.admin => Theme.of(context).colorScheme.onSurfaceVariant,
      };
}
