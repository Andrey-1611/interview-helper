part of 'send_email_verification_bloc.dart';

sealed class SendEmailVerificationState extends Equatable {
  const SendEmailVerificationState();

  @override
  List<Object> get props => [];
}

final class SendEmailVerificationInitial extends SendEmailVerificationState {}

final class SendEmailVerificationLoading extends SendEmailVerificationState {}

final class SendEmailVerificationFailure extends SendEmailVerificationState {}

final class SendEmailVerificationSuccess extends SendEmailVerificationState {}
