part of 'check_current_user_bloc.dart';

sealed class CheckCurrentUserState extends Equatable {
  const CheckCurrentUserState();

  @override
  List<Object> get props => [];
}

final class CheckCurrentUserInitial extends CheckCurrentUserState {}

final class CheckCurrentUserFailure extends CheckCurrentUserState {}

final class CheckCurrentUserNotExists extends CheckCurrentUserState {}

final class CheckCurrentUserExists extends CheckCurrentUserState {
  final UserProfile userProfile;

  const CheckCurrentUserExists({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}
