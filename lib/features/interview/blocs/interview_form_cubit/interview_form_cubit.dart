import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/enums/difficulty.dart';
import '../../../../data/enums/direction.dart';
import '../../../../data/enums/language.dart';

part 'interview_form_state.dart';

class InterviewFormCubit extends Cubit<InterviewFormState> {
  InterviewFormCubit() : super(InterviewFormState());

  void changeDirection(Direction direction) {
    emit(state.copyWith(direction: direction));
  }

  void changeDifficulty(Difficulty difficulty) {
    emit(state.copyWith(difficulty: difficulty));
  }

  void changeLanguage(Language language) {
    emit(state.copyWith(language: language));
  }

  void changeAll(
    Direction direction,
    Difficulty difficulty,
    Language language,
  ) {
    emit(
      state.copyWith(
        direction: direction,
        difficulty: difficulty,
        language: language,
      ),
    );
  }
}
