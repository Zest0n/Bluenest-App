import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/format.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../widgets/mini_chip.dart';
import '../../widgets/property_thumb.dart';
import '../../widgets/state_views.dart';

/// Screen 5 (tenant): Property Details. Back goes to Search Properties.
class PropertyDetailsScreen extends StatefulWidget {
  final int propertyId;
  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _loading = true;
  String? _error;
  Property? _property;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await PropertyService.get(widget.propertyId);
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (res.ok) {
        _property = res.data;
      } else {
        _error = res.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(title: const Text('Property Details')),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _content(_property!),
    );
  }

  Widget _content(Property p) {
    final rent = p.rent;
    final extra = p.detailRows;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PropertyThumb(url: p.imageUrl, height: 180, radius: 20, iconSize: 64),
            const SizedBox(height: 18),
            Text(p.title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context))),
            const SizedBox(height: 6),
            if (p.location.isNotEmpty)
              Row(children: [
                Icon(Icons.location_on_outlined,
                    size: 18, color: AppColors.textSecondaryOf(context)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(p.location,
                      style: TextStyle(color: AppColors.textSecondaryOf(context))),
                ),
              ]),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (p.bhk != null) MiniChip('${p.bhk} BHK', icon: Icons.bed_outlined),
              if (p.sizeSqft != null)
                MiniChip('${p.sizeSqft!.round()} sq ft', icon: Icons.square_foot_rounded),
            ]),
            if (rent != null) ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly rent',
                        style: TextStyle(color: AppColors.textSecondaryOf(context))),
                    Text(formatRupees(rent),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.primaryDark : AppColors.primary)),
                  ],
                ),
              ),
            ],
            if (p.description.trim().isNotEmpty) ...[
              const SizedBox(height: 22),
              const _SectionTitle('About this property'),
              const SizedBox(height: 6),
              Text(p.description,
                  style: TextStyle(height: 1.5, color: AppColors.textPrimaryOf(context))),
            ],
            if (extra.isNotEmpty) ...[
              const SizedBox(height: 22),
              const _SectionTitle('Details'),
              const SizedBox(height: 6),
              for (final e in extra.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(e.key,
                            style: TextStyle(color: AppColors.textSecondaryOf(context))),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(e.value,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryOf(context))),
                      ),
                    ],
                  ),
                ),
            ],
            if (p.createdAt != null) ...[
              const SizedBox(height: 18),
              Text('Listed on ${formatDate(p.createdAt!)}',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondaryOf(context))),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryOf(context)));
}
