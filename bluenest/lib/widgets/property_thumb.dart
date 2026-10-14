import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Property photo, or a placeholder icon when there's no image.
class PropertyThumb extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double radius;
  final double iconSize;

  const PropertyThumb({
    super.key,
    this.url,
    this.width,
    this.height,
    this.radius = 14,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholder = Center(
      child: Icon(Icons.home_work_rounded,
          color: isDark ? AppColors.primaryDark : AppColors.primary,
          size: iconSize),
    );
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primarySoftOf(context),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => placeholder,
            ),
    );
  }
}
