import 'package:hive_flutter/adapters.dart';
import '../../generated/l10n.dart';

part 'task_type.g.dart';

@HiveType(typeId: 10)
enum TaskType {
  @HiveField(0)
  interviews('Interviews'),
  @HiveField(1)
  time('Time'),
  @HiveField(2)
  score('Score');

  final String name;

  const TaskType(this.name);

  String localizedName(S s) => switch (this) {
    TaskType.interviews => s.interviews,
    TaskType.time => s.time,
    TaskType.score => s.score,
  };

  String localizedWord(int value, S s) => switch (this) {
    TaskType.interviews => s.interview_word(value),
    TaskType.time => s.minutes_word(value),
    TaskType.score => s.points_word(value),
  };

  @override
  String toString() => name;
}