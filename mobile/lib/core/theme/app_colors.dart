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
