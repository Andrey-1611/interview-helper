part of 'get_user_bloc.dart';

sealed class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<Object> get props => [];
}

final class GetUserInitial extends GetUserState {}

final class GetUserLoading extends GetUserState {}

final class GetUserFailure extends GetUserState {}

final class GetUserNotAuth extends GetUserState {}

final class GetUserSuccess extends GetUserState {
  final UserProfile userProfile;

  const GetUserSuccess({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}
