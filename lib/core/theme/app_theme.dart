import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final seed = Colors.indigo;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
      scaffoldBackgroundColor: const Color(0xFFF4F7FF),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
