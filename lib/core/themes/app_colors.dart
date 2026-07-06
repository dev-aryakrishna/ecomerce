import 'package:flutter/material.dart';

/// Centralized color palette. Never hardcode a color inside a widget —
/// add it here (or use the [AppColorsX] context extension for theme-aware
/// colors) instead.
class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFFE5E3FF);
  static const accent = Color(0xFFFF6584);

  // Semantic
  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFFDCFCE7);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const info = Color(0xFF3B82F6);

  // Ratings
  static const star = Color(0xFFFBBF24);

  // Light surfaces
  static const background = Color(0xFFF8F9FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF1F2F6);
  static const border = Color(0xFFE7E8ED);
  static const divider = Color(0xFFEDEEF2);

  // Dark surfaces
  static const backgroundDark = Color(0xFF0F0F14);
  static const surfaceDark = Color(0xFF1A1B22);
  static const surfaceAltDark = Color(0xFF23242D);
  static const borderDark = Color(0xFF2E2F3A);
  static const dividerDark = Color(0xFF2A2B35);

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textPrimaryDark = Color(0xFFF5F5F7);
  static const textSecondaryDark = Color(0xFFA1A1AA);
  static const textTertiaryDark = Color(0xFF71717A);
  static const textWhite = Color(0xFFFFFFFF);

  // Overlay / shimmer
  static const overlay = Color(0x66000000);
  static const shimmerBaseLight = Color(0xFFEDEEF2);
  static const shimmerHighlightLight = Color(0xFFF8F9FB);
  static const shimmerBaseDark = Color(0xFF23242D);
  static const shimmerHighlightDark = Color(0xFF2E2F3A);
}

/// Theme-aware color accessor so widgets can do `context.colors.textPrimary`
/// instead of branching on `Theme.of(context).brightness` everywhere.
extension AppColorsX on BuildContext {
  ContextColors get colors => ContextColors(this);
}

class ContextColors {
  final BuildContext context;
  const ContextColors(this.context);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get background => _isDark ? AppColors.backgroundDark : AppColors.background;
  Color get surface => _isDark ? AppColors.surfaceDark : AppColors.surface;
  Color get surfaceAlt => _isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt;
  Color get border => _isDark ? AppColors.borderDark : AppColors.border;
  Color get divider => _isDark ? AppColors.dividerDark : AppColors.divider;
  Color get textPrimary => _isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get textSecondary => _isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get textTertiary => _isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
  Color get shimmerBase => _isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;
  Color get shimmerHighlight => _isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight;
}
