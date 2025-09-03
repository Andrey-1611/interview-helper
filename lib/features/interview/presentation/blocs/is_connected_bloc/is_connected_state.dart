part of 'is_connected_bloc.dart';

sealed class IsConnectedState extends Equatable {
  const IsConnectedState();

  @override
  List<Object> get props => [];
}

final class IsConnectedInitial extends IsConnectedState {}

final class IsConnectedFailure extends IsConnectedState {}

final class IsConnectedFalse extends IsConnectedState {}

final class IsConnectedTrue extends IsConnectedState {}
