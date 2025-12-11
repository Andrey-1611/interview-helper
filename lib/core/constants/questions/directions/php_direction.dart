import '../../../../data/enums/difficulty.dart';
import '../sources/english/php_questions_en.dart';
import '../sources/russian/php_questions_ru.dart';
import '../base_direction.dart';

class PhpDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => PhpQuestionsRu.junior,
      Difficulty.middle => PhpQuestionsRu.middle,
      Difficulty.senior => PhpQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => PhpQuestionsEn.junior,
      Difficulty.middle => PhpQuestionsEn.middle,
      Difficulty.senior => PhpQuestionsEn.senior,
    };
  }
}
