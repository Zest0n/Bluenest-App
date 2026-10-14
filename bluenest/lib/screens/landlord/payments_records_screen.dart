import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/format.dart';

/// Screen 10 (landlord): Payments / Rent Records
class PaymentsRecordsScreen extends StatefulWidget {
  const PaymentsRecordsScreen({super.key});

  @override
  State<PaymentsRecordsScreen> createState() => _PaymentsRecordsScreenState();
}

class _PaymentsRecordsScreenState extends State<PaymentsRecordsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Paid, 2: Pending

  final List<Map<String, dynamic>> _records = [
    {
      'property': 'Luxury 3 BHK Apartment',
      'unit': 'Flat 402, Indiranagar',
      'tenant': 'Vasu Tenant',
      'amount': 18000,
      'date': '01 Nov 2026',
      'status': 'pending',
    },
    {
      'property': 'Modern 2 BHK Flat',
      'unit': 'Flat 204, Marathahalli',
      'tenant': 'Rahul Sharma',
      'amount': 28000,
      'date': '10 Oct 2026',
      'status': 'paid',
    },
    {
      'property': 'Cozy 1 BHK Studio',
      'unit': 'Studio 101, Koramangala',
      'tenant': 'Ananya Roy',
      'amount': 17000,
      'date': '05 Oct 2026',
      'status': 'paid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _records.where((r) {
      if (_selectedFilter == 1) return r['status'] == 'paid';
      if (_selectedFilter == 2) return r['status'] == 'pending';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text(
          'Payment & Rent Records',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              // Summary Banner
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderOf(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Collected',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryOf(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatRupees(45000),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderOf(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending Dues',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryOf(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatRupees(18000),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  for (int i = 0; i < 3; i++) ...[
                    ChoiceChip(
                      label: Text(['All (3)', 'Paid (2)', 'Pending (1)'][i]),
                      selected: _selectedFilter == i,
                      selectedColor: AppColors.primarySoftOf(context),
                      labelStyle: TextStyle(
                        color: _selectedFilter == i
                            ? AppColors.primary
                            : AppColors.textSecondaryOf(context),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      onSelected: (_) => setState(() => _selectedFilter = i),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Records List
              for (final record in filtered) ...[
                _buildRecordItem(context, record),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordItem(BuildContext context, Map<String, dynamic> r) {
    final isPaid = r['status'] == 'paid';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPaid ? AppColors.successBg : AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPaid
                  ? Icons.check_circle_rounded
                  : Icons.pending_actions_rounded,
              color: isPaid ? AppColors.success : AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r['property'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${r['unit']} • Tenant: ${r['tenant']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPaid ? 'Paid on ${r['date']}' : 'Due on ${r['date']}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatRupees(r['amount']),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isPaid
                  ? AppColors.textPrimaryOf(context)
                  : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
