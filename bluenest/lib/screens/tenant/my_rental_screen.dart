import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/format.dart';
import '../../services/rental_service.dart';
import 'search_properties_screen.dart';

/// Screen 6 (tenant): My Rental & Rent Dues
class MyRentalScreen extends StatelessWidget {
  const MyRentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text('My Rental & Rent Dues'),
        actions: [
          PopupMenuButton<RentalStatus>(
            tooltip: 'Simulate Status',
            icon: const Icon(Icons.tune_rounded),
            onSelected: (status) => RentalService.setStatus(status),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: RentalStatus.pending,
                child: Text('Simulate: Dues Pending'),
              ),
              const PopupMenuItem(
                value: RentalStatus.paid,
                child: Text('Simulate: Rent Paid'),
              ),
              const PopupMenuItem(
                value: RentalStatus.noPropertyLeased,
                child: Text('Simulate: No Property Leased'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ValueListenableBuilder<RentalInfo>(
            valueListenable: RentalService.current,
            builder: (context, rental, _) {
              if (rental.status == RentalStatus.noPropertyLeased) {
                return _buildNoPropertyView(context);
              }
              return _buildLeasedView(context, rental);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoPropertyView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primarySoftOf(context),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_work_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Property Leased',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You currently have no active rental agreement. Find your next dream home to view your rent dues and lease details here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textSecondaryOf(context), height: 1.4),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const SearchPropertiesScreen()),
                );
              },
              icon: const Icon(Icons.search, size: 20),
              label: const Text('Browse Properties'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeasedView(BuildContext context, RentalInfo rental) {
    final isPaid = rental.status == RentalStatus.paid;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Payment Status Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isPaid ? AppColors.successBg : AppColors.warningBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPaid
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.warning.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPaid
                            ? Icons.check_circle_rounded
                            : Icons.pending_actions_rounded,
                        color: isPaid ? AppColors.success : AppColors.warning,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPaid ? 'Rent Paid' : 'Dues Pending',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color:
                              isPaid ? AppColors.success : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isPaid ? 'Cleared' : 'Due: ${rental.dueDate}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color:
                            isPaid ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isPaid
                    ? formatRupees(rental.monthlyRent)
                    : formatRupees(rental.dueAmount),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color:
                      isPaid ? AppColors.success : AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isPaid
                    ? 'Payment cleared on ${rental.lastPaidDate}. Thank you!'
                    : 'Rent due for November 2026. Please pay on or before ${rental.dueDate}.',
                style: TextStyle(
                  color: isPaid ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (!isPaid) ...[
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      RentalService.markAsPaid();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Payment of ₹18,000 completed successfully!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment, size: 20),
                    label: const Text('Pay Rent Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Leased Property Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderOf(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 12),
              _row(context, Icons.apartment_rounded, 'Property',
                  rental.propertyTitle),
              Divider(height: 18, color: AppColors.borderOf(context)),
              _row(context, Icons.location_on_outlined, 'Address',
                  rental.propertyAddress),
              Divider(height: 18, color: AppColors.borderOf(context)),
              _row(context, Icons.calendar_month_outlined, 'Lease Tenure',
                  rental.leasePeriod),
              Divider(height: 18, color: AppColors.borderOf(context)),
              _row(context, Icons.person_outline, 'Landlord',
                  rental.landlordName),
              Divider(height: 18, color: AppColors.borderOf(context)),
              _row(context, Icons.currency_rupee, 'Monthly Rent',
                  formatRupees(rental.monthlyRent)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondaryOf(context)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryOf(context))),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryOf(context))),
            ],
          ),
        ),
      ],
    );
  }
}
