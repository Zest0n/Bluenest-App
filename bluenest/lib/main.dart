import 'package:flutter/material.dart';
import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const BlueNestApp());

class BlueNestApp extends StatelessWidget {
  const BlueNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueNest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: AppNavigator.navigatorKey,
      scaffoldMessengerKey: AppNavigator.messengerKey,
      home: const WelcomeScreen(),
    );
  }
}
