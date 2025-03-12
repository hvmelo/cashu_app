import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashu_app/config/app_config.dart';

part 'core_providers.g.dart';

// Notifier to control the app theme
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

@Riverpod(keepAlive: true)
SharedPreferences? sharedPreferences(Ref ref) {
  return null;
}

@Riverpod(keepAlive: true)
AppEnvironment environment(Ref ref) {
  return AppConfig.environment;
}
