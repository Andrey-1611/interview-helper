import '../../../../data/enums/difficulty.dart';
import '../sources/english/devops_questions_en.dart';
import '../sources/russian/devops_questions_ru.dart';
import '../base_direction.dart';

class DevopsDirection extends BaseDirection {
  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => DevopsQuestionsRu.junior,
      Difficulty.middle => DevopsQuestionsRu.middle,
      Difficulty.senior => DevopsQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => DevopsQuestionsEn.junior,
      Difficulty.middle => DevopsQuestionsEn.middle,
      Difficulty.senior => DevopsQuestionsEn.senior,
    };
  }
}
