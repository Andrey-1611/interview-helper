part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class GetSettings extends SettingsEvent {}

final class SignOut extends SettingsEvent {}

final class OpenAppInRuStore extends SettingsEvent {}

final class SetVoice extends SettingsEvent {
  final bool isEnable;

  const SetVoice({required this.isEnable});

  @override
  List<Object?> get props => [isEnable];
}

