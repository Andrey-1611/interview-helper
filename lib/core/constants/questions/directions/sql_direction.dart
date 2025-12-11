import '../../../../data/enums/difficulty.dart';
import '../sources/english/sql_questions_en.dart';
import '../sources/russian/sql_questions_ru.dart';
import '../base_direction.dart';

class SqlDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => SQLQuestionsRu.junior,
      Difficulty.middle => SQLQuestionsRu.middle,
      Difficulty.senior => SQLQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => SQLQuestionsEn.junior,
      Difficulty.middle => SQLQuestionsEn.middle,
      Difficulty.senior => SQLQuestionsEn.senior,
    };
  }
}
