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
      direction: fields[1] as Direction,
      difficulty: fields[2] as Difficulty,
      score: fields[3] as int,
      durationMs: fields[4] as int,
      language: fields[5] as Language,
    );
  }

  @override
  void write(BinaryWriter writer, Interview obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.direction)
      ..writeByte(2)
      ..write(obj.difficulty)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.durationMs)
      ..writeByte(5)
      ..write(obj.language);
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
      direction: $enumDecode(_$DirectionEnumMap, json['direction']),
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      score: (json['score'] as num).toInt(),
      durationMs: (json['durationMs'] as num).toInt(),
      language: $enumDecode(_$LanguageEnumMap, json['language']),
    );

Map<String, dynamic> _$InterviewToJson(Interview instance) => <String, dynamic>{
      'id': instance.id,
      'direction': _$DirectionEnumMap[instance.direction]!,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'score': instance.score,
      'durationMs': instance.durationMs,
      'language': _$LanguageEnumMap[instance.language]!,
    };

const _$DirectionEnumMap = {
  Direction.flutter: 'flutter',
  Direction.kotlin: 'kotlin',
  Direction.swift: 'swift',
  Direction.javascript: 'javascript',
  Direction.python: 'python',
  Direction.cpp: 'cpp',
  Direction.java: 'java',
  Direction.go: 'go',
  Direction.git: 'git',
  Direction.sql: 'sql',
  Direction.typescript: 'typescript',
  Direction.rust: 'rust',
  Direction.devops: 'devops',
  Direction.php: 'php',
};

const _$DifficultyEnumMap = {
  Difficulty.junior: 'junior',
  Difficulty.middle: 'middle',
  Difficulty.senior: 'senior',
};

const _$LanguageEnumMap = {
  Language.russian: 'russian',
  Language.english: 'english',
};
