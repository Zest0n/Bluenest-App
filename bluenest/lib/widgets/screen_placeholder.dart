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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                backgroundColor: AppColors.primarySoftOf(context),
                child: Icon(icon,
                    size: 36,
                    color: isDark ? AppColors.primaryDark : AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryOf(context))),
              const SizedBox(height: 6),
              Text(note,
                  style: TextStyle(color: AppColors.textSecondaryOf(context))),
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
