part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ChangePassword extends ChangePasswordEvent {
  final String password;

  const ChangePassword({required this.password});

  @override
  List<Object?> get props => [password];
}