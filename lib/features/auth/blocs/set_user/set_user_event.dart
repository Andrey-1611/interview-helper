part of 'set_user_bloc.dart';

sealed class SetUserEvent extends Equatable {
  const SetUserEvent();

  @override
  List<Object?> get props => [];
}

final class SetUser extends SetUserEvent {
  final UserProfile userProfile;

  const SetUser({required this.userProfile});

  @override
  List<Object?> get props => [];
}