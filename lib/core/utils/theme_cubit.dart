import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';

class ThemeCubit extends Cubit<bool> {
  final SettingsRepository _settingsRepository;

  ThemeCubit(this._settingsRepository)
    : super(_settingsRepository.isDarkTheme());

  Future<void> changeTheme() async {
    await _settingsRepository.setTheme(!state);
    return emit(!state);
  }
}
