import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class Task extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int currentValue;

  @HiveField(2)
  final int targetValue;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String direction;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? completedAt;

  const Task({
    required this.id,
    this.currentValue = 0,
    required this.targetValue,
    required this.type,
    required this.direction,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
    id,
    currentValue,
    targetValue,
    type,
    direction,
    createdAt,
    completedAt,
  ];

  int get progress => min(
    targetValue != 0 ? (currentValue / targetValue * 100).round() : 0,
    100,
  );

  bool get isCompleted => currentValue >= targetValue;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  factory Task.create(int value, String type, String direction) {
    return Task(
      id: Uuid().v1(),
      targetValue: value,
      type: type,
      direction: direction,
      createdAt: DateTime.now(),
    );
  }

  factory Task.complete(Task task) {
    return Task(
      id: task.id,
      targetValue: task.targetValue,
      type: task.type,
      direction: task.direction,
      createdAt: task.createdAt,
      completedAt: DateTime.now(),
    );
  }

  Task copyWith({
    String? id,
    int? currentValue,
    int? targetValue,
    String? type,
    String? direction,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      type: type ?? this.type,
      direction: direction ?? this.direction,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  static List<Task> filterTasks(
    String? direction,
    String? type,
    String? sort,
    bool? isComplete,
    List<Task> tasks,
  ) {
    if (direction != null) {
      tasks = tasks.where((task) => task.direction == direction).toList();
    }
    if (type != null) {
      tasks = tasks.where((task) => task.type == type).toList();
    }
    if (isComplete != null) {
      tasks = tasks.where((task) => task.isCompleted == isComplete).toList();
    }
    return tasks;
  }
}
