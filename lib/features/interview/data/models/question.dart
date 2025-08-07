import 'dart:math';
import 'package:interview_master/core/constants/questions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final double score;
  final String question;
  final String userAnswer;
  final String correctAnswer;

  Question({
    required this.score,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> map) =>
      _$QuestionFromJson(map);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  static List<String> fromDifficulty(int difficulty) {
    final random = Random();
    final selectedQuestions = switch (difficulty) {
      1 => FlutterInterviewQuestions.flutterInterviewQuestionsJunior,
      2 => FlutterInterviewQuestions.flutterInterviewQuestionsMiddle,
      3 => FlutterInterviewQuestions.flutterInterviewQuestionsSenior,
      int() => [],
    };
    final myQuestions = List<String>.from(selectedQuestions)..shuffle(random);
    return myQuestions.take(10).toList();
  }
}
