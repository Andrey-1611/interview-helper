part of 'save_user_bloc.dart';

sealed class SaveUserState extends Equatable {
  const SaveUserState();

  @override
  List<Object> get props => [];
}

final class SaveUserInitial extends SaveUserState {}

final class SaveUserLoading extends SaveUserState {}

final class SaveUserFailure extends SaveUserState {}

final class SaveUserSuccess extends SaveUserState {
  final UserData user;

  const SaveUserSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
