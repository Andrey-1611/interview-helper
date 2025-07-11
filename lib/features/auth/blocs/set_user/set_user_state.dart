part of 'set_user_bloc.dart';

sealed class SetUserState extends Equatable {
  const SetUserState();

  @override
  List<Object> get props => [];
}

final class SetUserInitial extends SetUserState {}

final class SetUserLoading extends SetUserState {}

final class SetUserFailure extends SetUserState {}

final class SetUserSuccess extends SetUserState {}




