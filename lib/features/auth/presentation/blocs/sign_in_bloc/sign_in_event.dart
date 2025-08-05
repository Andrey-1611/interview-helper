part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

final class SignIn extends SignInEvent {
  final UserProfile userProfile;
  final String password;

  const SignIn({required this.userProfile, required this.password});

  @override
  List<Object?> get props => [userProfile, password];
}
