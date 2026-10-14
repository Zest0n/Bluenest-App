import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/format.dart';
import '../models/property.dart';
import 'mini_chip.dart';
import 'property_thumb.dart';

/// List card used by Search Properties (tenant) and My Properties (landlord).
/// [footer] is for extra actions, e.g. Edit / Delete buttons.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  final Widget? footer;

  const PropertyCard({super.key, required this.property, this.onTap, this.footer});

  @override
  Widget build(BuildContext context) {
    final p = property;
    final rent = p.rent;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderOf(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PropertyThumb(url: p.imageUrl, width: 64, height: 64),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (p.location.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 15,
                                  color: AppColors.textSecondaryOf(context)),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  p.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondaryOf(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (p.bhk != null)
                              MiniChip('${p.bhk} BHK', icon: Icons.bed_outlined),
                            if (p.sizeSqft != null)
                              MiniChip('${p.sizeSqft!.round()} sq ft',
                                  icon: Icons.square_foot_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (rent != null) ...[
                const SizedBox(height: 10),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: formatRupees(rent),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.primaryDark : AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' / month',
                    style: TextStyle(color: AppColors.textSecondaryOf(context)),
                  ),
                ])),
              ],
              if (footer != null) ...[
                const SizedBox(height: 12),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
