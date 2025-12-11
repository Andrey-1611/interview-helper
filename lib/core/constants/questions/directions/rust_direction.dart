import '../../../../data/enums/difficulty.dart';
import '../sources/english/rust_questions_en.dart';
import '../sources/russian/rust_questions_ru.dart';
import '../base_direction.dart';

class RustDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => RustQuestionsRu.junior,
      Difficulty.middle => RustQuestionsRu.middle,
      Difficulty.senior => RustQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => RustQuestionsEn.junior,
      Difficulty.middle => RustQuestionsEn.middle,
      Difficulty.senior => RustQuestionsEn.senior,
    };
  }
}
