part of 'check_email_verified_bloc.dart';

sealed class CheckEmailVerifiedState extends Equatable {
  const CheckEmailVerifiedState();

  @override
  List<Object> get props => [];
}

final class CheckEmailVerifiedInitial extends CheckEmailVerifiedState {}

final class CheckEmailVerifiedLoading extends CheckEmailVerifiedState {}

final class CheckEmailVerifiedFailure extends CheckEmailVerifiedState {}

final class CheckEmailNotVerified extends CheckEmailVerifiedState {}

final class CheckEmailVerifiedSuccess extends CheckEmailVerifiedState {
  final EmailVerificationResult? result;

  const CheckEmailVerifiedSuccess({required this.result});

  @override
  List<Object> get props => [?result];
}
