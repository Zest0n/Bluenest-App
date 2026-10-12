import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/support.dart';
import '../../widgets/nav_tile.dart';
import 'my_rental_screen.dart';
import 'search_properties_screen.dart';

/// Screen 3 (tenant): Home Dashboard
class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Dashboard'),
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
              const Text('What would you like to do today?',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              NavTile(
                icon: Icons.search_rounded,
                title: 'Search Properties',
                subtitle: 'Find your next home',
                onTap: () =>
                    AppNavigator.push(context, const SearchPropertiesScreen()),
              ),
              NavTile(
                icon: Icons.receipt_long_rounded,
                title: 'My Rental & Rent Dues',
                subtitle: 'Your current rental and payments',
                onTap: () => AppNavigator.push(context, const MyRentalScreen()),
              ),
              NavTile(
                icon: Icons.support_agent_rounded,
                title: 'Contact Support',
                subtitle: 'Opens your email app',
                onTap: () => SupportMailer.open(context,
                    subject: 'BlueNest Support (Tenant)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
