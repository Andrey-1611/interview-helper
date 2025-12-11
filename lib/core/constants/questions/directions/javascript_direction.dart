import '../../../../data/enums/difficulty.dart';
import '../sources/english/javascript_questions_en.dart';
import '../sources/russian/javascript_questions_ru.dart';
import '../base_direction.dart';

class JavascriptDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => JavascriptQuestionsRu.junior,
      Difficulty.middle => JavascriptQuestionsRu.middle,
      Difficulty.senior => JavascriptQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => JavascriptQuestionsEn.junior,
      Difficulty.middle => JavascriptQuestionsEn.middle,
      Difficulty.senior => JavascriptQuestionsEn.senior,
    };
  }
}
