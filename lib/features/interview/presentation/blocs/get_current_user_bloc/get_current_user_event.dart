part of 'get_current_user_bloc.dart';

sealed class GetCurrentUserEvent extends Equatable {
  const GetCurrentUserEvent();

  @override
  List<Object?> get props => [];
}

final class GetCurrentUser extends GetCurrentUserEvent {}
