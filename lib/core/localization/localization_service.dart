import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomerceapp/core/constants/storage_key.dart';

class LocalizationService extends ChangeNotifier {
  final SharedPreferences _prefs;

  LocalizationService(this._prefs);

  Locale get currentLocale {
    final code = _prefs.getString(StorageKey.language) ?? 'en';
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(StorageKey.language, locale.languageCode);
    notifyListeners();
  }

  static const supportedLocales = [
    Locale('en'),
    Locale('es'),
  ];
}