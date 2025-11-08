import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/data/models/interview.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/interviews_data.dart';
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

  @HiveField(4)
  final List<String> directions;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    this.interviews = const [],
    this.directions = const [],
  });

  UserData copyWith({
    String? id,
    String? name,
    String? email,
    List<Interview>? interviews,
    List<String>? directions,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      interviews: interviews ?? this.interviews,
      directions: directions ?? this.directions,
    );
  }

  @override
  List<Object?> get props => [name, id, email, interviews, directions];

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

  factory UserData.updateInterviews(UserData user, InterviewData interview) {
    return user.copyWith(
      interviews: List.from(user.interviews)
        ..add(Interview.fromInterviewData(interview)),
    );
  }

  factory UserData.updateDirections(UserData user, List<String> directions) {
    return user.copyWith(directions: directions);
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

    if (sort == InterviewsData.firstTotalScore) {
      users.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    } else if (sort == InterviewsData.firstTotalInterviews) {
      users.sort((a, b) => b.totalInterviews.compareTo(a.totalInterviews));
    } else if (sort == InterviewsData.firstAverageScore) {
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
    return user.copyWith(interviews: interviews);
  }
}
