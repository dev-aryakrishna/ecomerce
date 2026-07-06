import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomerceapp/core/constants/storage_key.dart';

abstract class LocalStorageService {
  Future<void> saveLanguage(String language);
  Future<String?> getLanguage();

  Future<void> saveThemeMode(String themeMode);
  Future<String?> getThemeMode();

  Future<void> saveNotificationsEnabled(bool enabled);
  bool getNotificationsEnabled();
}

class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences prefs;

  LocalStorageServiceImpl(this.prefs);

  @override
  Future<void> saveLanguage(String language) async =>
      prefs.setString(StorageKey.language, language);

  @override
  Future<String?> getLanguage() async =>
      prefs.getString(StorageKey.language);

  @override
  Future<void> saveThemeMode(String themeMode) async =>
      prefs.setString(StorageKey.themeMode, themeMode);

  @override
  Future<String?> getThemeMode() async =>
      prefs.getString(StorageKey.themeMode);

  @override
  Future<void> saveNotificationsEnabled(bool enabled) async =>
      prefs.setBool(StorageKey.notificationsEnabled, enabled);

  @override
  bool getNotificationsEnabled() =>
      prefs.getBool(StorageKey.notificationsEnabled) ?? true;
}