import 'package:interview_master/core/constants/shared_prefs_data.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDataSource implements SettingsRepository {
  final SharedPreferences _sharedPreferences;

  SettingsDataSource(this._sharedPreferences);

  @override
  Future<void> setTheme(bool isDark) async {
    await _sharedPreferences.setBool(SharedPrefsData.themeKey, isDark);
  }

  @override
  Future<void> setVoice(bool isEnable) async {
    await _sharedPreferences.setBool(SharedPrefsData.voiceKey, isEnable);
  }

  @override
  Future<void> setLanguage(bool isRussian) async {
    await _sharedPreferences.setBool(SharedPrefsData.languageKey, isRussian);
  }

  @override
  bool isDarkTheme() {
    final theme = _sharedPreferences.getBool(SharedPrefsData.themeKey);
    return theme ?? true;
  }

  @override
  bool isVoiceEnable() {
    final voice = _sharedPreferences.getBool(SharedPrefsData.voiceKey);
    return voice ?? true;
  }

  @override
  bool? isRussianLanguage() {
    return _sharedPreferences.getBool(SharedPrefsData.languageKey);
  }

  @override
  bool isAuth() => _sharedPreferences.getBool(SharedPrefsData.authKey) ?? false;

  @override
  Future<void> setAuth(bool isAuth) async {
    await _sharedPreferences.setBool(SharedPrefsData.authKey, isAuth);
  }
}
