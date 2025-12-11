// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DirectionAdapter extends TypeAdapter<Direction> {
  @override
  final int typeId = 11;

  @override
  Direction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Direction.flutter;
      case 1:
        return Direction.kotlin;
      case 2:
        return Direction.swift;
      case 3:
        return Direction.javascript;
      case 4:
        return Direction.python;
      case 5:
        return Direction.cpp;
      case 6:
        return Direction.java;
      case 7:
        return Direction.go;
      case 8:
        return Direction.git;
      case 9:
        return Direction.sql;
      case 10:
        return Direction.typescript;
      case 11:
        return Direction.rust;
      case 12:
        return Direction.devops;
      case 13:
        return Direction.php;
      default:
        return Direction.flutter;
    }
  }

  @override
  void write(BinaryWriter writer, Direction obj) {
    switch (obj) {
      case Direction.flutter:
        writer.writeByte(0);
        break;
      case Direction.kotlin:
        writer.writeByte(1);
        break;
      case Direction.swift:
        writer.writeByte(2);
        break;
      case Direction.javascript:
        writer.writeByte(3);
        break;
      case Direction.python:
        writer.writeByte(4);
        break;
      case Direction.cpp:
        writer.writeByte(5);
        break;
      case Direction.java:
        writer.writeByte(6);
        break;
      case Direction.go:
        writer.writeByte(7);
        break;
      case Direction.git:
        writer.writeByte(8);
        break;
      case Direction.sql:
        writer.writeByte(9);
        break;
      case Direction.typescript:
        writer.writeByte(10);
        break;
      case Direction.rust:
        writer.writeByte(11);
        break;
      case Direction.devops:
        writer.writeByte(12);
        break;
      case Direction.php:
        writer.writeByte(13);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
