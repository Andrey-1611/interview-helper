part of 'create_interview_bloc.dart';

sealed class CreateInterviewEvent extends Equatable {
  const CreateInterviewEvent();

  @override
  List<Object?> get props => [];
}

final class CreateInterview extends CreateInterviewEvent {
  final List<GeminiResponses> remoteDataSource;
  final int difficulty;

  const CreateInterview({required this.remoteDataSource, required this.difficulty});

  @override
  List<Object?> get props => [remoteDataSource, difficulty];
}