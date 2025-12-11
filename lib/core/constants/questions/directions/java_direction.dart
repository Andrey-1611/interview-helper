import '../../../../data/enums/difficulty.dart';
import '../sources/english/java_questions_en.dart';
import '../sources/russian/java_questions_ru.dart';
import '../base_direction.dart';

class JavaDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => JavaQuestionsRu.junior,
      Difficulty.middle => JavaQuestionsRu.middle,
      Difficulty.senior => JavaQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => JavaQuestionsEn.junior,
      Difficulty.middle => JavaQuestionsEn.middle,
      Difficulty.senior => JavaQuestionsEn.senior,
    };
  }
}
