part of 'is_email_verified_bloc.dart';

sealed class IsEmailVerifiedEvent extends Equatable {
  const IsEmailVerifiedEvent();

  @override
  List<Object?> get props => [];
}

final class IsEmailVerified extends IsEmailVerifiedEvent {}
