import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Modern renk paleti
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color accentColor = Color(0xFF38BDF8); // Soft Blue
  static const Color successColor = Color(0xFF22C55E); // Green
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color warningColor = Color(0xFFFACC15); // Yellow
  static const Color backgroundLight = Color(0xFFF4F6FB); // Soft BG
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color surfaceColor = Color(0xFFF1F5F9); // Light Surface
  static const Color textColor = Color(0xFF22223B); // Dark Blue-Gray
  static const Color textSecondary = Color(0xFF64748B); // Soft Gray

  // Gradient renkleri
  static const List<Color> primaryGradient = [primaryColor, accentColor];
  static const List<Color> successGradient = [successColor, Color(0xFF34D399)];
  static const List<Color> warningGradient = [warningColor, Color(0xFFFBBF24)];
  static const List<Color> errorGradient = [errorColor, Color(0xFFF87171)];

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Inter',
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundLight,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textColor,
      onSurface: textColor,
      error: errorColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.04),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: textSecondary, fontSize: 16),
    ),
    dividerColor: const Color(0xFFE2E8F0),
    iconTheme: const IconThemeData(color: textSecondary),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: surfaceColor,
      thumbColor: primaryColor,
      overlayColor: primaryColor.withOpacity(0.1),
      valueIndicatorColor: primaryColor,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

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
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Card(
      color: backgroundColor ?? cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
