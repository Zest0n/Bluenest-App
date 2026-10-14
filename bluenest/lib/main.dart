import 'package:flutter/material.dart';
import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService.loadSavedProfile();
  runApp(const BlueNestApp());
}

class BlueNestApp extends StatelessWidget {
  const BlueNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'BlueNest',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentMode,
          navigatorKey: AppNavigator.navigatorKey,
          scaffoldMessengerKey: AppNavigator.messengerKey,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
