part of 'get_user_bloc.dart';

sealed class GetUserEvent extends Equatable {
  const GetUserEvent();

  @override
  List<Object?> get props => [];
}

final class GetUser extends GetUserEvent {
  final UserData? userData;

  const GetUser({required this.userData});

  @override
  List<Object?> get props => [userData];
}
