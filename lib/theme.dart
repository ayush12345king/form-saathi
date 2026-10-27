import 'package:flutter/material.dart';

/// All app colours in one place. Change them here to restyle the whole app.
class AppColors {
  static const ink = Color(0xFF1B2340); // main dark blue
  static const paper = Color(0xFFF6F4EE); // page background
  static const marigold = Color(0xFFF2B33D); // accent / main buttons
  static const line = Color(0xFFE3DFD3); // card borders
  static const muted = Color(0xFF5A6070); // secondary text
  static const green = Color(0xFF1E7A4C);
  static const greenBg = Color(0xFFE5F3EA);
  static const greenText = Color(0xFF145A36);
  static const amberBg = Color(0xFFFFF4DC);
  static const amberText = Color(0xFF6B4600);
  static const orange = Color(0xFFC2410C);
  static const orangeBg = Color(0xFFFDE8DA);
  static const orangeText = Color(0xFF7A2E04);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.ink,
    primary: AppColors.ink,
    secondary: AppColors.marigold,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.paper,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.paper,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.marigold,
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.line),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
