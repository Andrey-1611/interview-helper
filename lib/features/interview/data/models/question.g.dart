// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  score: (json['score'] as num).toDouble(),
  question: json['question'] as String,
  userAnswer: json['userAnswer'] as String,
  correctAnswer: json['correctAnswer'] as String,
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'score': instance.score,
  'question': instance.question,
  'userAnswer': instance.userAnswer,
  'correctAnswer': instance.correctAnswer,
};
