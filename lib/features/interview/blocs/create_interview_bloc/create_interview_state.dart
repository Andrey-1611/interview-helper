part of 'create_interview_bloc.dart';

sealed class CreateInterviewState extends Equatable {
  const CreateInterviewState();

  @override
  List<Object> get props => [];
}

final class CreateInterviewInitial extends CreateInterviewState {}

final class CreateInterviewLoading extends CreateInterviewState {}

final class CreateInterviewFailure extends CreateInterviewState {}

final class CreateInterviewSuccess extends CreateInterviewState {
  final Interview interview;

  const CreateInterviewSuccess({required this.interview});

  @override
  List<Object> get props => [interview];
}