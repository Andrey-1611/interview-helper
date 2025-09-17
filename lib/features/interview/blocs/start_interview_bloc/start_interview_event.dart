part of 'start_interview_bloc.dart';

sealed class StartInterviewEvent extends Equatable {
  const StartInterviewEvent();

  @override
  List<Object?> get props => [];
}

final class StartInterview extends StartInterviewEvent {}
