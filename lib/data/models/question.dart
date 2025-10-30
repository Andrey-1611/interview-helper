import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/interviews_data.dart';

part 'question.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class Question extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final String question;

  @HiveField(3)
  final String userAnswer;

  @HiveField(4)
  final String correctAnswer;

  @HiveField(5)
  final bool isFavourite;

  const Question({
    required this.id,
    required this.score,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    this.isFavourite = false,
  });

  @override
  List<Object?> get props => [
    id,
    score,
    question,
    userAnswer,
    correctAnswer,
    isFavourite,
  ];

  Question copyWith({
    String? id,
    int? score,
    String? question,
    String? userAnswer,
    String? correctAnswer,
    bool? isFavourite,
  }) {
    return Question(
      id: id ?? this.id,
      score: score ?? this.score,
      question: question ?? this.question,
      userAnswer: userAnswer ?? this.userAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  factory Question.fromAI(Map<String, dynamic> json) {
    return Question(
      id: Uuid().v1(),
      score: json['score'],
      question: json['question'],
      userAnswer: json['userAnswer'],
      correctAnswer: json['correctAnswer'],
    );
  }

  static List<Question> filterQuestions(
    String? direction,
    String? difficulty,
    String? sort,
    bool isFavourite,
    List<InterviewData> interviews,
  ) {
    if (direction != null) {
      interviews = interviews.where((i) => i.direction == direction).toList();
    }
    if (difficulty != null) {
      interviews = interviews.where((i) => i.difficulty == difficulty).toList();
    }

    if (sort == InterviewsData.firstNew) {
      interviews.sort((a, b) => b.date.compareTo(a.date));
    } else if (sort == InterviewsData.firstOld) {
      interviews.sort((a, b) => a.date.compareTo(b.date));
    }

    List<Question> questions = interviews
        .expand((interview) => interview.questions)
        .toList();

    if (isFavourite) {
      questions = questions
          .where((question) => question.isFavourite == true)
          .toList();
    }

    if (sort == InterviewsData.firstBest) {
      questions.sort((a, b) => b.score.compareTo(a.score));
    } else if (sort == InterviewsData.firstWorst) {
      questions.sort((a, b) => a.score.compareTo(b.score));
    }

    return questions;
  }
}
