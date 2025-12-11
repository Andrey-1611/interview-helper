import '../../../../data/enums/difficulty.dart';
import '../sources/english/flutter_questions_en.dart';
import '../sources/russian/flutter_questions_ru.dart';
import '../base_direction.dart';

class FlutterDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => FlutterQuestionsRu.junior,
      Difficulty.middle => FlutterQuestionsRu.middle,
      Difficulty.senior => FlutterQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => FlutterQuestionsEn.junior,
      Difficulty.middle => FlutterQuestionsEn.middle,
      Difficulty.senior => FlutterQuestionsEn.senior,
    };
  }
}
