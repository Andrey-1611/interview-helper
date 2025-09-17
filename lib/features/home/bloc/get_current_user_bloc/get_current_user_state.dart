part of 'get_current_user_bloc.dart';

sealed class GetCurrentUserState extends Equatable {
  const GetCurrentUserState();

  @override
  List<Object> get props => [];
}

final class GetCurrentUserInitial extends GetCurrentUserState {}

final class GetCurrentUserLoading extends GetCurrentUserState {}

final class GetCurrentUserFailure extends GetCurrentUserState {}

final class GetCurrentUserNotAuth extends GetCurrentUserState {}

final class GetCurrentUserSuccess extends GetCurrentUserState {
  final UserData user;

  const GetCurrentUserSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
