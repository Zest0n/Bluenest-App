import 'package:flutter/material.dart';
import '../../widgets/screen_placeholder.dart';

/// Screen 10 (landlord): Payments / Rent Records
class PaymentsRecordsScreen extends StatelessWidget {
  const PaymentsRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments / Rent Records')),
      body: const ScreenPlaceholder(
        icon: Icons.payments_rounded,
        title: 'Payments / Rent Records',
      ),
    );
  }
}
