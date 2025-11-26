part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsFailure extends SettingsState {}

final class SettingsNetworkFailure extends SettingsState {}

final class SettingsSuccess extends SettingsState {
  final bool voice;

  const SettingsSuccess({required this.voice});

  @override
  List<Object> get props => [voice];
}

final class SignOutSuccess extends SettingsState {}

final class RuStoreSuccess extends SettingsState {}
