part of 'friends_bloc.dart';

sealed class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object?> get props => [];
}

final class SendFriendRequest extends FriendsEvent {
  final UserData fromUser;
  final String toUserId;

  const SendFriendRequest({required this.fromUser, required this.toUserId});

  @override
  List<Object?> get props => [fromUser, toUserId];
}

final class GetFriendRequests extends FriendsEvent {}

final class UpdateFriendRequest extends FriendsEvent {
  final UserData user;
  final bool isAccepted;
  final FriendRequest request;

  const UpdateFriendRequest({
    required this.request,
    required this.user,
    required this.isAccepted,
  });

  @override
  List<Object?> get props => [request, user, isAccepted];
}
