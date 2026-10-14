import 'package:flutter/material.dart';
import '../../widgets/screen_placeholder.dart';

/// Screen 9 (landlord): Tenants & Leases
class TenantsLeasesScreen extends StatelessWidget {
  const TenantsLeasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tenants & Leases')),
      body: const ScreenPlaceholder(
        icon: Icons.people_alt_rounded,
        title: 'Tenants & Leases',
      ),
    );
  }
}
