import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interview.g.dart';

@JsonSerializable(explicitToJson: true)
class Interview {
  final int score;
  final String difficulty;
  final DateTime date;
  final List<Question> questions;

  Interview({
    required this.score,
    required this.difficulty,
    required this.date,
    required this.questions,
  });

  factory Interview.fromJson(Map<String, dynamic> json) =>
      _$InterviewFromJson(json);

  Map<String, dynamic> toJson() => _$InterviewToJson(this);

  factory Interview.fromQuestions(List<Question> questions, String difficulty) {
    final averageScore =
        questions.map((q) => q.score).reduce((a, b) => a + b) /
        questions.length;

    return Interview(
      score: averageScore.toInt(),
      difficulty: difficulty,
      date: DateTime.now(),
      questions: questions,
    );
  }

  static String difficultly(int selectedItem) => switch (selectedItem) {
    1 => 'junior',
    2 => 'middle',
    3 => 'senior',
    _ => '',
  };
}
