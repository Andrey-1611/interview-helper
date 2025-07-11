part of 'sign_out_bloc.dart';

sealed class SignOutState extends Equatable {
  const SignOutState();

  @override
  List<Object> get props => [];
}

final class SignOutInitial extends SignOutState {}

final class SignOuLoading extends SignOutState {}

final class SignOutFailure extends SignOutState {}

final class SignOutSuccess extends SignOutState {}
