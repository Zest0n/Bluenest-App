import 'package:flutter/material.dart';

/// BlueNest palette - following the 60-30-10 rule with #1800AD as dominant brand color.
class AppColors {
  // 10% Dominant Brand Color (Logo blue - CTAs, icons, key badges)
  static const Color primary = Color(0xFF1800AD);
  static const Color primaryDark = Color(0xFF6366F1); // Accent for dark UI
  static const Color secondary = Color(0xFF4338CA);
  static const Color midnight = Color(0xFF0B0050);
  static const Color accent = Color(0xFFFF7D61);

  // 60% Dominant Base Canvas (Light / Dark)
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0B0F19);

  // 30% Structural Surfaces & Cards (Light / Dark)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Borders (Light / Dark)
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  // Typography (Light / Dark)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  static const Color textSecondary = Color(0xFF64748B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Tints & Soft surfaces
  static const Color primarySoft = Color(0xFFECEBF8);
  static const Color primarySoftLight = Color(0xFFECEBF8);
  static const Color primarySoftDark = Color(0xFF1E1B4B);

  // Status highlights
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color success = Color(0xFF15803D);
  static const Color successBgDark = Color(0xFF064E3B);
  static const Color successDark = Color(0xFF34D399);

  static const Color warningBg = Color(0xFFFFEDD5);
  static const Color warning = Color(0xFFC2410C);
  static const Color warningBgDark = Color(0xFF7C2D12);
  static const Color warningDark = Color(0xFFFB923C);

  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color danger = Color(0xFFB91C1C);
  static const Color dangerBgDark = Color(0xFF7F1D1D);
  static const Color dangerDark = Color(0xFFF87171);

  static const Color infoBg = Color(0xFFDBEAFE);
  static const Color info = Color(0xFF1D4ED8);

  // Context-aware helpers for dark mode adaptation
  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceDark : surface;

  static Color backgroundOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? backgroundDark : background;

  static Color borderOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? borderDark : border;

  static Color textPrimaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondary;

  static Color primarySoftOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? primarySoftDark : primarySoft;
}
