import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primaryBlue,
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 159, 177, 213),
    elevation: 1,
    iconTheme: IconThemeData(color: AppColors.black),
    titleTextStyle: TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightBlue,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.borderGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.greyText),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: const BorderSide(color: AppColors.primaryBlue),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.primaryBlue,
    contentTextStyle: const TextStyle(color: AppColors.white),
  ),
);
