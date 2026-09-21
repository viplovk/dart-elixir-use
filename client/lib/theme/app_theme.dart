import 'package:flutter/material.dart';

class AppTheme {
  // Deep charcoal tactical palette
  static const Color background = Color(0xFF0F1115);
  static const Color surface = Color(0xFF16191E);
  static const Color surfaceElevated = Color(0xFF1E2229);
  static const Color border = Color(0xFF262C36);
  static const Color borderSubtle = Color(0xFF1F242C);

  // Tactical accent colors
  static const Color primaryNeon = Color(0xFF00FF9D); // Terminal green (Ready/Online)
  static const Color transmitCyan = Color(0xFF00E5FF); // Transmitting / Active Voice
  static const Color alertAmber = Color(0xFFFFB800); // Warning / Expiration
  static const Color dangerRed = Color(0xFFFF3366); // Muted / Disconnected

  // Text
  static const Color textPrimary = Color(0xFFF0F3F6);
  static const Color textSecondary = Color(0xFF9BA3AF);
  static const Color textMuted = Color(0xFF5E6773);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primaryNeon,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: transmitCyan,
        surface: surface,
        error: dangerRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'monospace',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: textSecondary,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textMuted,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
