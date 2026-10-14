import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/format.dart';
import '../../services/rental_service.dart';
import '../../services/user_service.dart';
import '../../widgets/brand_logo.dart';
import '../settings_screen.dart';
import 'my_rental_screen.dart';
import 'search_properties_screen.dart';

/// Screen 3 (tenant): Resident Dashboard
class TenantDashboardScreen extends StatefulWidget {
  const TenantDashboardScreen({super.key});

  @override
  State<TenantDashboardScreen> createState() => _TenantDashboardScreenState();
}

class _TenantDashboardScreenState extends State<TenantDashboardScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _goToSearch() {
    setState(() => _currentIndex = 1);
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
          _ResidentHomeView(
            onGoToSearch: _goToSearch,
            onGoToSettings: _goToSettings,
          ),
          const SearchPropertiesScreen(isTab: true),
          const SettingsScreen(role: 'tenant', isTab: true),
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
            NavigationDestination(
              icon: Icon(Icons.home_outlined,
                  color: AppColors.textSecondaryOf(context)),
              selectedIcon:
                  const Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined,
                  color: AppColors.textSecondaryOf(context)),
              selectedIcon:
                  const Icon(Icons.search_rounded, color: AppColors.primary),
              label: 'Search',
            ),
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

class _ResidentHomeView extends StatelessWidget {
  final VoidCallback onGoToSearch;
  final VoidCallback onGoToSettings;

