import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../features/auth/data/models/my_user.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData extends Equatable {
  final String name;
  final String id;
  final int totalInterviews;
  final int totalScore;
  final int averageScore;
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

  static Map<String, dynamic> updateData(
    UserData userData,
    Interview interview,
  ) {
    final totalInterviews = userData.totalInterviews + 1;
    final totalScore = userData.totalScore + interview.score;
    final averageScore = totalScore ~/ totalInterviews;
    final bestScore = max(interview.score, userData.bestScore);
    final lastInterviewDate = interview.date;

    return {
      'totalScore': totalScore,
      'totalInterviews': totalInterviews,
      'averageScore': averageScore,
      'bestScore': bestScore,
      'lastInterviewDate': lastInterviewDate,
    };
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
