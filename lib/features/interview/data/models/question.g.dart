// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 2;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      score: fields[0] as int,
      question: fields[1] as String,
      userAnswer: fields[2] as String,
      correctAnswer: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.userAnswer)
      ..writeByte(3)
      ..write(obj.correctAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      score: (json['score'] as num).toInt(),
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
