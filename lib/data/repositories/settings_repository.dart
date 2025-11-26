abstract interface class SettingsRepository {
  bool isDarkTheme();

  Future<void> setTheme(bool isDark);

  bool isVoiceEnable();

  Future<void> setVoice(bool isEnable);
}
