import 'package:equatable/equatable.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'friend_request.g.dart';

@JsonSerializable(explicitToJson: true)
class FriendRequest extends Equatable {
  final String id;
  final UserData fromUser;
  final String toUserId;
  final String status;
  final DateTime date;

  const FriendRequest({
    required this.id,
    required this.fromUser,
    required this.toUserId,
    required this.status,
    required this.date,
  });

  FriendRequest copyWith({
    String? id,
    UserData? fromUser,
    String? toUserId,
    String? status,
    DateTime? date,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      toUserId: toUserId ?? this.toUserId,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [id, fromUser, toUserId, status, date];

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);

  factory FriendRequest.create(UserData fromUser, String toUserId) {
    return FriendRequest(
      id: Uuid().v1(),
      fromUser: fromUser,
      toUserId: toUserId,
      status: InterviewsData.pending,
      date: DateTime.now(),
    );
  }

  factory FriendRequest.update(FriendRequest request, bool isAccepted) {
    return request.copyWith(
      status: isAccepted ? InterviewsData.accepted : InterviewsData.rejected,
    );
  }
}
