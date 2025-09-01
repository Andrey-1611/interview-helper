// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterviewAdapter extends TypeAdapter<Interview> {
  @override
  final int typeId = 2;

  @override
  Interview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Interview(
      id: fields[0] as String,
      score: fields[1] as int,
      difficulty: fields[2] as String,
      direction: fields[3] as String,
      date: fields[4] as DateTime,
      questions: (fields[5] as List).cast<Question>(),
    );
  }

  @override
  void write(BinaryWriter writer, Interview obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.difficulty)
      ..writeByte(3)
      ..write(obj.direction)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interview _$InterviewFromJson(Map<String, dynamic> json) => Interview(
      id: json['id'] as String,
      score: (json['score'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      direction: json['direction'] as String,
      date: DateTime.parse(json['date'] as String),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InterviewToJson(Interview instance) => <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'difficulty': instance.difficulty,
      'direction': instance.direction,
      'date': instance.date.toIso8601String(),
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };
