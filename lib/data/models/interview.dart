import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interview.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Interview extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String direction;

  @HiveField(2)
  final String difficulty;

  @HiveField(3)
  final int score;

  @HiveField(4)
  final int durationMs;

  const Interview({
    required this.id,
    required this.direction,
    required this.difficulty,
    required this.score,
    required this.durationMs,
  });

  @override
  List<Object?> get props => [id, direction, difficulty, score, duration];

  factory Interview.fromJson(Map<String, dynamic> json) =>
      _$InterviewFromJson(json);

  Map<String, dynamic> toJson() => _$InterviewToJson(this);

  Duration get duration => Duration(milliseconds: durationMs);

  factory Interview.fromInterviewData(InterviewData interview) {
    return Interview(
      id: interview.id,
      direction: interview.direction,
      difficulty: interview.difficulty,
      score: interview.score,
      durationMs: interview.durationMs,
    );
  }
}
