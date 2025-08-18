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
}
