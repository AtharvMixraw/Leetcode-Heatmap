import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/screens/splash_screen.dart';

class LeetCodeTrackerApp extends StatelessWidget {
  const LeetCodeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeetCode Tracker',
      theme: appTheme,
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}