import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/storage_service.dart';

/// Owns the app's current [ThemeMode] and persists the user's choice,
/// mirroring the existing language-persistence pattern in [StorageService].
class ThemeController extends GetxController {
  ThemeController({StorageService? storage})
    : _storage = storage ?? StorageService();

  final StorageService _storage;

  late final Rx<ThemeMode> themeMode = _modeFromString(
    _storage.getThemeMode(),
  ).obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.saveThemeMode(_modeToString(mode));
  }

  void toggleDarkMode(bool enabled) {
    setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  static ThemeMode _modeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  static String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}
