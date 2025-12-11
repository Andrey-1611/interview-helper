import '../../../../data/enums/difficulty.dart';
import '../sources/english/swift_questions_en.dart';
import '../sources/russian/swift_questions_ru.dart';
import '../base_direction.dart';

class SwiftDirection extends BaseDirection {
  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => SwiftQuestionsRu.junior,
      Difficulty.middle => SwiftQuestionsRu.middle,
      Difficulty.senior => SwiftQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => SwiftQuestionsEn.junior,
      Difficulty.middle => SwiftQuestionsEn.middle,
      Difficulty.senior => SwiftQuestionsEn.senior,
    };
  }
}
