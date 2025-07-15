import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/data/repositories/questions_repository.dart';

part 'get_questions_event.dart';

part 'get_questions_state.dart';

class GetQuestionsBloc extends Bloc<GetQuestionsEvent, GetQuestionsState> {
  final QuestionsRepository questionsRepository;

  GetQuestionsBloc(this.questionsRepository) : super(GetQuestionsInitial()) {
    on<GetQuestions>((event, emit) {
      emit(GetQuestionsLoading());
      try {
        final List<String> questions = questionsRepository.getQuestions(
          event.difficulty,
        );
        emit(GetQuestionsSuccess(questions: questions));
      } catch (e) {
        emit(GetQuestionsFailure());
      }
    });
  }
}
