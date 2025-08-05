part of 'watch_email_verified_bloc.dart';

sealed class WatchEmailVerifiedEvent extends Equatable {
  const WatchEmailVerifiedEvent();

  @override
  List<Object?> get props => [];
}

final class WatchEmailVerified extends WatchEmailVerifiedEvent {}
