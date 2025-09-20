// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterviewAdapter extends TypeAdapter<Interview> {
  @override
  final int typeId = 0;

  @override
  Interview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Interview(
      id: fields[0] as String,
      direction: fields[1] as String,
      difficulty: fields[2] as String,
      score: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Interview obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.direction)
      ..writeByte(2)
      ..write(obj.difficulty)
      ..writeByte(3)
      ..write(obj.score);
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
      direction: json['direction'] as String,
      difficulty: json['difficulty'] as String,
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$InterviewToJson(Interview instance) => <String, dynamic>{
      'id': instance.id,
      'direction': instance.direction,
      'difficulty': instance.difficulty,
      'score': instance.score,
    };
