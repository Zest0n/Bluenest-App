import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum BadgeKind { success, warning, danger, info, neutral }

/// Pill badge used everywhere: Rented / Available / Active / Expiring Soon /
/// Expired / High / Medium / Low / Open / In Progress / Resolved ...
///
/// Usage:  StatusBadge.forStatus('Rented')   or   StatusBadge('Custom', BadgeKind.info)
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeKind kind;

  const StatusBadge(this.label, this.kind, {super.key});

  /// Picks the colour from the status text, following the team palette sheet.
  factory StatusBadge.forStatus(String status, {Key? key}) {
    return StatusBadge(status, _kindFor(status), key: key);
  }

  static BadgeKind _kindFor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'rented':
      case 'active':
      case 'low':
      case 'resolved':
      case 'paid':
        return BadgeKind.success;
      case 'available':
      case 'in progress':
        return BadgeKind.info;
      case 'expiring soon':
      case 'medium':
      case 'pending':
        return BadgeKind.warning;
      case 'expired':
      case 'high':
      case 'urgent':
      case 'open':
      case 'overdue':
        return BadgeKind.danger;
      default:
        return BadgeKind.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    switch (kind) {
      case BadgeKind.success:
        bg = AppColors.successBg;
        fg = AppColors.success;
      case BadgeKind.warning:
        bg = AppColors.warningBg;
        fg = AppColors.warning;
      case BadgeKind.danger:
        bg = AppColors.dangerBg;
        fg = AppColors.danger;
      case BadgeKind.info:
        bg = AppColors.infoBg;
        fg = AppColors.info;
      case BadgeKind.neutral:
        bg = AppColors.border;
        fg = AppColors.textSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
