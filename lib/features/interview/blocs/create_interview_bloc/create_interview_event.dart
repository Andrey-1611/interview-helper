part of 'create_interview_bloc.dart';

sealed class CreateInterviewEvent extends Equatable {
  const CreateInterviewEvent();

  @override
  List<Object?> get props => [];
}

final class CreateInterview extends CreateInterviewEvent {}