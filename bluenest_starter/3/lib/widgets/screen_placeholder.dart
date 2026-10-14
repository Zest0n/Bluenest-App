import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Temporary body for screens whose UI isn't designed yet.
/// Replace it screen by screen as data / APIs arrive.
class ScreenPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String note;
  final List<Widget> actions;

  const ScreenPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    this.note = 'UI coming soon',
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primarySoft,
                child: Icon(icon, size: 36, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(note,
                  style: const TextStyle(color: AppColors.textSecondary)),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 28),
                ...actions,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
