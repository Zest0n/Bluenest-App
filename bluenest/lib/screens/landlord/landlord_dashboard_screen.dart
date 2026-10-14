import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/format.dart';
import '../../services/user_service.dart';
import '../../widgets/brand_logo.dart';
import '../settings_screen.dart';
import 'my_properties_screen.dart';
import 'payments_records_screen.dart';
import 'tenants_leases_screen.dart';

/// Screen 3 (landlord): Landlord Dashboard with Fixed Bottom Bar
class LandlordDashboardScreen extends StatefulWidget {
  const LandlordDashboardScreen({super.key});

  @override
  State<LandlordDashboardScreen> createState() =>
      _LandlordDashboardScreenState();
}

class _LandlordDashboardScreenState extends State<LandlordDashboardScreen> {
  // Initial tab is 1 (Home is in the center)
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _goToProperties() {
    setState(() => _currentIndex = 0);
  }

  void _goToSettings() {
    setState(() => _currentIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Left: My Properties
          const MyPropertiesScreen(isTab: true),
          // Center: Home
          _LandlordHomeView(
            onGoToProperties: _goToProperties,
            onGoToSettings: _goToSettings,
          ),
          // Right: Settings
          const SettingsScreen(role: 'landlord', isTab: true),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          border: Border(
            top: BorderSide(color: AppColors.borderOf(context), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          backgroundColor: AppColors.surfaceOf(context),
          indicatorColor: AppColors.primarySoftOf(context),
          elevation: 0,
          destinations: [
            // Left: My Properties
            NavigationDestination(
              icon: Icon(Icons.apartment_outlined,
                  color: AppColors.textSecondaryOf(context)),
              selectedIcon:
                  const Icon(Icons.apartment_rounded, color: AppColors.primary),
              label: 'Properties',
            ),
            // Center: Home
            NavigationDestination(
              icon: Icon(Icons.home_outlined,
                  color: AppColors.textSecondaryOf(context)),
              selectedIcon:
                  const Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            // Right: Settings
            NavigationDestination(
              icon: Icon(Icons.settings_outlined,
                  color: AppColors.textSecondaryOf(context)),
              selectedIcon:
                  const Icon(Icons.settings_rounded, color: AppColors.primary),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _LandlordHomeView extends StatelessWidget {
  final VoidCallback onGoToProperties;
  final VoidCallback onGoToSettings;

  const _LandlordHomeView({
    required this.onGoToProperties,
    required this.onGoToSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        // Only "Landlord" in the top (removed "Dashboard")
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandLogo.mark(size: 32, radius: 8),
            const SizedBox(width: 12),
            Text(
              'Landlord',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ],
        ),
        actions: [
          // Circle profile option and manage profile button on right
          ValueListenableBuilder<UserProfile>(
            valueListenable: UserService.current,
            builder: (context, user, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Tooltip(
                  message: 'Manage Profile',
                  child: InkWell(
                    key: const Key('landlord_profile_bubble'),
                    borderRadius: BorderRadius.circular(24),
                    onTap: onGoToSettings,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          user.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                // Welcome Greeting
                ValueListenableBuilder<UserProfile>(
                  valueListenable: UserService.current,
                  builder: (context, user, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${user.firstName}!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Here's what's happening with your properties.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Bigger "Payment and rent record" box at top
                _PaymentRentRecordCard(),
                const SizedBox(height: 16),

                // "My Properties" button below it
                _ActionButtonCard(
                  icon: Icons.apartment_rounded,
                  title: 'My Properties',
                  subtitle: 'View, add and edit your listings',
                  onTap: onGoToProperties,
                ),
                const SizedBox(height: 16),

                // "Tenants and leases" button below it
                _ActionButtonCard(
                  icon: Icons.people_alt_rounded,
                  title: 'Tenants & Leases',
                  subtitle: 'Tenant details and lease records',
                  onTap: () =>
                      AppNavigator.push(context, const TenantsLeasesScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bigger "Payment and rent record" box at top
class _PaymentRentRecordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context), // Solid color (No gradient per rule)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and diagonal arrow button opening PaymentsRecordsScreen
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftOf(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.payments_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Payment & Rent Records',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
              // Open details button in top right corner in form of a diagonal arrow
              Tooltip(
                message: 'Open Payment Records',
                child: InkWell(
                  key: const Key('open_payment_details_arrow'),
                  borderRadius: BorderRadius.circular(10),
                  onTap: () =>
                      AppNavigator.push(context, const PaymentsRecordsScreen()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftOf(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.north_east_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Short information: Rent collected and Rent pending
          Row(
            children: [
              // Rent Collected
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: 16, color: AppColors.success),
                          const SizedBox(width: 6),
                          Text(
                            'Rent Collected',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatRupees(45000),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'October 2026',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.success.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Rent Pending
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pending_actions_rounded,
                              size: 16, color: AppColors.warning),
                          const SizedBox(width: 6),
                          Text(
                            'Rent Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatRupees(18000),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1 Tenant Due',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.warning.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Overview footer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '3 active leases on record',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryOf(context),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () =>
                    AppNavigator.push(context, const PaymentsRecordsScreen()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'View All Records',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Action button cards below the payment box
class _ActionButtonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionButtonCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context), // Solid color (No gradient)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoftOf(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
