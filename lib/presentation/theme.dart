import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Modern renk paleti
  static const Color primaryColor = Color(0xFF6366F1); // Modern indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Modern purple
  static const Color accentColor = Color(0xFF06B6D4); // Modern cyan
  static const Color successColor = Color(0xFF10B981); // Modern emerald
  static const Color warningColor = Color(0xFFF59E0B); // Modern amber
  static const Color errorColor = Color(0xFFEF4444); // Modern red

  // Gradient renkleri
  static const List<Color> primaryGradient = [primaryColor, secondaryColor];
  static const List<Color> successGradient = [successColor, Color(0xFF34D399)];
  static const List<Color> warningGradient = [warningColor, Color(0xFFFBBF24)];
  static const List<Color> errorGradient = [errorColor, Color(0xFFF87171)];

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Modern light gray
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1E293B)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        background: const Color(0xFFF8FAFC),
        surface: Colors.white,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: const Color(0xFF1E293B),
        onSurface: const Color(0xFF1E293B),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF334155),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF475569),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF64748B), size: 24),
    );
  }

  // Modern gradient container widget'ı
  static Widget gradientContainer({
    required List<Color> colors,
    required Widget child,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }

  // Modern card widget'ı
  static Widget modernCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
