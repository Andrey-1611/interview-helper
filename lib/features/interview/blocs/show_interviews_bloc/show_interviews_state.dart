part of 'show_interviews_bloc.dart';

@immutable
sealed class ShowInterviewsState extends Equatable {
  const ShowInterviewsState();

  @override
  List<Object?> get props => [];
}

final class ShowInterviewsInitial extends ShowInterviewsState {}

final class ShowInterviewsLoading extends ShowInterviewsState {}

final class ShowInterviewsFailure extends ShowInterviewsState {
  final String error;

  const ShowInterviewsFailure({required this.error});
}

final class ShowInterviewsSuccess extends ShowInterviewsState {
  final List<Interview> interviews;

  const ShowInterviewsSuccess({required this.interviews});

  @override
  List<Object?> get props => [interviews];
}
