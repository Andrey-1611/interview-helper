part of 'tracker_bloc.dart';

sealed class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object?> get props => [];
}

final class GetTasks extends TrackerEvent {}

final class CreateTask extends TrackerEvent {
  final String direction;
  final String type;
  final int targetValue;

  const CreateTask({
    required this.direction,
    required this.type,
    required this.targetValue,
  });

  @override
  List<Object?> get props => [direction, type, targetValue];
}

final class DeleteTask extends TrackerEvent {
  final String id;

  const DeleteTask({required this.id});

  @override
  List<Object?> get props => [id];
}
