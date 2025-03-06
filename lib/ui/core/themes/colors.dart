// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Base colors
  static const black = Color(0xFF101010);
  static const white = Color(0xFFFFF7FA);
  static const grey100 = Color(0xFFF2F2F2);
  static const grey500 = Color(0xFFA4A4A4);
  static const grey800 = Color(0xFF4D4D4D);

  // Accent colors
  static const orange = Color(0xFFF39C12);
  static const green = Color(0xFF2ECC71);
  static const blue = Color(0xFF3498DB);
  static const purple = Color(0xFF9B59B6);
  static const red = Color(0xFFE74C3C);

  // Transparent colors
  static const whiteTransparent = Color(0x4DFFFFFF);
  static const blackTransparent = Color(0x4D000000);

  // Light theme
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: black,
    onPrimary: white,
    secondary: blue,
    onSecondary: white,
    tertiary: purple,
    onTertiary: white,
    error: red,
    onError: white,
    surface: white,
    onSurface: black,
    surfaceContainerHighest: grey100,
    onSurfaceVariant: grey800,
    outline: grey500,
    outlineVariant: grey100,
    shadow: blackTransparent,
    scrim: blackTransparent,
    inverseSurface: black,
    onInverseSurface: white,
    inversePrimary: white,
  );

  // Dark theme
  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: white,
    onPrimary: black,
    secondary: blue.withAlpha(204),
    onSecondary: white,
    tertiary: purple.withAlpha(204),
    onTertiary: white,
    error: red.withAlpha(230),
    onError: white,
    surface: Color(0xFF1E1E1E),
    onSurface: white,
    surfaceContainerHighest: black,
    onSurfaceVariant: grey100,
    outline: grey500,
    outlineVariant: grey800,
    shadow: blackTransparent,
    scrim: blackTransparent,
    inverseSurface: white,
    onInverseSurface: black,
    inversePrimary: black,
  );

  // Action colors
  static final actionColors = {
    'send': orange,
    'receive': green,
    'scan': blue,
  };
}
