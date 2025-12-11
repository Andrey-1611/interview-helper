import 'package:hive_flutter/adapters.dart';

part 'direction.g.dart';

@HiveType(typeId: 11)
enum Direction {
  @HiveField(0)
  flutter('Flutter'),
  @HiveField(1)
  kotlin('Kotlin'),
  @HiveField(2)
  swift('Swift'),
  @HiveField(3)
  javascript('JavaScript'),
  @HiveField(4)
  python('Python'),
  @HiveField(5)
  cpp('C++'),
  @HiveField(6)
  java('Java'),
  @HiveField(7)
  go('Go'),
  @HiveField(8)
  git('Git'),
  @HiveField(9)
  sql('SQL'),
  @HiveField(10)
  typescript('TypeScript'),
  @HiveField(11)
  rust('Rust'),
  @HiveField(12)
  devops('DevOps'),
  @HiveField(13)
  php('PHP');

  final String name;

  const Direction(this.name);

  @override
  String toString() => name;
}