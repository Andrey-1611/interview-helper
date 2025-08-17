import 'dart:math';
import 'package:interview_master/core/constants/questions_i.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int score;
  final String question;
  final String userAnswer;
  final String correctAnswer;

  Question({
    required this.score,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  static List<String> fromDifficulty(String difficulty) {
    final random = Random();
    final selectedQuestions = switch (difficulty) {
      'junior' => FlutterInterviewQuestions.flutterInterviewQuestionsJunior,
      'middle' => FlutterInterviewQuestions.flutterInterviewQuestionsMiddle,
      'senior' => FlutterInterviewQuestions.flutterInterviewQuestionsSenior,
      _ => [],
    };
    final myQuestions = List<String>.from(selectedQuestions)..shuffle(random);
    return myQuestions.take(10).toList();
  }
}
