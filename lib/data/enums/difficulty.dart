import 'package:hive_flutter/adapters.dart';

part 'difficulty.g.dart';

@HiveType(typeId: 13)
enum Difficulty {
  @HiveField(0)
  junior('Junior'),
  @HiveField(1)
  middle('Middle'),
  @HiveField(2)
  senior('Senior');

  final String name;

  const Difficulty(this.name);

  @override
  String toString() => name;
}

