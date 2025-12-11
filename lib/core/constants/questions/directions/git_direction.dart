import '../../../../data/enums/difficulty.dart';
import '../sources/english/git_questions_en.dart';
import '../sources/russian/git_questions_ru.dart';
import '../base_direction.dart';

class GitDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => GitQuestionsRu.junior,
      Difficulty.middle => GitQuestionsRu.middle,
      Difficulty.senior => GitQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => GitQuestionsEn.junior,
      Difficulty.middle => GitQuestionsEn.middle,
      Difficulty.senior => GitQuestionsEn.senior,
    };
  }
}
