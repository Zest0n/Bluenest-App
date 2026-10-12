import 'package:flutter/material.dart';
import '../../widgets/screen_placeholder.dart';

/// Screen 5 (tenant): Property Details. Back goes to Search Properties.
class PropertyDetailsScreen extends StatelessWidget {
  final int propertyId;
  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Property Details')),
      body: ScreenPlaceholder(
        icon: Icons.home_work_outlined,
        title: 'Property Details',
        note: 'Property #$propertyId - UI coming soon',
      ),
    );
  }
}
