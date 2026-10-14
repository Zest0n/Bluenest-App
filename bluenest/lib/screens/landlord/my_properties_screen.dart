import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../widgets/property_card.dart';
import '../../widgets/state_views.dart';
import 'add_edit_property_screen.dart';

/// Screen 7 (landlord): My Properties  <->  Add / Edit Property
class MyPropertiesScreen extends StatefulWidget {
  final bool isTab;
  const MyPropertiesScreen({super.key, this.isTab = false});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  bool _loading = true;
  String? _error;
  List<Property> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  // NOTE: uses GET /api/listing/properties/ - if the backend returns every
  // landlord's properties, we need a "my properties" endpoint (or owner filter).
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
        _items = res.data!;
      } else {
        _error = res.error;
      }
    });
  }

  Future<void> _openForm([Property? p]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddEditPropertyScreen(property: p)),
    );
    if (changed == true) _load();
  }

  Future<void> _delete(Property p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete property?'),
        content: Text('"${p.title}" will be permanently removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final res = await PropertyService.delete(p.id);
    if (!mounted) return;
    if (res.ok) {
      setState(() => _items.removeWhere((x) => x.id == p.id));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Property deleted')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res.error ?? 'Could not delete'),
          backgroundColor: AppColors.danger));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text('My Properties'),
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab ? null : const BackButton(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    if (_items.isEmpty) {
      return const EmptyView(
        icon: Icons.apartment_rounded,
        title: 'No properties yet',
        subtitle: 'Tap "Add Property" to list your first one.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final p = _items[i];
          return PropertyCard(
            property: p,
            onTap: () => _openForm(p),
            footer: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openForm(p),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _delete(p),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.dangerBg),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
