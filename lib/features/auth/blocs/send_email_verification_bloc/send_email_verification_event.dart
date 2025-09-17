part of 'send_email_verification_bloc.dart';

sealed class SendEmailVerificationEvent extends Equatable {
  const SendEmailVerificationEvent();

  @override
  List<Object?> get props => [];
}

final class SendEmailVerification extends SendEmailVerificationEvent {}