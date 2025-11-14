// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      id: json['id'] as String,
      fromUser: UserData.fromJson(json['fromUser'] as Map<String, dynamic>),
      toUserId: json['toUserId'] as String,
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUser': instance.fromUser,
      'toUserId': instance.toUserId,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
    };
