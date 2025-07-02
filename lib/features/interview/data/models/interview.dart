import 'package:interview_master/features/interview/data/models/question.dart';

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

  factory Interview.fromMap(Map<String, dynamic> map) {
    return Interview(
      score: map['score'] as double,
      difficulty: map['difficulty'] as int,
      date: DateTime.parse(map['date'] as String),
      questions: (map['questions'] as List).map((question) => Question.fromMap(question as Map<String, dynamic>)).toList()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'difficulty': difficulty,
      'date': date.toIso8601String(),
      'questions': questions.map((question) => question.toMap()).toList(),
    };
  }
}
