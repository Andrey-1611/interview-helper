import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/data/models/interview/interview.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../core/constants/data.dart';
import '../interview/interview_data.dart';
import 'my_user.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class UserData extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final List<Interview> interviews;

  const UserData({
    required this.name,
    required this.id,
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

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromMyUser(MyUser user) {
    return UserData(name: user.name!, id: user.id!, interviews: []);
  }

  factory UserData.updateData(UserData userData, InterviewData interview) {
    return UserData(
      name: userData.name,
      id: userData.id,
      interviews: List.from(userData.interviews)
        ..add(Interview.fromInterviewData(interview)),
    );
  }

  static List<String> getStatsInfo(UserData data) {
    final List<String> stats = [
      'Собеседования:  ${data.totalInterviews}',
      'Очки опыта:  ${data.totalScore} ',
      'Средний результат:  ${data.averageScore} % ',
      'Лучший результат:  ${data.bestScore} %',
    ];
    return stats;
  }

  static List<UserData> filterUsers(
    String direction,
    String sort,
    List<UserData> users,
  ) {
    users = users.map((user) {
      return UserData(
        name: user.name,
        id: user.id,
        interviews: direction.isNotEmpty
            ? user.interviews.where((i) => i.direction == direction).toList()
            : user.interviews,
      );
    }).toList();

    if (sort == InitialData.usersSorts[0]) {
      users.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    } else if (sort == InitialData.usersSorts[1]) {
      users.sort((a, b) => b.totalInterviews.compareTo(a.totalInterviews));
    } else if (sort == InitialData.usersSorts[2]) {
      users.sort((a, b) => b.averageScore.compareTo(a.averageScore));
    }

    return users;
  }
}
