import 'package:flutter/material.dart';

// A class to hold all the color constants for the app.
// This follows the "Modern & Minimalist" palette.
class AppColors {
  // Private constructor to prevent instantiation.
  AppColors._();

  // --- Primary Palette ---
  static const Color primary = Color.fromRGBO(0, 121, 107, 1); // Deep Teal
  static const Color background = Color(0xFFFCFCFC); // Clean Off-White
  static const Color text = Color(0xFF333333); // Near Black
  static const Color subtleUi = Color(0xFFE0E0E0); // Soft Gray for borders/dividers

  // --- Dark Theme Palette ---
  static const Color darkBackground = Color(0xFF1A1A1A); // Deep, dark gray
  static const Color darkSurface = Color(0xFF2C2C2C); // Slightly lighter gray for cards/surfaces
  static const Color darkText = Color(0xFFF5F5F5); // Clean Off-White for text

  // --- Semantic Colors ---
  static const Color error = Color(0xFFD32F2F); // Standard error red
  static const Color success = Color(0xFF388E3C); // Standard success green

  // --- Neutral Colors ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
