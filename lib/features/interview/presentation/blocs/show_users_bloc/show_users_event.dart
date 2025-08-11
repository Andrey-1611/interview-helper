part of 'show_users_bloc.dart';

sealed class ShowUsersEvent extends Equatable {
  const ShowUsersEvent();

  @override
  List<Object?> get props => [];
}

final class ShowUsers extends ShowUsersEvent {}