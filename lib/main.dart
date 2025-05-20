// lib/main.dart
import 'package:flutter/material.dart';
import 'package:leetcode_heatmap/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeetCode Heatmap',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple[300]!,
          secondary: Colors.deepPurpleAccent[200]!,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}