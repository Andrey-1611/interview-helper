part of 'settings_cubit.dart';

class SettingsCState extends Equatable {
  final bool theme;
  final bool voice;
  final bool language;
  final bool notifications;

  const SettingsCState({
    this.theme = true,
    this.voice = true,
    this.language = true,
    this.notifications = true,
  });

  SettingsCState copyWith({
    bool? theme,
    bool? voice,
    bool? language,
    bool? notifications,
  }) {
    return SettingsCState(
      theme: theme ?? this.theme,
      voice: voice ?? this.voice,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [theme, voice, language, notifications];
}
