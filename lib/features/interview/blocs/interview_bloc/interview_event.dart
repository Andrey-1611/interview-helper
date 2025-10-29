part of 'interview_bloc.dart';

sealed class InterviewEvent extends Equatable {
  const InterviewEvent();

  @override
  List<Object?> get props => [];
}

final class StartInterview extends InterviewEvent {}

final class GetQuestions extends InterviewEvent {
  final InterviewInfo interviewInfo;

  const GetQuestions({required this.interviewInfo});

  @override
  List<Object?> get props => [interviewInfo];
}

final class FinishInterview extends InterviewEvent {
  final InterviewInfo interviewInfo;

  const FinishInterview({required this.interviewInfo});

  @override
  List<Object?> get props => [interviewInfo];
}
