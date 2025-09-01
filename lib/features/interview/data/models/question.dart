import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Question extends Equatable {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final String userAnswer;

  @HiveField(3)
  final String correctAnswer;

  const Question({
    required this.score,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [score, question, userAnswer, correctAnswer];

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
