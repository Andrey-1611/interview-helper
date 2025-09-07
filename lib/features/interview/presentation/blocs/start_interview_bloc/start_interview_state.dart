part of 'start_interview_bloc.dart';

sealed class StartInterviewState extends Equatable {
  const StartInterviewState();

  @override
  List<Object> get props => [];
}

final class StartInterviewInitial extends StartInterviewState {}

final class StartInterviewLoading extends StartInterviewState {}

final class StartInterviewNetworkFailure extends StartInterviewState {}

final class StartInterviewFailure extends StartInterviewState {}

final class StartInterviewNotLoading extends StartInterviewState {}

final class StartInterviewSuccess extends StartInterviewState {}
