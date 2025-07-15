part of 'get_questions_bloc.dart';

sealed class GetQuestionsState extends Equatable {
  const GetQuestionsState();

  @override
  List<Object> get props => [];
}

final class GetQuestionsInitial extends GetQuestionsState {}

final class GetQuestionsLoading extends GetQuestionsState {}

final class GetQuestionsFailure extends GetQuestionsState {}

final class GetQuestionsSuccess extends GetQuestionsState {
  final List<String> questions;

  const GetQuestionsSuccess({required this.questions});

  @override
  List<Object> get props => [questions];
}
