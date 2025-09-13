import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'interview.g.dart';

@HiveType(typeId: 2)
@JsonSerializable(explicitToJson: true)
class Interview extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final String difficulty;

  @HiveField(3)
  final String direction;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final List<Question> questions;

  const Interview({
    required this.id,
    required this.score,
    required this.difficulty,
    required this.direction,
    required this.date,
    required this.questions,
  });

  @override
  List<Object?> get props => [score, difficulty, direction, date, questions];

  factory Interview.fromJson(Map<String, dynamic> json) =>
      _$InterviewFromJson(json);

  Map<String, dynamic> toJson() => _$InterviewToJson(this);

  factory Interview.fromQuestions(
    List<Question> questions,
    InterviewInfo info,
  ) {
    final averageScore =
        questions.map((q) => q.score).reduce((a, b) => a + b) /
        questions.length;

    return Interview(
      id: Uuid().v1(),
      score: averageScore.toInt(),
      difficulty: info.difficulty,
      direction: info.direction,
      date: DateTime.now(),
      questions: questions,
    );
  }

  static List<Interview> filterInterviews(
    String direction,
    String difficulty,
    String sort,
    List<Interview> interviews,
  ) {
    if (direction.isNotEmpty) {
      interviews = interviews.where((i) => i.direction == direction).toList();
    }
    if (difficulty.isNotEmpty) {
      interviews = interviews.where((i) => i.difficulty == difficulty).toList();
    }
    if (sort == Data.sorts[0]) {
      interviews.sort((a, b) => b.date.compareTo(a.date));
    } else if (sort == Data.sorts[1]) {
      interviews.sort((a, b) => a.date.compareTo(b.date));
    } else if (sort == Data.sorts[2]) {
      interviews.sort((a, b) => b.score.compareTo(a.score));
    }
    return interviews;
  }
}
