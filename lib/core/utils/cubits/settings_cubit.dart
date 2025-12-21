import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/utils/services/device_service.dart';
import 'package:interview_master/core/utils/services/notifications_service.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsCState> {
  final SettingsRepository _settingsRepository;
  final DeviceService _deviceService;
  final NotificationsService _notificationsService;

  SettingsCubit(
    this._settingsRepository,
    this._deviceService,
    this._notificationsService,
  ) : super(SettingsCState());

  Future<void> setSettings() async {
    final theme = _settingsRepository.isDarkTheme();
    final voice = _settingsRepository.isVoiceEnable();
    final language = _settingsRepository.isRussianLanguage();
    final notifications = _settingsRepository.isNotificationsEnable();
    final bool finalLanguage = language ?? await _deviceService.getLanguage();
    final bool finalNotifications = notifications ?? true;

    if (language == null) await _settingsRepository.setLanguage(finalLanguage);
    if (notifications == null) {
      await _notificationsService.setupDailyNotification(finalLanguage);
    }
    emit(
      SettingsCState(
        theme: theme,
        voice: voice,
        language: finalLanguage,
        notifications: finalNotifications,
      ),
    );
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

  Future<void> setNotifications(bool isEnable) async {
    await _settingsRepository.setNotifications(isEnable);
    final language = _settingsRepository.isRussianLanguage();
    isEnable
        ? await _notificationsService.setupDailyNotification(language!)
        : _notificationsService.disableDailyNotification();
    emit(state.copyWith(notifications: isEnable));
  }
}
