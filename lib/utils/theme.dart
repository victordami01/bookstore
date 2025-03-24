import 'package:flutter/material.dart';

// 🎨 App Colors
class AppColors {
  static const primary = Color(0xFF6B4CE6); // Primary Color
  static const bgPrimary = Color(0xFF285AF9); // Background Primary Color
  static const borderCard = Color(0xFFE0E2E7); // Border & Card Color
  static const primaryText = Color(0xFF000000); // Primary Text & Icon
  static const secondaryText = Color(0xFF797D81); // Secondary Text & Icon
  static const tertiary = Color(0xFFFFFFFF); // Tertiary Color
  static const alertHighlight = Color(0xFFFF4800); // Alert & Highlight
  static const successHighlight = Color(0xFF00FF00); // Successful & Highlights
}

// 🔤 Text Styles
class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    fontFamily: 'Poppins',
  );

  static const subHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    fontFamily: 'Poppins',
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.primaryText,
    fontFamily: 'Poppins',
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Poppins',
  );

  static const caption = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
    fontFamily: 'Poppins',
  );
}

// 🏗️ Theme Configuration
ThemeData appTheme = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.bgPrimary,
  textTheme: const TextTheme(
    titleLarge: AppTextStyles.heading,
    bodyMedium: AppTextStyles.body,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      textStyle: AppTextStyles.button,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderCard),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    hintStyle: AppTextStyles.caption,
  ),
);