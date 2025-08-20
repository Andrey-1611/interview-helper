part of 'watch_email_verified_bloc.dart';

sealed class WatchEmailVerifiedState extends Equatable {
  const WatchEmailVerifiedState();

  @override
  List<Object> get props => [];
}

final class WatchEmailVerifiedInitial extends WatchEmailVerifiedState {}

final class WatchEmailVerifiedLoading extends WatchEmailVerifiedState {}

final class WatchEmailVerifiedFailure extends WatchEmailVerifiedState {}

final class WatchEmailVerifiedSuccess extends WatchEmailVerifiedState {
  final MyUser user;

  const WatchEmailVerifiedSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
