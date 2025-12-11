import '../../../../data/enums/difficulty.dart';
import '../sources/english/go_questions_en.dart';
import '../sources/russian/go_questions_ru.dart';
import '../base_direction.dart';

class GoDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => GoQuestionsRu.junior,
      Difficulty.middle => GoQuestionsRu.middle,
      Difficulty.senior => GoQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
   return switch (difficulty) {
      Difficulty.junior => GoQuestionsEn.junior,
      Difficulty.middle => GoQuestionsEn.middle,
      Difficulty.senior => GoQuestionsEn.senior,
    };
  }
}
