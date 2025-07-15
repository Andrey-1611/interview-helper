part of 'get_questions_bloc.dart';

sealed class GetQuestionsEvent extends Equatable {
  const GetQuestionsEvent();

  @override
  List<Object?> get props => [];
}

final class GetQuestions extends GetQuestionsEvent {
  final int difficulty;

  const GetQuestions({required this.difficulty});

  @override
  List<Object?> get props => [difficulty];
}