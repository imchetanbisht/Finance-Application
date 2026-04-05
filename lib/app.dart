import 'package:fintrack/splash_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinTrack Pro',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}