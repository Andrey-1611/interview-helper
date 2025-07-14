part of 'clear_user_bloc.dart';

sealed class ClearUserEvent extends Equatable {
  const ClearUserEvent();

  @override
  List<Object?> get props => [];
}

final class ClearUser extends ClearUserEvent {}
