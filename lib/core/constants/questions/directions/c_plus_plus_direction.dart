import '../../../../data/enums/difficulty.dart';
import '../sources/english/c_plus_plus_questions_en.dart';
import '../sources/russian/c_plus_plus_questions_ru.dart';
import '../sources/russian/go_questions_ru.dart';
import '../base_direction.dart';

class SPlusPlusDirection extends BaseDirection {
  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => CPlusPlusQuestionsRu.junior,
      Difficulty.middle => GoQuestionsRu.middle,
      Difficulty.senior => GoQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => CPlusPlusQuestionsEn.junior,
      Difficulty.middle => CPlusPlusQuestionsEn.middle,
      Difficulty.senior => CPlusPlusQuestionsEn.senior,
    };
  }
}
