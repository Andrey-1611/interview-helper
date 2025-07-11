part of 'check_current_user_bloc.dart';

sealed class CheckCurrentUserEvent extends Equatable {
  const CheckCurrentUserEvent();

  @override
  List<Object?> get props => [];
}

final class CheckCurrentUser extends CheckCurrentUserEvent {}
