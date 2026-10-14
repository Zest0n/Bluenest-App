import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import 'welcome_screen.dart';

/// Placeholder - we'll replace this with the real tenant / landlord dashboards.
class HomeScreen extends StatelessWidget {
  final String role;
  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${role[0].toUpperCase()}${role.substring(1)} Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await TokenStorage.clear();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: Center(child: Text('Logged in as $role 🎉')),
    );
  }
}
