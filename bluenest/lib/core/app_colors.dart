import 'package:flutter/material.dart';

/// BlueNest palette (from the team's design sheet).
/// Change a colour here and the whole app follows.
class AppColors {
  // Core brand & action
  static const Color midnight = Color(0xFF111E30); // Primary dark / sidebar / dark buttons
  static const Color sidebarActive = Color(0xFF243B5A); // Selected nav item on the dark sidebar
  static const Color primary = Color(0xFFE07A5F); // Terracotta Coral - CTA
  static const Color secondary = Color(0xFF3B82F6); // Cobalt Blue - interactive
  static const Color accent = Color(0xFFFF7D61); // Bright Coral Glow - hover/accent

  // Neutrals & surfaces
  static const Color textPrimary = Color(0xFF0F172A); // Deep Slate
  static const Color textSecondary = Color(0xFF64748B); // Cool Gray
  static const Color border = Color(0xFFE2E8F0); // Soft Gray
  static const Color background = Color(0xFFF7F4F1); // Warm off-white canvas (matches reference UI)
  static const Color surface = Color(0xFFFFFFFF); // Cards

  // Light tint of the primary (icon circles etc.) - derived, not in the sheet
  static const Color primarySoft = Color(0xFFFBECE7);

  // Functional / status (background + foreground pairs)
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color success = Color(0xFF15803D); // Rented / Active / Low
  static const Color warningBg = Color(0xFFFFEDD5);
  static const Color warning = Color(0xFFC2410C); // Expiring soon / Medium
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color danger = Color(0xFFB91C1C); // Expired / High / Urgent
  static const Color infoBg = Color(0xFFDBEAFE);
  static const Color info = Color(0xFF1D4ED8); // Available / In progress
}
