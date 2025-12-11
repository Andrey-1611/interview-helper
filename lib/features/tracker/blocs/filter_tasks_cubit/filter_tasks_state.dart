part of 'filter_tasks_cubit.dart';

class FilterTasksState extends Equatable {
  final Direction? direction;
  final TaskType? type;
  final String? sort;
  final bool? isCompleted;

  const FilterTasksState({
    this.direction,
    this.type,
    this.sort,
    this.isCompleted,
  });

  @override
  List<Object?> get props => [direction, type, sort, isCompleted];

  FilterTasksState copyWith({
    Direction? direction,
    TaskType? type,
    String? sort,
    bool? isCompleted,
  }) {
    return FilterTasksState(
      direction: direction ?? this.direction,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
