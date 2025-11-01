part of 'tracker_bloc.dart';

sealed class TrackerState extends Equatable {
  const TrackerState();

  @override
  List<Object> get props => [];
}

final class TrackerInitial extends TrackerState {}

final class TrackerLoading extends TrackerState {}

final class TrackerFailure extends TrackerState {}

final class TrackerTasksFailure extends TrackerState {
  final List<Task> tasks;

  const TrackerTasksFailure({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

final class TrackerSuccess extends TrackerState {
  final List<Task> tasks;

  const TrackerSuccess({required this.tasks});

  @override
  List<Object> get props => [tasks];
}
