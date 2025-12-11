import '../../../../data/enums/difficulty.dart';
import '../sources/english/kotlin_questions_en.dart';
import '../sources/russian/kotlin_questions_ru.dart';
import '../base_direction.dart';

class KotlinDirection extends BaseDirection {
  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => KotlinQuestionsRu.junior,
      Difficulty.middle => KotlinQuestionsRu.middle,
      Difficulty.senior => KotlinQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => KotlinQuestionsEn.junior,
      Difficulty.middle => KotlinQuestionsEn.middle,
      Difficulty.senior => KotlinQuestionsEn.senior,
    };
  }
}
