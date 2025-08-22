import 'dart:math';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../features/auth/data/models/my_user.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String name;
  final String id;
  final int totalInterviews;
  final int totalScore;
  final int averageScore;
  final int bestScore;
  final DateTime? lastInterviewDate;
  final DateTime accountCreated;
  final int streak;

  UserData({
    required this.name,
    required this.id,
    required this.totalInterviews,
    required this.totalScore,
    required this.averageScore,
    required this.bestScore,
    this.lastInterviewDate,
    required this.accountCreated,
    required this.streak,
  });

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
      lastInterviewDate: null,
      accountCreated: DateTime.now(),
      streak: 0,
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
    final streak = _chooseStreak(userData, interview);

    return {
      'totalScore': totalScore,
      'totalInterviews': totalInterviews,
      'averageScore': averageScore,
      'bestScore': bestScore,
      'lastInterviewDate': lastInterviewDate,
      'streak': streak,
    };
  }

  static int _chooseStreak(UserData userData, Interview interview) {
    int streak = 1;
    if (userData.lastInterviewDate != null) {
      final currentDay = DateTime(
        interview.date.year,
        interview.date.month,
        interview.date.day,
      );

      final lastInterviewDay = DateTime(
        userData.lastInterviewDate!.year,
        userData.lastInterviewDate!.month,
        userData.lastInterviewDate!.day,
      );

      final difference = currentDay.difference(lastInterviewDay).inDays;

      if (difference == 0) {
        streak = userData.streak;
      } else if (difference == 1) {
        streak = userData.streak + 1;
      }
    }
    return streak;
  }
}
