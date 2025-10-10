import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/data/models/interview/question.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'interview_info.dart';

part 'interview_data.g.dart';

@HiveType(typeId: 2)
@JsonSerializable(explicitToJson: true)
class InterviewData extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final String difficulty;

  @HiveField(3)
  final String direction;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final List<Question> questions;

  @HiveField(6)
  final bool isFavourite;

  const InterviewData({
    required this.id,
    required this.score,
    required this.difficulty,
    required this.direction,
    required this.date,
    required this.questions,
    required this.isFavourite,
  });

  @override
  List<Object?> get props => [
    score,
    difficulty,
    direction,
    date,
    questions,
    isFavourite,
  ];

  factory InterviewData.fromJson(Map<String, dynamic> json) =>
      _$InterviewDataFromJson(json);

  Map<String, dynamic> toJson() => _$InterviewDataToJson(this);

  factory InterviewData.fromQuestions(
    List<Question> questions,
    InterviewInfo info,
  ) {
    final averageScore =
        questions.map((q) => q.score).reduce((a, b) => a + b) /
        questions.length;

    return InterviewData(
      id: Uuid().v1(),
      score: averageScore.toInt(),
      difficulty: info.difficulty,
      direction: info.direction,
      date: DateTime.now(),
      questions: questions,
      isFavourite: false,
    );
  }

  InterviewData copyWith({
    String? id,
    int? score,
    String? difficulty,
    String? direction,
    DateTime? date,
    List<Question>? questions,
    bool? isFavourite,
  }) {
    return InterviewData(
      id: id ?? this.id,
      score: score ?? this.score,
      difficulty: difficulty ?? this.difficulty,
      direction: direction ?? this.direction,
      date: date ?? this.date,
      questions: questions ?? this.questions,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  static List<InterviewData> filterInterviews(
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
    if (isFavourite) {
      interviews = interviews.where((i) => i.isFavourite == true).toList();
    }

    if (sort == InitialData.firstNew) {
      interviews.sort((a, b) => b.date.compareTo(a.date));
    } else if (sort == InitialData.firstOld) {
      interviews.sort((a, b) => a.date.compareTo(b.date));
    }

    if (sort == InitialData.firstBest) {
      interviews.sort((a, b) => b.score.compareTo(a.score));
    } else if (sort == InitialData.firstWorst) {
      interviews.sort((a, b) => a.score.compareTo(b.score));
    }

    return interviews;
  }
}