  const _ResidentHomeView({
    required this.onGoToSearch,
    required this.onGoToSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandLogo.mark(size: 32, radius: 8),
            const SizedBox(width: 12),
            Text(
              'Resident',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ],
        ),
        actions: [
          // Profile bubble in top right corner that redirects to Settings
          ValueListenableBuilder<UserProfile>(
            valueListenable: UserService.current,
            builder: (context, user, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Tooltip(
                  message: 'Profile Settings',
                  child: InkWell(
                    key: const Key('profile_bubble'),
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
                        backgroundColor: AppColors.primary, // Solid color per rule
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Card height ~40% of viewport following 4-grid rule
                final rawHeight = constraints.maxHeight * 0.38;
                final cardHeight =
                    ((rawHeight / 4).round() * 4).toDouble().clamp(240.0, 320.0);

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
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
                                'What would you like to do today?',
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

                      // Box 1: My rental and rent dues (40% of the screen)
                      SizedBox(
                        height: cardHeight,
                        width: double.infinity,
                        child: _RentalDuesCard(
                          onExploreProperties: onGoToSearch,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Box 2: Search Properties (Same size, below Box 1)
                      SizedBox(
                        height: cardHeight,
                        width: double.infinity,
                        child: _SearchPropertiesCard(
                          onGoToSearch: onGoToSearch,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Large Box 1: My rental and rent dues (Not whole as button, diagonal arrow opens details)
class _RentalDuesCard extends StatelessWidget {
  final VoidCallback onExploreProperties;

  const _RentalDuesCard({required this.onExploreProperties});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RentalInfo>(
      valueListenable: RentalService.current,
      builder: (context, rental, _) {
        final isPaid = rental.status == RentalStatus.paid;
        final isEmpty = rental.status == RentalStatus.noPropertyLeased;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context), // Solid background (No gradient)
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPaid
                  ? AppColors.success.withValues(alpha: 0.35)
                  : (isEmpty
                      ? AppColors.borderOf(context)
                      : AppColors.warning.withValues(alpha: 0.35)),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Title + Status Badge + Diagonal Arrow button (opens details)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My Rental & Rent Dues',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                  ),
                  _buildStatusBadge(context, rental.status),
                  const SizedBox(width: 8),

                  // Diagonal pointing arrow button which opens the rental and dues screen
                  Tooltip(
                    message: 'Open Rental & Dues Details',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () =>
                          AppNavigator.push(context, const MyRentalScreen()),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoftOf(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.north_east_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  // Quick test simulator menu
                  PopupMenuButton<RentalStatus>(
                    tooltip: 'Simulate Status',
                    icon: Icon(Icons.more_vert,
                        size: 20, color: AppColors.textSecondaryOf(context)),
                    onSelected: (status) => RentalService.setStatus(status),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: RentalStatus.pending,
                        child: Text('Simulate: Rent Pending'),
                      ),
                      PopupMenuItem(
                        value: RentalStatus.paid,
                        child: Text('Simulate: Rent Paid'),
                      ),
                      PopupMenuItem(
                        value: RentalStatus.noPropertyLeased,
                        child: Text('Simulate: No Property Leased'),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // Body content based on status
              if (isEmpty)
                _buildEmptyState(context)
              else if (isPaid)
                _buildPaidState(context, rental)
              else
                _buildPendingState(context, rental),

              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, RentalStatus status) {
    switch (status) {
      case RentalStatus.paid:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 14, color: AppColors.success),
              const SizedBox(width: 4),
              Text(
                'Paid',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        );
      case RentalStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded,
                  size: 14, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                'Pending',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        );
      case RentalStatus.noPropertyLeased:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primarySoftOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'No Lease',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        );
    }
  }

  Widget _buildPendingState(BuildContext context, RentalInfo rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Rent Dues',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupees(rental.dueAmount),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimaryOf(context),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Due ${rental.dueDate}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                size: 14, color: AppColors.textSecondaryOf(context)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                rental.propertyTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Only the Pay Now button is workable here (Details button replaced with diagonal arrow)
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: () {
              RentalService.markAsPaid();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Payment completed successfully! Status updated to Paid.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            icon: const Icon(Icons.payment_rounded, size: 18),
            label: const Text('Pay Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaidState(BuildContext context, RentalInfo rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: AppColors.success, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Dues Cleared!',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Monthly rent: ${formatRupees(rental.monthlyRent)} (Paid)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                size: 14, color: AppColors.textSecondaryOf(context)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                rental.propertyTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.night_shelter_outlined,
            size: 36,
            color: AppColors.textSecondaryOf(context),
          ),
          const SizedBox(height: 8),
          Text(
            'No property leased',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You have not leased any property yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onExploreProperties,
            icon: const Icon(Icons.search, size: 16),
            label: const Text('Explore Available Homes'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 40),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Large Box 2: Search Properties
/// NOT whole as button, no search icon in top left, bigger title on left,
/// bigger explore button on right, horizontal search bar button below
class _SearchPropertiesCard extends StatelessWidget {
  final VoidCallback onGoToSearch;

  const _SearchPropertiesCard({required this.onGoToSearch});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary, // Dominant color #1800ad
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF6366F1) : AppColors.primary,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1800AD).withValues(alpha: isDark ? 0.4 : 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Bigger "Search Properties" title on left (No search icon) + High-contrast Explore button on right
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Search Properties',
                  style: TextStyle(
                    fontSize: 21, // Bigger title per rule
                    fontWeight: FontWeight.w800,
                    color: Colors.white, // Crisp high contrast on #1800ad
                  ),
                ),
              ),
              // Explore option in contrast as a button taking to search screen
              ElevatedButton.icon(
                onPressed: onGoToSearch,
                icon: const Icon(Icons.arrow_forward_rounded,
                    size: 16, color: AppColors.primary),
                label: const Text('Explore'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Inverted contrast against #1800ad
                  foregroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Middle text description in high contrast
          const Text(
            'Find your next home',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white, // Crisp high contrast
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Browse verified apartments, houses, studios and villas.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFE0E7FF), // Bright light-indigo contrast
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),

          // Below it: Horizontal search bar with high contrast
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onGoToSearch,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // Crisp high contrast container inside dominant box
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded,
                        size: 20, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search by title, city or locality...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.tune_rounded,
                        size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
