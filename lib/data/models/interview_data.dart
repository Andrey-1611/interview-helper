import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/data/models/question.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../enums/difficulty.dart';
import '../enums/direction.dart';
import '../enums/language.dart';
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
  final Difficulty difficulty;

  @HiveField(3)
  final Direction direction;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final List<Question> questions;

  @HiveField(6)
  final bool isFavourite;

  @HiveField(7)
  final int durationMs;

  @HiveField(8)
  final Language language;

  const InterviewData({
    required this.id,
    required this.score,
    required this.difficulty,
    required this.direction,
    required this.date,
    required this.questions,
    this.isFavourite = false,
    required this.durationMs,
    required this.language,
  });

  @override
  List<Object?> get props => [
    score,
    difficulty,
    direction,
    date,
    questions,
    isFavourite,
    language,
  ];

  factory InterviewData.fromJson(Map<String, dynamic> json) =>
      _$InterviewDataFromJson(json);

  Map<String, dynamic> toJson() => _$InterviewDataToJson(this);

  Duration get duration => Duration(milliseconds: durationMs);

  factory InterviewData.fromQuestions(
    List<Question> questions,
    InterviewInfo info,
    int duration,
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
      durationMs: duration,
      language: info.language,
    );
  }

  InterviewData copyWith({
    String? id,
    int? score,
    Difficulty? difficulty,
    Direction? direction,
    DateTime? date,
    List<Question>? questions,
    bool? isFavourite,
    int? durationMs,
    Language? language,
  }) {
    return InterviewData(
      id: id ?? this.id,
      score: score ?? this.score,
      difficulty: difficulty ?? this.difficulty,
      direction: direction ?? this.direction,
      date: date ?? this.date,
      questions: questions ?? this.questions,
      isFavourite: isFavourite ?? this.isFavourite,
      durationMs: durationMs ?? this.durationMs,
      language: language ?? this.language,
    );
  }

  static List<InterviewData> filterInterviews(
    Direction? direction,
    Difficulty? difficulty,
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
    return interviews;
  }
}
