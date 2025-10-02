part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ChangePassword extends ChangePasswordEvent {
  final String email;

  const ChangePassword({required this.email});

  @override
  List<Object?> get props => [email];
}
