part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

final class GetUsers extends UsersEvent {}

final class GetUser extends UsersEvent {
  final UserData? user;

  const GetUser([this.user]);

  @override
  List<Object?> get props => [user];
}

final class GetCurrentUser extends UsersEvent {}

final class GetFriends extends UsersEvent {}