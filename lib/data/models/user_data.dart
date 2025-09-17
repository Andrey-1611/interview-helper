import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../data/models/interview.dart';
import '../../data/models/my_user.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class UserData extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final int totalInterviews;

  @HiveField(3)
  final int totalScore;

  @HiveField(4)
  final int averageScore;

  @HiveField(5)
  final int bestScore;

  const UserData({
    required this.name,
    required this.id,
    required this.totalInterviews,
    required this.totalScore,
    required this.averageScore,
    required this.bestScore,
  });

  @override
  List<Object?> get props => [
    name,
    id,
    totalInterviews,
    totalScore,
    averageScore,
    bestScore,
  ];

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromMyUser(MyUser user) {
    return UserData(
      name: user.name!,
      id: user.id!,
      totalScore: 0,
      totalInterviews: 0,
      averageScore: 0,
      bestScore: 0,
    );
  }

  factory UserData.updateData(UserData userData, Interview interview) {
    final totalInterviews = userData.totalInterviews + 1;
    final totalScore = userData.totalScore + interview.score;
    final averageScore = totalScore ~/ totalInterviews;
    final bestScore = max(interview.score, userData.bestScore);

    return UserData(
      name: userData.name,
      id: userData.id,
      totalInterviews: totalInterviews,
      totalScore: totalScore,
      averageScore: averageScore,
      bestScore: bestScore,
    );
  }

  static List<String> getStatsInfo(UserData data) {
    final List<String> stats = [
      'Собеседования:  ${data.totalInterviews}',
      'Общий счет:  ${data.totalScore} ',
      'Средний результат:  ${data.averageScore} % ',
      'Лучший результат:  ${data.bestScore} %',
    ];
    return stats;
  }
}
