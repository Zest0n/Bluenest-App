import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/support.dart';
import '../../widgets/nav_tile.dart';
import 'my_properties_screen.dart';
import 'payments_records_screen.dart';
import 'tenants_leases_screen.dart';

/// Screen 3 (landlord): Home Dashboard
class LandlordDashboardScreen extends StatelessWidget {
  const LandlordDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landlord Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => AppNavigator.logout(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Welcome back!',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text("Here's what's happening with your properties.",
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              NavTile(
                icon: Icons.apartment_rounded,
                title: 'My Properties',
                subtitle: 'View, add and edit your listings',
                onTap: () =>
                    AppNavigator.push(context, const MyPropertiesScreen()),
              ),
              NavTile(
                icon: Icons.people_alt_rounded,
                title: 'Tenants & Leases',
                subtitle: 'Tenant details and lease records',
                onTap: () =>
                    AppNavigator.push(context, const TenantsLeasesScreen()),
              ),
              NavTile(
                icon: Icons.payments_rounded,
                title: 'Payments / Rent Records',
                subtitle: 'Track rent collected and dues',
                onTap: () =>
                    AppNavigator.push(context, const PaymentsRecordsScreen()),
              ),
              NavTile(
                icon: Icons.support_agent_rounded,
                title: 'Contact Support',
                subtitle: 'Opens your email app',
                onTap: () => SupportMailer.open(context,
                    subject: 'BlueNest Support (Landlord)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
