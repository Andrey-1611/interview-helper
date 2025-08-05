part of 'is_email_verified_bloc.dart';

sealed class IsEmailVerifiedState extends Equatable {
  const IsEmailVerifiedState();

  @override
  List<Object> get props => [];
}

final class IsEmailVerifiedInitial extends IsEmailVerifiedState {}

final class IsEmailVerifiedLoading extends IsEmailVerifiedState {}

final class IsEmailVerifiedFailure extends IsEmailVerifiedState {
  final String e;

  const IsEmailVerifiedFailure(this.e);
}

final class IsEmailNotVerified extends IsEmailVerifiedState {}

final class IsEmailVerifiedSuccess extends IsEmailVerifiedState {
  final EmailVerificationResult result;

  const IsEmailVerifiedSuccess({required this.result});

  @override
  List<Object> get props => [result];
}
