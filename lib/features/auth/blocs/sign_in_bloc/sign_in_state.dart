part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class SignInSuccess extends SignInState {
  final UserProfile userProfile;

  const SignInSuccess({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}
