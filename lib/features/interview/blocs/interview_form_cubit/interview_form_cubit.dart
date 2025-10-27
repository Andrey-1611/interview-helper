import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'interview_form_state.dart';

class InterviewFormCubit extends Cubit<InterviewFormState> {
  InterviewFormCubit()
    : super(InterviewFormState(direction: null, difficulty: null));

  void changeDirection(String direction) {
    emit(
      InterviewFormState(direction: direction, difficulty: state.difficulty),
    );
  }

  void changeDifficulty(String difficulty) {
    emit(
      InterviewFormState(direction: state.direction, difficulty: difficulty),
    );
  }

  void changeAll(String direction, String difficulty) {
    emit(InterviewFormState(direction: direction, difficulty: difficulty));
  }
}
