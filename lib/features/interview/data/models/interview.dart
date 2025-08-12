import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interview.g.dart';

@JsonSerializable(explicitToJson: true)
class Interview {
  final int score;
  final String difficulty;
  final bool isCorrect;
  final DateTime date;
  final List<Question> questions;

  Interview({
    required this.score,
    required this.difficulty,
    required this.isCorrect,
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

    final isCorrectAnswers = questions.where((q) => q.isCorrect);
    final bool isCorrect = isCorrectAnswers.length >= questions.length * 0.7;

    return Interview(
      score: averageScore.toInt(),
      isCorrect: isCorrect,
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

  static int countAverage(data) {
    if (data.docs.isEmpty) return 0;
    final scores = data.docs
        .map((doc) => (doc['score'] as num).toInt())
        .toList();
    return (scores.reduce((a, b) => a + b) / scores.length).toInt();
  }
}
