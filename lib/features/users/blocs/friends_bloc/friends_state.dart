part of 'friends_bloc.dart';

sealed class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

final class FriendsInitial extends FriendsState {}

final class FriendsLoading extends FriendsState {}

final class FriendsFailure extends FriendsState {}

final class FriendsNetworkFailure extends FriendsState {}

final class FriendsSuccess extends FriendsState {}

final class FriendRequestsSuccess extends FriendsState {
  final List<FriendRequest> requests;

  const FriendRequestsSuccess({required this.requests});

  @override
  List<Object> get props => [requests];
}
