import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomerceapp/core/constants/storage_key.dart';

class ThemeService extends ChangeNotifier {
  final SharedPreferences _prefs;

  ThemeService(this._prefs);

  ThemeMode get currentThemeMode {
    final saved = _prefs.getString(StorageKey.themeMode) ?? 'system';
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      default:
        value = 'system';
    }
    await _prefs.setString(StorageKey.themeMode, value);
    notifyListeners();
  }
}