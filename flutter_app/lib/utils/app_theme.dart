import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A1A2E);
  static const Color secondary = Color(0xFF16213E);
  static const Color accent = Color(0xFF0F3460);
  static const Color highlight = Color(0xFFE94560);
  static const Color gold = Color(0xFFF5A623);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF8A8A9A);
  static const Color textLight = Color(0xFFB0B0C0);
  static const Color divider = Color(0xFFEEEEF5);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'SF Pro Display',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: const TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Display'),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13, fontFamily: 'SF Pro Display'),
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14, fontFamily: 'SF Pro Display'),
      ),
    );
  }
}
