import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: AppColors.textSecondaryOf(context)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondaryOf(context))),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              child: ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.primarySoftOf(context),
              child: Icon(icon,
                  size: 32,
                  color: isDark ? AppColors.primaryDark : AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context))),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondaryOf(context))),
            ],
          ],
        ),
      ),
    );
  }
}
