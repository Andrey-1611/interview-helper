// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterviewDataAdapter extends TypeAdapter<InterviewData> {
  @override
  final int typeId = 2;

  @override
  InterviewData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InterviewData(
      id: fields[0] as String,
      score: fields[1] as int,
      difficulty: fields[2] as Difficulty,
      direction: fields[3] as Direction,
      date: fields[4] as DateTime,
      questions: (fields[5] as List).cast<Question>(),
      isFavourite: fields[6] as bool,
      durationMs: fields[7] as int,
      language: fields[8] as Language,
    );
  }

  @override
  void write(BinaryWriter writer, InterviewData obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.questions)
      ..writeByte(6)
      ..write(obj.isFavourite)
      ..writeByte(7)
      ..write(obj.durationMs)
      ..writeByte(8)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterviewDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterviewData _$InterviewDataFromJson(Map<String, dynamic> json) =>
    InterviewData(
      id: json['id'] as String,
      score: (json['score'] as num).toInt(),
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      direction: $enumDecode(_$DirectionEnumMap, json['direction']),
      date: DateTime.parse(json['date'] as String),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFavourite: json['isFavourite'] as bool? ?? false,
      durationMs: (json['durationMs'] as num).toInt(),
      language: $enumDecode(_$LanguageEnumMap, json['language']),
    );

Map<String, dynamic> _$InterviewDataToJson(InterviewData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'direction': _$DirectionEnumMap[instance.direction]!,
      'date': instance.date.toIso8601String(),
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'isFavourite': instance.isFavourite,
      'durationMs': instance.durationMs,
      'language': _$LanguageEnumMap[instance.language]!,
    };

const _$DifficultyEnumMap = {
  Difficulty.junior: 'junior',
  Difficulty.middle: 'middle',
  Difficulty.senior: 'senior',
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

const _$LanguageEnumMap = {
  Language.russian: 'russian',
  Language.english: 'english',
};
