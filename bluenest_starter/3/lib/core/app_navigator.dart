import 'package:flutter/material.dart';
import '../screens/landlord/landlord_dashboard_screen.dart';
import '../screens/tenant/tenant_dashboard_screen.dart';
import '../screens/welcome_screen.dart';
import '../services/token_storage.dart';

/// One place for navigation so screens don't need to know about each other.
class AppNavigator {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  /// After a successful login: clears the stack and opens the role's dashboard.
  static void goToDashboard(BuildContext context, String role) {
    final Widget page = role == 'landlord'
        ? const LandlordDashboardScreen()
        : const TenantDashboardScreen();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  static Future<void> logout(BuildContext context) async {
    await TokenStorage.clear();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }
}
