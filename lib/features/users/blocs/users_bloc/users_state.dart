part of 'users_bloc.dart';

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UserSignOutLoading extends UsersState {}

final class UsersFailure extends UsersState {}

final class UsersNetworkFailure extends UsersState {}

final class UserNotFound extends UsersState {}

final class UserWithoutDirections extends UsersState {}

final class UserSuccess extends UsersState {
  final UserData user;

  const UserSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class UsersSuccess extends UsersState {
  final List<UserData> users;
  final List<UserData> friends;
  final UserData currentUser;

  const UsersSuccess({
    required this.users,
    required this.friends,
    required this.currentUser,
  });

  @override
  List<Object> get props => [users, friends, currentUser];
}

final class UserFriendRequestsSuccess extends UsersState {
  final List<FriendRequest> requests;

  const UserFriendRequestsSuccess({required this.requests});

  @override
  List<Object> get props => [requests];
}
