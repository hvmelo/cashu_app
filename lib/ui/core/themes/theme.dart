import 'package:flutter/material.dart';

import 'colors.dart';

abstract final class AppTheme {
  static final _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey500,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.grey500,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.grey500,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      // grey500 works for both light and dark themes
      color: AppColors.grey500,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    useMaterial3: true,
  );
}
