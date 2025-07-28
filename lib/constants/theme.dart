import 'package:docu_sync/constants/colors.dart';
import 'package:flutter/material.dart'; 

class AppTheme {
  AppTheme._();

  //========= LIGHT THEME =========//
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto', // Or your preferred font

    // Define the color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary, // Often the same as primary
      surface: AppColors.background,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.white, // Text on primary color
      onSecondary: AppColors.white,
      onSurface: AppColors.text, // Text on surface color
      onBackground: AppColors.text,
      onError: AppColors.white,
    ),

    // Define text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text, height: 1.5), // Main text style for editor
    ),

    // Define AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text, // Color for icons and title
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.text),
    ),

    // Define button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.subtleUi),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),

    // Define input decoration theme for text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.text),
    ),

    // Define card theme
    cardTheme: CardTheme(
      elevation: 1,
      color: AppColors.white, // Cards can be slightly whiter than background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.subtleUi),
      ),
    ),
  );


  //========= DARK THEME =========//
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Roboto', // Or your preferred font

    // Define the color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkText,
      onBackground: AppColors.darkText,
      onError: AppColors.white,
    ),

    // Define text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText, height: 1.5), // Main text style for editor
    ),

    // Define AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
    ),

    // Define button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: Colors.grey.shade800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    
    // Define input decoration theme for text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.darkText),
    ),

    // Define card theme
    cardTheme: CardTheme(
      elevation: 0,
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}