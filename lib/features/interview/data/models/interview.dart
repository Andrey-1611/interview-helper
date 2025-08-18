import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interview.g.dart';

@JsonSerializable(explicitToJson: true)
class Interview {
  final int score;
  final String difficulty;
  final String direction;
  final DateTime date;
  final List<Question> questions;

  Interview({
    required this.score,
    required this.difficulty,
    required this.direction,
    required this.date,
    required this.questions,
  });

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
      score: averageScore.toInt(),
      difficulty: info.difficultly,
      direction: info.direction,
      date: DateTime.now(),
      questions: questions,
    );
  }
}
