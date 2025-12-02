import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/utils/device_info.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsCState> {
  final SettingsRepository _settingsRepository;
  final DeviceInfo _deviceInfo;

  SettingsCubit(this._settingsRepository, this._deviceInfo)
    : super(SettingsCState());

  Future<void> setSettings() async {
    final theme = _settingsRepository.isDarkTheme();
    final voice = _settingsRepository.isVoiceEnable();
    final language = _settingsRepository.isRussianLanguage();
    if (language == null) {
      final newLanguage = await _deviceInfo.getLanguage();
      await _settingsRepository.setLanguage(newLanguage);
      emit(SettingsCState(theme: theme, voice: voice, language: newLanguage));
    } else {
      emit(SettingsCState(theme: theme, voice: voice, language: language));
    }
  }

  Future<void> setTheme(bool isDark) async {
    await _settingsRepository.setTheme(isDark);
    emit(state.copyWith(theme: isDark));
  }

  Future<void> setVoice(bool isVoiceEnable) async {
    await _settingsRepository.setVoice(isVoiceEnable);
    emit(state.copyWith(voice: isVoiceEnable));
  }

  Future<void> setLanguage(bool isRussian) async {
    await _settingsRepository.setLanguage(isRussian);
    emit(state.copyWith(language: isRussian));
  }
}
