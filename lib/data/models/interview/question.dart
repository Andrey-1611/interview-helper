import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/data/models/interview/interview_data.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../core/constants/data.dart';

part 'question.g.dart';

@HiveType(typeId: 3)
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

  static List<Question> filterQuestions(
    String? direction,
    String? difficulty,
    String? sort,
    List<InterviewData> interviews,
  ) {
    if (direction != null) {
      interviews = interviews.where((i) => i.direction == direction).toList();
    }
    if (difficulty != null) {
      interviews = interviews.where((i) => i.difficulty == difficulty).toList();
    }

    if (sort == InitialData.firstNew) {
      interviews.sort((a, b) => b.date.compareTo(a.date));
    } else if (sort == InitialData.firstOld) {
      interviews.sort((a, b) => a.date.compareTo(b.date));
    }

    final questions = interviews
        .expand((interview) => interview.questions)
        .toList();

    if (sort == InitialData.firstBest) {
      questions.sort((a, b) => b.score.compareTo(a.score));
    } else if (sort == InitialData.firstWorst) {
      questions.sort((a, b) => a.score.compareTo(b.score));
    }

    return questions;
  }
}
