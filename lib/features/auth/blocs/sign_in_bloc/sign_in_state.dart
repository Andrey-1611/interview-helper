part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInNetworkFailure extends SignInState {}

final class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class SignInNoVerification extends SignInState {}

final class SignInSuccess extends SignInState {
  final MyUser user;

  const SignInSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
