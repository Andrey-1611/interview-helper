part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpNetworkFailure extends SignUpState {}

final class SignUpFailure extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final UserData user;

  const SignUpSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
