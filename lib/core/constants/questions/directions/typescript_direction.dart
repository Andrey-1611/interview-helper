import '../../../../data/enums/difficulty.dart';
import '../sources/english/typescript_questions_en.dart';
import '../sources/russian/typescript_questions_ru.dart';
import '../base_direction.dart';

class TypescriptDirection extends BaseDirection {
  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => TypescriptQuestionsRu.junior,
      Difficulty.middle => TypescriptQuestionsRu.middle,
      Difficulty.senior => TypescriptQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => TypescriptQuestionsEn.junior,
      Difficulty.middle => TypescriptQuestionsEn.middle,
      Difficulty.senior => TypescriptQuestionsEn.senior,
    };
  }
}
