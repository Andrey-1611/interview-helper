part of 'check_email_verified_bloc.dart';

sealed class CheckEmailVerifiedEvent extends Equatable {
  const CheckEmailVerifiedEvent();

  @override
  List<Object?> get props => [];
}

final class CheckEmailVerified extends CheckEmailVerifiedEvent {}