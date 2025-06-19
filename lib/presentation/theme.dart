import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1976D2), // Mavi ana renk
      scaffoldBackgroundColor: const Color(0xFFE3F2FD), // Çok açık mavi
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF64B5F6),
        background: const Color(0xFFE3F2FD), // Çok açık mavi
        error: Colors.redAccent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF1976D2),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(0xFF222B45), fontSize: 18),
        bodyMedium: TextStyle(color: Color(0xFF222B45), fontSize: 16),
      ),
    );
  }
}
