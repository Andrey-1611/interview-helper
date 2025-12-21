// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 1;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      interviews: (fields[3] as List).cast<Interview>(),
      directions: (fields[4] as List).cast<Direction>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.interviews)
      ..writeByte(4)
      ..write(obj.directions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      interviews: (json['interviews'] as List<dynamic>?)
              ?.map((e) => Interview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      directions: (json['directions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DirectionEnumMap, e))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'interviews': instance.interviews.map((e) => e.toJson()).toList(),
      'directions':
          instance.directions.map((e) => _$DirectionEnumMap[e]!).toList(),
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
