part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

final class SignIn extends SignInEvent {
  final MyUser user;
  final String password;

  const SignIn({required this.user, required this.password});

  @override
  List<Object?> get props => [user, password];
}
