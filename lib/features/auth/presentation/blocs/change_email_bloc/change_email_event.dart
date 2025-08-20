part of 'change_email_bloc.dart';

sealed class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}

final class ChangeEmail extends ChangeEmailEvent {
  final String email;
  final String password;

  const ChangeEmail({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
