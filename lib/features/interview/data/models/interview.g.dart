// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interview _$InterviewFromJson(Map<String, dynamic> json) => Interview(
  score: (json['score'] as num).toInt(),
  difficulty: json['difficulty'] as String,
  date: DateTime.parse(json['date'] as String),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InterviewToJson(Interview instance) => <String, dynamic>{
  'score': instance.score,
  'difficulty': instance.difficulty,
  'date': instance.date.toIso8601String(),
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};
