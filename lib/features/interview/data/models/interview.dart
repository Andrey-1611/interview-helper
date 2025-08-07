import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interview.g.dart';

@JsonSerializable()
class Interview {
  final double score;
  final int difficulty;
  final DateTime date;
  final List<Question> questions;

  Interview({
    required this.score,
    required this.difficulty,
    required this.date,
    required this.questions,
  });

  factory Interview.fromJson(Map<String, dynamic> map) =>
      _$InterviewFromJson(map);

  Map<String, dynamic> toJson() => _$InterviewToJson(this);

  factory Interview.fromQuestions(List<Question> questions, int difficulty) {
    final averageScore =
        questions.map((q) => q.score).reduce((a, b) => a + b) /
        questions.length;

    return Interview(
      score: averageScore,
      difficulty: difficulty,
      date: DateTime.now(),
      questions: questions,
    );
  }
}
