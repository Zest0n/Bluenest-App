import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const BlueNestApp());

class BlueNestApp extends StatelessWidget {
  const BlueNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}
