// lib/main.dart
// Ponto de entrada do app CookEasy CRUD

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CookEasyApp());
}

class CookEasyApp extends StatelessWidget {
  const CookEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookEasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A1A),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F5F2),
      ),
      home: const HomeScreen(),
    );
  }
}
