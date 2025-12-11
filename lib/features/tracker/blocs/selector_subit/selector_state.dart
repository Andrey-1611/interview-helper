part of 'selector_cubit.dart';

class SelectorState extends Equatable {
  final Direction? direction;
  final TaskType? type;
  final int? value;

  const SelectorState({this.direction, this.type, this.value});

  SelectorState copyWith({Direction? direction, TaskType? type, int? value}) {
    return SelectorState(
      direction: direction ?? this.direction,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [direction, type, value];
}
