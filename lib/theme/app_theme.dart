import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const brown = Color(0xFF805B40);
  static const sand = Color(0xFFD7B99B);
  static const cream = Color(0xFFF7F1EB);
  static const ink = Color(0xFF352B25);
  static const muted = Color(0xFF75685E);
  static const border = Color(0xFFE7DDD3);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brown,
      brightness: Brightness.light,
    ).copyWith(primary: brown, surface: Colors.white, onSurface: ink),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: ink,
      ),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFCFAF8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      prefixIconColor: muted,
      hintStyle: const TextStyle(color: muted, fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: brown, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
