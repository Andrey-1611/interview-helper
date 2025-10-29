import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/data/models/interview.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/data.dart';
import 'interview_data.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class UserData extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final List<Interview> interviews;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.interviews,
  });

  @override
  List<Object?> get props => [name, id, interviews];

  int get totalInterviews => interviews.length;

  int get totalScore => interviews.isNotEmpty
      ? interviews.map((i) => i.score).reduce((a, b) => a + b)
      : 0;

  int get averageScore =>
      interviews.isNotEmpty ? totalScore ~/ totalInterviews : 0;

  int get bestScore =>
      interviews.isNotEmpty ? interviews.map((i) => i.score).reduce(max) : 0;

  Duration get totalDuration => interviews.isNotEmpty
      ? interviews.map((i) => i.duration).reduce((a, b) => a + b)
      : Duration.zero;

  Duration get averageDuration => interviews.isNotEmpty
      ? (Duration(milliseconds: totalDuration.inMilliseconds) ~/
            totalInterviews)
      : Duration.zero;

  Duration get maxDuration => interviews.isNotEmpty
      ? interviews.map((i) => i.duration).reduce((a, b) => a > b ? a : b)
      : Duration.zero;

  Duration get minDuration => interviews.isNotEmpty
      ? interviews.map((i) => i.duration).reduce((a, b) => a > b ? b : a)
      : Duration.zero;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.updateData(UserData userData, InterviewData interview) {
    return UserData(
      id: userData.id,
      name: userData.name,
      email: userData.email,
      interviews: List.from(userData.interviews)
        ..add(Interview.fromInterviewData(interview)),
    );
  }

  static List<UserData> filterUsers(
    String? direction,
    String? sort,
    List<UserData> users,
  ) {
    users = users.map((user) {
      return UserData(
        id: user.id,
        name: user.name,
        email: user.email,
        interviews: direction != null
            ? user.interviews.where((i) => i.direction == direction).toList()
            : user.interviews,
      );
    }).toList();

    if (sort == InitialData.firstTotalScore) {
      users.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    } else if (sort == InitialData.firstTotalInterviews) {
      users.sort((a, b) => b.totalInterviews.compareTo(a.totalInterviews));
    } else if (sort == InitialData.firstAverageScore) {
      users.sort((a, b) => b.averageScore.compareTo(a.averageScore));
    }

    return users;
  }

  static UserData filterUser(
    String? direction,
    String? difficulty,
    UserData user,
  ) {
    List<Interview> interviews = user.interviews;
    if (direction != null) {
      interviews = interviews.where((i) => i.direction == direction).toList();
    }
    if (difficulty != null) {
      interviews = interviews.where((i) => i.difficulty == difficulty).toList();
    }
    return UserData(
      id: user.id,
      name: user.name,
      email: user.email,
      interviews: interviews,
    );
  }
}
