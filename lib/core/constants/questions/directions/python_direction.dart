import '../../../../data/enums/difficulty.dart';
import '../sources/english/python_questions_en.dart';
import '../sources/russian/php_questions_ru.dart';
import '../sources/russian/python_questions_ru.dart';
import '../base_direction.dart';

class PythonDirection extends BaseDirection {

  @override
  List<String> getRussianQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => PythonQuestionsRu.junior,
      Difficulty.middle => PythonQuestionsRu.middle,
      Difficulty.senior => PythonQuestionsRu.senior,
    };
  }

  @override
  List<String> getEnglishQuestions(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.junior => PythonQuestionsEn.junior,
      Difficulty.middle => PythonQuestionsEn.middle,
      Difficulty.senior => PythonQuestionsEn.senior,
    };
  }
}
