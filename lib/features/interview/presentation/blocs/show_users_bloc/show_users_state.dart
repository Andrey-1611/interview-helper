part of 'show_users_bloc.dart';

sealed class ShowUsersState extends Equatable {
  const ShowUsersState();

  @override
  List<Object> get props => [];
}

final class ShowUsersInitial extends ShowUsersState {}

final class ShowUsersLoading extends ShowUsersState {}

final class ShowUsersFailure extends ShowUsersState {}

final class ShowUsersSuccess extends ShowUsersState {
  final List<UserData> users;

  const ShowUsersSuccess({required this.users});

  @override
  List<Object> get props => [users];
}
