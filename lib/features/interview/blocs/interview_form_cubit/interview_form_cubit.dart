import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'interview_form_state.dart';

class InterviewFormCubit extends Cubit<InterviewFormState> {
  InterviewFormCubit() : super(InterviewFormState());

  void changeDirection(String direction) {
    emit(state.copyWith(direction: direction));
  }

  void changeDifficulty(String difficulty) {
    emit(state.copyWith(difficulty: difficulty));
  }

  void changeLanguage(String language) {
    emit(state.copyWith(language: language));
  }

  void changeAll(String direction, String difficulty) {
    emit(state.copyWith(direction: direction, difficulty: difficulty));
  }
}
