// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 4;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      currentValue: fields[1] as int,
      targetValue: fields[2] as int,
      type: fields[3] as TaskType,
      direction: fields[4] as Direction,
      createdAt: fields[6] as DateTime,
      completedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.currentValue)
      ..writeByte(2)
      ..write(obj.targetValue)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.direction)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num).toInt(),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      direction: $enumDecode(_$DirectionEnumMap, json['direction']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'type': _$TaskTypeEnumMap[instance.type]!,
      'direction': _$DirectionEnumMap[instance.direction]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$TaskTypeEnumMap = {
  TaskType.interviews: 'interviews',
  TaskType.time: 'time',
  TaskType.score: 'score',
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
