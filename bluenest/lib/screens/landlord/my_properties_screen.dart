import 'package:flutter/material.dart';
import '../../core/app_navigator.dart';
import '../../widgets/nav_tile.dart';
import '../../widgets/screen_placeholder.dart';
import 'add_edit_property_screen.dart';

/// Screen 7 (landlord): My Properties  <->  Add / Edit Property
class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            AppNavigator.push(context, const AddEditPropertyScreen()),
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
      body: ScreenPlaceholder(
        icon: Icons.apartment_rounded,
        title: 'My Properties',
        actions: [
          // TODO: replace with the real list. Each card's Edit button should call
          // AppNavigator.push(context, AddEditPropertyScreen(propertyId: p.id));
          NavTile(
            icon: Icons.edit_outlined,
            title: 'Sample property',
            subtitle: 'Temporary link to Edit Property',
            onTap: () => AppNavigator.push(
                context, const AddEditPropertyScreen(propertyId: 1)),
          ),
        ],
      ),
    );
  }
}
