import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../widgets/property_card.dart';
import '../../widgets/state_views.dart';
import 'property_details_screen.dart';

/// Screen 4 (tenant): Search Properties  ->  Property Details
class SearchPropertiesScreen extends StatefulWidget {
  final bool isTab;
  const SearchPropertiesScreen({super.key, this.isTab = false});

  @override
  State<SearchPropertiesScreen> createState() => _SearchPropertiesScreenState();
}

class _SearchPropertiesScreenState extends State<SearchPropertiesScreen> {
  bool _loading = true;
  String? _error;
  List<Property> _all = [];
  String _query = '';
  int? _bhk; // null = all, 4 = "4+"

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
    final res = await PropertyService.list();
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (res.ok) {
        _all = res.data!;
      } else {
        _error = res.error;
      }
    });
  }

  List<Property> get _filtered {
    final q = _query.trim().toLowerCase();
    return _all.where((p) {
      final matchesText = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q) ||
          p.locality.toLowerCase().contains(q);
      final matchesBhk = _bhk == null ||
          (_bhk == 4 ? (p.bhk ?? 0) >= 4 : p.bhk == _bhk);
      return matchesText && matchesBhk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text('Search Properties'),
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab ? null : const BackButton(),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search by title, city or locality',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: AppColors.surfaceOf(context),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final opt in <int?>[null, 1, 2, 3, 4])
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                        child: ChoiceChip(
                          label: Text(opt == null ? 'All' : (opt == 4 ? '4+ BHK' : '$opt BHK')),
                          selected: _bhk == opt,
                          selectedColor: AppColors.primarySoftOf(context),
                          labelStyle: TextStyle(
                            color: _bhk == opt
                                ? (isDark ? AppColors.primaryDark : AppColors.primary)
                                : AppColors.textSecondaryOf(context),
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) => setState(() => _bhk = opt),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    final items = _filtered;
    if (items.isEmpty) {
      return const EmptyView(
        icon: Icons.home_work_outlined,
        title: 'No properties found',
        subtitle: 'Try a different search or filter.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length,
        itemBuilder: (_, i) => PropertyCard(
          property: items[i],
          onTap: () => AppNavigator.push(
              context, PropertyDetailsScreen(propertyId: items[i].id)),
        ),
      ),
    );
  }
}
