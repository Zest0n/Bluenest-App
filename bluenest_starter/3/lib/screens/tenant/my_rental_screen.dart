import 'package:flutter/material.dart';
import '../../widgets/screen_placeholder.dart';

/// Screen 6 (tenant): My Rental & Rent Dues
class MyRentalScreen extends StatelessWidget {
  const MyRentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Rental & Rent Dues')),
      body: const ScreenPlaceholder(
        icon: Icons.receipt_long_rounded,
        title: 'My Rental & Rent Dues',
      ),
    );
  }
}
