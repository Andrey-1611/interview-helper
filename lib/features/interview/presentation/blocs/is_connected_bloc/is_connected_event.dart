part of 'is_connected_bloc.dart';

sealed class IsConnectedEvent extends Equatable {
  const IsConnectedEvent();

  @override
  List<Object?> get props => [];
}

final class IsConnected extends IsConnectedEvent {}
