part of 'clear_user_bloc.dart';

sealed class ClearUserState extends Equatable {
  const ClearUserState();

  @override
  List<Object> get props => [];
}

final class ClearUserInitial extends ClearUserState {}

final class ClearUserLoading extends ClearUserState {}

final class ClearUserFailure extends ClearUserState {}

final class ClearUserSuccess extends ClearUserState {}
