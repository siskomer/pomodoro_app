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
      background: Color(0xFFF8FAFC), // Daha sıcak ve soft beyaz-gri
      surface: Color(0xFFF4F6FB), // Daha açık yüzey
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xFF1E293B), // Daha koyu ve kontrast
      onSurface: Color(0xFF334155), // Hafif koyu
      error: errorColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8FAFC),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF334155)),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        color: Color(0xFF1E293B),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E293B),
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF334155),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF334155),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF64748B),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF94A3B8),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.85), // Glassmorphism
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        elevation: 3,
        shadowColor: accentColor.withOpacity(0.12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
    ),
    dividerColor: const Color(0xFFE2E8F0),
    iconTheme: const IconThemeData(color: Color(0xFF94A3B8)),
    sliderTheme: SliderThemeData(
      activeTrackColor: accentColor,
      inactiveTrackColor: Color(0xFFE0E7EF),
      thumbColor: accentColor,
      overlayColor: accentColor.withOpacity(0.12),
      valueIndicatorColor: accentColor,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      background: Color(0xFF15161C), // Daha derin koyu
      surface: Color(0xFF232634),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xFFF4F6FB),
      onSurface: Color(0xFFF4F6FB),
      error: errorColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF15161C),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF15161C),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFFB6BDC9), // Daha soft gri
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8B93A6), // Soft ikincil
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8B93A6),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xCC232634), // Yarı saydam glassmorphism
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.black.withOpacity(0.18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        elevation: 3,
        shadowColor: accentColor.withOpacity(0.18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF232634).withOpacity(0.85),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: Color(0xFF8B93A6), fontSize: 16),
    ),
    dividerColor: const Color(0xFF232634),
    iconTheme: const IconThemeData(color: Color(0xFFB6BDC9)),
    sliderTheme: SliderThemeData(
      activeTrackColor: accentColor,
      inactiveTrackColor: const Color(0xFF232634),
      thumbColor: accentColor,
      overlayColor: accentColor.withOpacity(0.12),
      valueIndicatorColor: accentColor,
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
