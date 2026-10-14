import 'package:flutter/material.dart';
import '../../core/app_navigator.dart';
import '../../widgets/nav_tile.dart';
import '../../widgets/screen_placeholder.dart';
import 'property_details_screen.dart';

/// Screen 4 (tenant): Search Properties  ->  Property Details
class SearchPropertiesScreen extends StatelessWidget {
  const SearchPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Properties')),
      body: ScreenPlaceholder(
        icon: Icons.search_rounded,
        title: 'Search Properties',
        actions: [
          // TODO: replace with the real property list. Each card should call
          // AppNavigator.push(context, PropertyDetailsScreen(propertyId: p.id));
          NavTile(
            icon: Icons.home_work_outlined,
            title: 'Sample property',
            subtitle: 'Temporary link to Property Details',
            onTap: () => AppNavigator.push(
                context, const PropertyDetailsScreen(propertyId: 1)),
          ),
        ],
      ),
    );
  }
}
