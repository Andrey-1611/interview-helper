abstract interface class SettingsRepository {
  Future<void> setTheme(bool isDark);

  Future<void> setVoice(bool isEnable);

  Future<void> setLanguage(bool isRussian);

  Future<void> setAuth(bool isAuth);

  bool isDarkTheme();

  bool isVoiceEnable();

  bool? isRussianLanguage();

  bool isAuth();
}
