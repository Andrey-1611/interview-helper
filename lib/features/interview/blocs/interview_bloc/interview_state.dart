part of 'interview_bloc.dart';

sealed class InterviewState extends Equatable {
  const InterviewState();

  @override
  List<Object> get props => [];
}

final class InterviewInitial extends InterviewState {}

final class InterviewLoading extends InterviewState {}

final class InterviewFailure extends InterviewState {}

final class InterviewNetworkFailure extends InterviewState {}

final class InterviewAttemptsFailure extends InterviewState {}

final class InterviewStartSuccess extends InterviewState {}

final class InterviewQuestionsSuccess extends InterviewState {
  final List<String> questions;

  const InterviewQuestionsSuccess({required this.questions});

  @override
  List<Object> get props => [questions];
}

final class InterviewFinishSuccess extends InterviewState {
  final InterviewData interview;

  const InterviewFinishSuccess({required this.interview});

  @override
  List<Object> get props => [interview];
}
