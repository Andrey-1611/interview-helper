part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

final class SignUp extends SignUpEvent {
  final MyUser myUser;
  final String password;

  const SignUp({required this.myUser, required this.password});

  @override
  List<Object?> get props => [myUser, password];
}