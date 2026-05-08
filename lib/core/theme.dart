import 'package:flutter/material.dart';

class AppColors {
  static const midnight = Color(0xFF070A12);
  static const nightBlue = Color(0xFF101A33);
  static const blood = Color(0xFF8F1D2C);
  static const crimson = Color(0xFFE2384F);
  static const gold = Color(0xFFE4B85A);
  static const mist = Color(0xFFB7C0D8);
  static const ash = Color(0xFF6F7890);
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.midnight,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.crimson,
        surface: Color(0xFF111827),
        onSurface: Color(0xFFF4F0E8),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFF4F0E8),
        displayColor: const Color(0xFFF4F0E8),
      ),
      cardTheme: CardTheme(
        color: const Color(0xCC111827),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blood,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
