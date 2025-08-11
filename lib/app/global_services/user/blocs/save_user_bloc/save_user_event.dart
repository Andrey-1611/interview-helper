part of 'save_user_bloc.dart';

sealed class SaveUserEvent extends Equatable {
  const SaveUserEvent();

  @override
  List<Object?> get props => [];
}

final class SaveUser extends SaveUserEvent {
  final UserData user;

  const SaveUser({required this.user});

  @override
  List<Object?> get props => [user];
}