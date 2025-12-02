import 'package:injectable/injectable.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SettingsRepository)
class SettingsDataSource implements SettingsRepository {
  final SharedPreferences _sharedPreferences;

  SettingsDataSource(this._sharedPreferences);

  static const _themeKey = 'theme_key';
  static const _voiceKey = 'voice_key';
  static const _languageKey = 'languageKey';

  @override
  Future<void> setTheme(bool isDark) async {
    await _sharedPreferences.setBool(_themeKey, isDark);
  }

  @override
  Future<void> setVoice(bool isEnable) async {
    await _sharedPreferences.setBool(_voiceKey, isEnable);
  }

  @override
  Future<void> setLanguage(bool isRussian) async {
    await _sharedPreferences.setBool(_languageKey, isRussian);
  }

  @override
  bool isDarkTheme() {
    final theme = _sharedPreferences.getBool(_themeKey);
    return theme ?? true;
  }

  @override
  bool isVoiceEnable() {
    final voice = _sharedPreferences.getBool(_voiceKey);
    return voice ?? true;
  }

  @override
  bool? isRussianLanguage() {
    return _sharedPreferences.getBool(_languageKey);
  }
}
