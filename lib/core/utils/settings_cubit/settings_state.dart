part of 'settings_cubit.dart';

class SettingsCState extends Equatable {
  final bool theme;
  final bool voice;
  final bool language;

  const SettingsCState({
    this.theme = true,
    this.voice = true,
    this.language = true,
  });

  SettingsCState copyWith({
    bool? theme,
    bool? voice,
    bool? language,
  }) {
    return SettingsCState(
      theme: theme ?? this.theme,
      voice: voice ?? this.voice,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [theme, voice, language];
}
