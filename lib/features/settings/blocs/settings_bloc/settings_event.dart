part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SignOut extends SettingsEvent {}

final class OpenAppInRuStore extends SettingsEvent {}
