import 'package:flutter/material.dart';
import '../screens/landlord/landlord_dashboard_screen.dart';
import '../screens/tenant/tenant_dashboard_screen.dart';
import '../screens/welcome_screen.dart';
import '../services/token_storage.dart';
import 'dev_config.dart';

/// One place for navigation so screens don't need to know about each other.
class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static bool _expiring = false;

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

  /// Called by ApiService when a protected call returns 401
  /// (access token expired - tokens last ~15 min).
  static Future<void> sessionExpired() async {
    if (DevConfig.bypassLogin) return;
    if (_expiring) return;
    _expiring = true;
    await TokenStorage.clear();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
    messengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('Session expired. Please log in again.')),
    );
    _expiring = false;
  }
}
